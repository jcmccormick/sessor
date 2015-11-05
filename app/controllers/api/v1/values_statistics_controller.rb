module Api::V1 #:nodoc:

	# Generates a response specifically to perform statistics on Values.
	class ValuesStatisticsController < ApiController
		def index
			render json: current_user.templates.includes(:fields).where.not('fields.fieldtype' => 'labelntext').as_json(only: [:id, :name], include: {fields: {only: [:id, :name, :placeholder]}})
		end

		def counts

			from = params[:from] || params[:days].to_i.days.ago.to_time.beginning_of_day
			to = params[:to] || 0.days.ago.to_time.end_of_day


			all_data = current_user.values.all
						.where(field_id: params[:field_id], created_at: from .. to)
						.where.not(input: nil)
						.order(input: :desc)
						.group_by { |value| value['created_at'].to_date}
						.map {|k,v| [k,v]}

			grouped = (0..params[:days].to_i-1).to_a.inject([]) do |memo, i|
				if all_data[i].present?
					date = all_data[i][0].to_time
					values = all_data[i][1].group_by { |value| value.input }.map { |k, v| {input:k, count:v.length} }.sort! { |x,y| x['input'] <=> y['input']}
					total = 0
					values.each do |value|
						total = total + value[:count]
					end
				else
					date = ((i-params[:days].to_i+1)*-(1)).days.ago.beginning_of_day
				end
				memo << {'date': date, 'total': total || 0, 'values': values || []}
				memo
			end

			grouped = grouped.sort_by { |day| day[:date] }

			render json: grouped
		end

	end
end