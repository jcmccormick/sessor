module Api::V1 #:nodoc:

	# Collects data for viewing on the Dekstop page.
	class DesktopStatisticsController < ApiController
		def index
			render json: {
				:temp_count => current_user.templates.count,
				:repo_count => current_user.reports.count,
				:templates => current_user.templates.order('updated_at desc').limit(5).as_json(:only => [:id, :name, :updated_at, :draft]),
				:reports => current_user.reports.order('reports.updated_at desc').limit(5).as_json(:only => [:id, :title, :updated_at], include: {templates: {only: [:id, :name]}})
			}
		end
	end
end