class Column < ActiveRecord::Base
	belongs_to :section, inverse_of: :columns
	has_many :fields, dependent: :destroy
	accepts_nested_attributes_for :fields	

	def as_json(jsonoptions={})
		super(:only => [:id]).merge(fields: fields)
	end
end