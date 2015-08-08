# Holds the options for a Radio or Dropdown input.

class Option < ActiveRecord::Base

	# Relate to Fields.
	belongs_to :field, inverse_of: :options
	
end
