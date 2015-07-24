class Template < ActiveRecord::Base
	has_and_belongs_to_many :admins
	has_and_belongs_to_many :users
	has_and_belongs_to_many :reports
	has_many :sections, dependent: :destroy
	accepts_nested_attributes_for :sections
	has_many :fields, through: :sections

	def as_json(jsonoptions={})
		super(:only => [:id, :name, :allow_title]).merge(sections: sections)
	end
end
