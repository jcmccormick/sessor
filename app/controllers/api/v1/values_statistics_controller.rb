module Api::V1 #:nodoc:

	# Generates a response specifically to perform statistics on Values.
	class ValuesStatisticsController < ApiController
		def index
			render json: current_user.templates.as_json(only: [:id, :name])
		end
	end
end