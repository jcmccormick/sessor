module Api::V1 #:nodoc:

	# Generates a response specifically to perform statistics on Values.
	class ValuesStatisticsController < ApiController
		def counts

			from = params[:from] || (params[:days].to_i-1).days.ago.to_date
			to = params[:to] || 0.days.ago.to_date

			all_data = current_user.values.all
						.where(field_id: params[:field_id], created_at: from.beginning_of_day .. to.end_of_day)
						.where.not(input: nil)
						.order(input: :desc)
						.group_by { |value| [value['created_at'].to_date, value['input']] }
						.map { |k, v| {'date': k.first, 'input': k.last, 'count': v.length} }

			pp all_data

			# the object which will hold the data to be returned
			grouped = {:cols => [], :rows => []}

			# Populate columns with a determined set of values for inputs
			diffvals = Array.new
			all_data.each { |day| diffvals.push day[:input] }
			diffvals = diffvals.uniq
			diffvals.each { |input| grouped[:cols].push({'id': "#{input}-id", 'label': input, 'type': 'number'}) }
			grouped[:cols].unshift({'id': 'day', 'label': 'Date', 'type': 'string'})

			# Create a set of dates that the actual data will be merged into
			zeros = Array.new
			(0..params[:days].to_i-1).each do |n|
				diffvals.each do |input|
					hash = Hash.new
					hash[:date], hash[:input], hash[:count] = n.days.ago.to_date, input, 0
					zeros.push hash
				end
			end

			# Group the data by date after mapping the actual data into the premade set of dates
			data_by_date = zeros.map do |first_hash| 
				all_data.each do |second_hash|
					if first_hash[:date] == second_hash[:date] && first_hash[:input] == second_hash[:input]
						first_hash[:count] = second_hash[:count]
						break
					end
				end
				first_hash
			end.group_by { |i| i[:date]}

			# Populate rows of data
			data_by_date.each_with_index do |(date, values), day|
				grouped[:rows][day] = {c: [{ v: date }] }
				(0..diffvals.length-1).each { |value| grouped[:rows][day][:c].push({v: values[value][:count] }) }
				grouped[:rows][day][:c].push({v: values.map {|v| v[:count]}.reduce(0, :+) })
			end 

			grouped[:cols].push({'id': "s", 'label': "Total", 'type': 'number'}) 

			grouped[:rows].reverse!

			render json: grouped
		end

	end
end