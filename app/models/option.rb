class Option < ActiveRecord::Base
	belongs_to :field, inverse_of: :options

	def as_json(jsonoptions={})
		super(:only => [:id, :name])
	end
end
