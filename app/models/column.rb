# Columns are created at the same time a Section is created.

class Column < ActiveRecord::Base

	# Relate to Sections.
	belongs_to :section, inverse_of: :columns

	# Relate to Fields.
	has_many :fields, dependent: :destroy

	# Saving a Column saves its associated Fields.
	accepts_nested_attributes_for :fields

	# Override standard JSON response.
	#
	# * Return only the ID fields.
	# * Merge associated Fields into the response.	
	def as_json(jsonoptions={})
		super(:only => [:id]).merge(fields: fields)
	end
end