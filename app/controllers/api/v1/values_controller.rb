# Values Controller
module Api::V1 #:nodoc:
	class ValuesController < ApiController

		def index
			@values = current_user.values.where(report_id: params[:report_id])
		end

		def show
			@value = current_user.values.find(params[:id])
		end

		def create
			report = current_user.reports.find(params[:report_id])
			@value = report.values.new(allowed_params)
			@value.save
			render 'show', status: 201
		end

		def update
			value = current_user.values.find(params[:id])
			value.update(allowed_params)
			head :no_content
		end

		def destroy
			value = current_user.values.find(params[:id])
			value.destroy
			head :no_content
		end

		private
			def allowed_params
				params.require(:value).permit(:input)
			end
	end
end