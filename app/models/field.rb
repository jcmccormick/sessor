# Fields are created at-will and linked to their parent Column. They contain Options in the case of Radio or Dropdown fields, and a Value that contains no Report ID (the Default Value).

class Field < ActiveRecord::Base

	validates :template, :section_id, :column_id, :column_order, presence: true

	belongs_to :template

	serialize :options, Array

	after_save do 
		template.touch
	end

end
