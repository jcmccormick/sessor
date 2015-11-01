module Api::V1 #:nodoc:

	# Generates a response specifically to perform statistics on Values.
	class ValuesStatisticsController < ApiController
		def index
			render json: current_user.templates.includes(:fields).where.not('fields.fieldtype' => 'labelntext').as_json(only: [:id, :name], include: {fields: {only: [:id, :name, :placeholder]}})
		end

		def counts
			days = (params[:days] || 30).to_i
			#fields = current_user.templates.find(params[:template_id]).fields.as_json(only: [:id, :name])
			
			field = current_user.fields.find(params[:field_id])

			field_data = (0..days-1).to_a.inject([]) do |memo, i|
				date = i.days.ago.to_date
				from, to = date.beginning_of_day, date.end_of_day
				all = current_user.values.where(field_id: field['id'], created_at: from .. to)
				total_count = all.count
				values = all.group(:input).uniq.count.map { |k,v| {input:k,count:v} }
				memo <<  {'date': date, 'total': total_count, 'values': values}
				memo
			end

			render json: field_data
		end

	end
end