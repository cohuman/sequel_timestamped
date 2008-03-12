module Sequel
  module Plugins
    module Timestamped
      # Apply the plugin to the model.
      def self.apply(model, options = {})
        model.send(:include, InstanceMethods)
        
        model.before_create { set_created_at; set_updated_at }
        model.before_update { set_updated_at }
      end

      module InstanceMethods
        # Define methods that will be instance-specific here.
        def set_created_at
          self.created_at = Time.now if self.columns.include?(:created_at)
        end
        
        def set_updated_at
          self.updated_at = Time.now if self.columns.include?(:updated_at)
        end
      end
    end
  end
end
