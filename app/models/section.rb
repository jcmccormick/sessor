class Section < ActiveRecord::Base
	belongs_to :template
	has_many :columns, dependent: :destroy
  	accepts_nested_attributes_for :columns
end
