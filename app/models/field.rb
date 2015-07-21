class Field < ActiveRecord::Base
	belongs_to :column, inverse_of: :fields
	has_many :values
	has_many :options, dependent: :destroy
  	accepts_nested_attributes_for :values
  	accepts_nested_attributes_for :options
end
