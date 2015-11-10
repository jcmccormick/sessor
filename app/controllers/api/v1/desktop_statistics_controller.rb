module Api::V1 #:nodoc:

	# Collects data for viewing on the Dekstop page.
	class DesktopStatisticsController < ApiController
		def index
			render json: {
				:templates => current_user.templates .as_json(:only => [:id, :name, :updated_at, :draft]),
				:reports => current_user.reports.as_json(:only => [:id, :title, :updated_at], include: {templates: {only: [:id, :name]}})
			}
		end
	end
end