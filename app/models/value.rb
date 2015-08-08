# A Value contains an "input" field which populates the data seen in the HTML form.

class Value < ActiveRecord::Base

	# Relates to Field.
	belongs_to :field

	# Relates to Report.
	belongs_to :report

end
