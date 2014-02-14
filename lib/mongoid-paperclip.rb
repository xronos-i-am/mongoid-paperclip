# encoding: utf-8

require "mongoid-paperclip/version"
require "active_support/concern"

begin
  require "paperclip"
rescue LoadError
  puts "Mongoid::Paperclip requires that you install the Paperclip gem."
  exit
end

##
# the id of mongoid is not integer, correct the id_partitioin.
Paperclip.interpolates :id_partition do |attachment, style|
  attachment.instance.id.to_s.scan(/.{4}/).join("/")
end

Paperclip.interpolates :id_partition_in_8 do |attachment, style|
  attachment.instance.id.to_s.scan(/.{8}/).join("/")
end

##
# mongoid criteria uses a different syntax.
module Paperclip
  module Helpers
    # Find all instances of the given Active Record model +klass+ with attachment +name+.
    # This method is used by the refresh rake tasks.
    def each_instance_with_attachment(klass, name)
      if defined?(Mongoid::Document) && class_for(klass) < Mongoid::Document
        class_for(klass).unscoped.where("#{name}_file_name" => {:$exists => true}).to_a.map do |instance|
          yield(instance)
        end
      else
        class_for(klass).unscoped.where("#{name}_file_name IS NOT NULL").find_each do |instance|
          yield(instance)
        end
      end
    end
  end
end

##
# The Mongoid::Paperclip extension
# Makes Paperclip play nice with the Mongoid ODM
#
# Example:
#
#  class User
#    include Mongoid::Document
#    include Mongoid::Paperclip
#
#    has_mongoid_attached_file :avatar
#  end
#
# The above example is all you need to do. This will load the Paperclip library into the User model
# and add the "has_mongoid_attached_file" class method. Provide this method with the same values as you would
# when using "vanilla Paperclip". The first parameter is a symbol [:field] and the second parameter is a hash of options [options = {}].
#
# Unlike Paperclip for ActiveRecord, since MongoDB does not use "schema" or "migrations", Mongoid::Paperclip automatically adds the neccesary "fields"
# to your Model (MongoDB collection) when you invoke the "#has_mongoid_attached_file" method. When you invoke "has_mongoid_attached_file :avatar" it will
# automatially add the following fields:
#
#  field :avatar_file_name,    :type => String
#  field :avatar_content_type, :type => String
#  field :avatar_file_size,    :type => Integer
#  field :avatar_updated_at,   :type => DateTime
#  field :avatar_fingerprint,  :type => String

# TODO Remove when https://github.com/thoughtbot/paperclip/issues/1403 is merged
require 'paperclip/callbacks'
module Paperclip
  module Callbacks
    module Defining
      def define_paperclip_callbacks(*callbacks)
        define_callbacks *[callbacks, {:terminator => callback_terminator}].flatten
        callbacks.each do |callback|
          eval <<-end_callbacks
            def before_#{callback}(*args, &blk)
              set_callback(:#{callback}, :before, *args, &blk)
            end
            def after_#{callback}(*args, &blk)
              set_callback(:#{callback}, :after, *args, &blk)
            end
          end_callbacks
        end
      end
      private
      def callback_terminator
        if ::ActiveSupport::VERSION::STRING >= '4.1'
          lambda { |target, result| result == false }
        else
          'result == false'
        end
      end
    end
  end
end


module Mongoid
  module Paperclip
    extend ActiveSupport::Concern

    module ClassMethods
      
      # https://github.com/meskyanichi/mongoid-paperclip/pull/45
      def after_commit(*args, &block)
        options = args.pop if args.last.is_a? Hash
        if options
          case options[:on]
          when :create
            after_create(*args, &block)
          when :update
            after_update(*args, &block)
          when :destroy
            after_destroy(*args, &block)
          else
            after_save(*args, &block)
          end
        else
          after_save(*args, &block)
        end
      end
      
      # Adds Mongoid::Paperclip's "#has_mongoid_attached_file" class method to the model
      # which includes Paperclip and Paperclip::Glue in to the model. Additionally
      # it'll also add the required fields for Paperclip since MongoDB is schemaless and doesn't
      # have migrations.
      def has_mongoid_attached_file(field_name, options = {})
        # Include Paperclip and Paperclip::Glue for compatibility
        unless self.ancestors.include?(::Paperclip)
          include ::Paperclip
          include ::Paperclip::Glue
        end
        
        # Invoke Paperclip's #has_attached_file method and passes in the
        # arguments specified by the user that invoked Mongoid::Paperclip#has_mongoid_attached_file
        has_attached_file(field_name, options)

        # Define the necessary collection fields in Mongoid for Paperclip
        field :"#{field_name}_file_name",    type: String
        field :"#{field_name}_content_type", type: String
        field :"#{field_name}_file_size",    type: Integer
        field :"#{field_name}_updated_at",   type: Time
        field :"#{field_name}_fingerprint",  type: String
        
        # convenience attr (RailsAdmin uses this naming)
        attr_accessor :"delete_#{field_name}"
        before_validation do
           self.send(field_name).clear if self.send(:"delete_#{field_name}").present? && self.send(:"delete_#{field_name}") && self.send(:"delete_#{field_name}") != '0'
        end
      end
    end
  end
end
