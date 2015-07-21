class Option < ActiveRecord::Base
	belongs_to :field, inverse_of: :options
end
