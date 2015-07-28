# Holds the options for a Radio or Dropdown input.

class Option < ActiveRecord::Base

	# Relate to Fields.
	belongs_to :field, inverse_of: :options

	# Override standard JSON response.
	#
	# * Return only the ID and Name fields.
	def as_json(jsonoptions={})
		super(:only => [:id, :name])
	end
end
