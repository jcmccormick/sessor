# Fields are created at-will and linked to their parent Column. They contain Options in the case of Radio or Dropdown fields, and a Value that contains no Report ID (the Default Value).

class Field < ActiveRecord::Base

	# Relate to Columns.
	belongs_to :template, inverse_of: :fields, :touch => true

	serialize :options, Array

end
