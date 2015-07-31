# A Value contains an "input" field which populates the data seen in the HTML form.

class Value < ActiveRecord::Base

	# Relates to Field.
	belongs_to :field

	# Relates to Report.
	belongs_to :report

	# Override standard JSON response.
	#
	# * Return only the ID, Input, and Field_ID fields.
	def as_json(jsonoptions={})
		super(:only => [:id, :input, :field_id])
	end
end
