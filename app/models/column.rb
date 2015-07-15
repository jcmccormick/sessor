class Column < ActiveRecord::Base
	belongs_to :section
	has_many :fields, dependent: :destroy
  	accepts_nested_attributes_for :fields
end
