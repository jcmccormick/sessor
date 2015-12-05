module Nested
    extend ActiveSupport::Concern

    module ClassMethods
        def wrapped_params
            self.attribute_names + self.nested_attributes_options.keys.map { |key| key.to_s.concat('_attributes').to_sym }
        end
    end

end