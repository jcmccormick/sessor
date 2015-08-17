# Fields are created at-will and linked to their parent Column. They contain Options in the case of Radio or Dropdown fields, and a Value that contains no Report ID (the Default Value).

class Field < ActiveRecord::Base

	# Relate to Columns.
	belongs_to :template, inverse_of: :fields

	# Relate to the first Value related to the Field, used as a default value.
	has_many :values, -> { where report_id: nil }, dependent: :destroy

	# Saving a Field saves its associated Values.
	accepts_nested_attributes_for :values

	# Relate to Options.
	has_many :options, dependent: :destroy

	# Saving a Field saves its associated Options.
	accepts_nested_attributes_for :options
end
