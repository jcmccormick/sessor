# Fields are created at-will and linked to their parent Column. They contain Options in the case of Radio or Dropdown fields, and a Value that contains no Report ID (the Default Value).

class Field < ActiveRecord::Base

	# Relate to Columns.
	belongs_to :column, inverse_of: :fields

	# Relate to Values.
	has_many :values

	# Saving a Field saves its associated Values.
	accepts_nested_attributes_for :values

	# Relate to Options.
	has_many :options, dependent: :destroy

	# Saving a Field saves its associated Options.
	accepts_nested_attributes_for :options
	
	# Override standard JSON response.
	#
	# * Return only the ID, Name, Fieldtype, Glyphicon, Required, and Disabled fields.
	# * Merge associated Options and the first Value. (Returning only the first Value assures that when you call any given Template or Report, you will never receive all previously recorded Values for each Field in said Template or Report)
	def as_json(jsonoptions={})
		super(:only => [:id, :name, :fieldtype, :glyphicon, :required, :disabled]).merge(options: options).merge(values: [values.first])
	end
end
