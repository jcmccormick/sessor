# Templates Controller
module Api::V1#:nodoc:
    class TemplatesController < ApplicationController
        before_action :authenticate_user!
        include Sheeted

        wrap_parameters include: Template.wrapped_params

        def index
            render json: current_user.templates.as_json(only: [:id, :name, :updated_at, :draft] )
        end

        def show
            @template = current_user.templates.eager_load(:fields).find(params[:id])
        end

        def create
            create_spreadsheet(params[:name])
            @template = current_user.templates.new(allowed_params)
            @template.gs_url = @spreadsheet.human_url
            @template.gs_id = @spreadsheet.worksheets[0].cells_feed_url
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
            if template.allow_destroy
                call_spreadsheet(template.name)
                spreadsheet.delete
                template.destroy
                head :no_content
            else
                render json: { errors: 'A page may not be deleted while being used in a report.' }, status: 422
            end
        end

        private
            def allowed_params
                params.require(:template).permit(
                    :name, :gs_url, :gs_id, :draft, :private_group, :private_world, :group_id, :group_edit, :group_editors,
                    {:sections => []},
                    {:fields_attributes => [
                        :id, :fieldtype, :_destroy, {:o => [
                            :section_id, :column_id, :column_order, :name, :placeholder, :tooltip, :required, :disabled, :glyphicon, :default_value, {:options => []}
                        ]}
                    ]}
                )
            end

            def update_worksheet
                if (formatted_params-formatted_fields).any? || params[:update_keys]
                    call_worksheet(template.gs_id)

                    worksheet.list.keys = if worksheet.list.keys.length < 3
                        # If there are less than 3 keys, it is a new worksheet, so initialize all fields
                        base_keys + formatted_params
                    else
                        # else we need to refresh keys and find any new keys to add to the base
                        base_keys + refreshed_existing_keys + new_keys
                    end

                    worksheet.save if worksheet.dirty?
                end

            end

            def template
                current_user.templates.find(params[:id])
            end

            def fields
                template.fields
            end

            def base_keys
                ['Report ID', 'Created At', 'Updated At']
            end

            def formatted_fields
                fields.select { |x| x.fieldtype != 'labelntext' }.map { |x| "#{x.id} #{x.o['name']}"}
            end

            def formatted_params
                params[:fields_attributes].select { |x| x['fieldtype'] != 'labelntext' }.map { |x| "#{x['id']} #{x['o']['name']}" }
            end

            def worksheet_keys
                keys = worksheet.list.keys.drop(3)
                keys
            end

            def refreshed_existing_keys
                keys = Array.new
                worksheet_keys.each do |key|
                    formatted_params.each do |field|
                        key = field if key[/\d+/] === field[/\d+/] || key.partition(' ').last === field.partition(' ').last
                    end
                    keys.push key unless keys.include?(key)
                end
                keys
            end

            def new_keys
                keys = Array.new
                formatted_params.each do |field|
                    keys.push field unless refreshed_existing_keys.include?(field)
                end
                keys
            end

    end
end
