# Templates Controller
module Api::V1#:nodoc:
	class TemplatesController < ApiController

		nested_attributes_names = Template.nested_attributes_options.keys.map do |key|
			key.to_s.concat('_attributes').to_sym
		end
		wrap_parameters include: Template.attribute_names + nested_attributes_names

		def index
			render json: current_user.templates.as_json(only: [:id, :name, :updated_at, :draft] )
		end

		def show
			@template = current_user.templates.eager_load(:fields).find(params[:id])
		end

		def create
			spreadsheet = google_drive.create_spreadsheet(params[:name])
			worksheet = spreadsheet.worksheets[0]
			worksheet_url = worksheet.cells_feed_url
			@template = current_user.templates.new(allowed_params)
			@template.gs_id = worksheet_url
			@template.save
			current_user.templates << @template
			render 'show', status: 201
		end

		def update
			template = current_user.templates.find(params[:id])
			update_worksheet if params[:fields_attributes]
			template.sections = params[:sections]
			template.update_attributes(allowed_params)
			current_user.templates << template unless current_user.templates.include?(template)
			head :no_content
		end

		def destroy
			template = current_user.templates.find(params[:id])
			if template.destroy
				google_drive.file_by_id(template.gs_id).delete()
				head :no_content
			else
				render json: { errors: 'A page may not be deleted while being used in a report.' }, status: 422
			end
		end

		private
			def allowed_params
				params.require(:template).permit(
					:name, :gs_id, :draft, :private_group, :private_world, :group_id, :group_edit, :group_editors,
					{:sections => []},
					{:fields_attributes => [
						:id, :fieldtype, :_destroy, {:o => [
							:section_id, :column_id, :column_order, :name, :placeholder, :tooltip, :required, :disabled, :glyphicon, :default_value, {:options => []}
						]}
					]}
				)
			end

			def update_worksheet
				template = current_user.templates.find_by_id(params[:id])
				fields_names = template.fields.where.not(fieldtype: 'labelntext').only(:o).map{ |x| x.o['name'] }.sort_by { |n| n.downcase }
				new_fields_names = params[:fields_attributes].select { |x| x['fieldtype'] != 'labelntext' }.map{ |x| x['o']['name'] }.sort_by { |n| n.downcase }
				comparative = fields_names-new_fields_names
				new_fields_names.unshift 'Updated At'
				new_fields_names.unshift 'Created At'
				new_fields_names.unshift 'Report ID'
				if comparative.length > 0 || template.name != params[:name]
					pp new_fields_names
					worksheet = google_drive.worksheet_by_url(template.gs_id)
					worksheet.title = params[:name]
					worksheet.list.keys = new_fields_names
					worksheet.save
				end
			end
	end
end
