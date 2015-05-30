module Api
	module V1
		class ReportsController < ApplicationController
			respond_to :json

			def index
				respond with Report.all
			end

			def show
				respond with Report.find(params[:id])
			end

			def create
				respond with Report.create(params[:report])
			end

			def update
				respond with Report.update(params[:id], params[:report])
			end

			def destroy
				respond with Report.destroy(params[:id])
			end
		end
	end
end