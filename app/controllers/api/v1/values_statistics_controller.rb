module Api::V1 #:nodoc:

	# Generates a response specifically to perform statistics on Values.
	class ValuesStatisticsController < ApiController
		def index
			render json: current_user.templates.all.to_json(
				:include => { :fields => {
					:include => :values
				}}
			)
		end
	end
end