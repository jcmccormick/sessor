class Field < ActiveRecord::Base
	belongs_to :column, inverse_of: :fields
	has_many :values
	accepts_nested_attributes_for :values
	has_many :options, dependent: :destroy
	accepts_nested_attributes_for :options  
	
	def as_json(jsonoptions={})
		super(:only => [:id, :name, :fieldtype, :glyphicon, :required, :disabled]).merge(options: options).merge(values: [values.first])
	end
end
