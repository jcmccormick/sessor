class Field < ActiveRecord::Base
	belongs_to :column
	has_many :options, dependent: :destroy
  	accepts_nested_attributes_for :options
end
