class Section < ActiveRecord::Base
	belongs_to :template, inverse_of: :sections
	has_many :columns, dependent: :destroy
	accepts_nested_attributes_for :columns
	has_many :fields, through: :columns
end