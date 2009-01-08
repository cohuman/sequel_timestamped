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
          if self.columns.include?(:created_at)
            self.created_at = Time.now unless self.created_at
          end
        end
        
        def set_updated_at
          if self.columns.include?(:updated_at)
            if self.updated_at.nil?
              self.updated_at = Time.now
            else
              if self.new?
                self.updated_at = values[:updated_at] || Time.now
              else
                self.updated_at = if self.changed_columns.include?(:updated_at)
                  values[:updated_at]
                else
                  Time.now
                end
              end
            end
          end
        end
      end
    end
  end
end
