class Value < ActiveRecord::Base
	belongs_to :field
	belongs_to :report

	def as_json(jsonoptions={})
		super(:only => [:id, :input, :field_id])
	end
end
