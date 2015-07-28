# A Section houses links a collection of Columns to the Template.

class Section < ActiveRecord::Base

	# Relate to Templates.
	belongs_to :template, inverse_of: :sections

	# Relate to Columns.
	has_many :columns, dependent: :destroy

	# Saving a Section saves its associated Columns.
	accepts_nested_attributes_for :columns

	# Chain-relationship to allow for `Template.fields` usage.
	has_many :fields, through: :columns	

	# Override standard JSON response.
	#
	# * Return only the ID and Name fields.
	# * Merge associated Columns.	
	def as_json(jsonoptions={})
		super(:only => [:id, :name]).merge(columns: columns)
	end
end