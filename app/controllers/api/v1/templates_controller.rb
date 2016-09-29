# Templates Controller
module Api::V1#:nodoc:
    class TemplatesController < ApplicationController
        # before_action :authenticate_user!
        include Sheeted

        wrap_parameters include: Template.wrapped_params

        def index
            render json: templates.as_json(only: [:id, :name, :updated_at, :draft, :sections], include: [:fields] )
        end

        def show
            @template = templates.eager_load(:fields).find(params[:id])
        end

        def create
            #ss = create_spreadsheet(params[:name])
            @template = templates.new(allowed_params)
            #@template.gs_url = ss.human_url
            #@template.gs_key = ss.key
            #@template.gs_id = ss.worksheets[0].cells_feed_url
            @template.save
            templates << @template
            render 'show', status: 201
        end

        def update
            template = templates.find(params[:id])
            #update_worksheet if params[:fields_attributes]
            #update_name if params[:name] != template.name
            template.sections = params[:sections]
            template.update_attributes(allowed_params)
            templates << template unless templates.include?(template)
            head :no_content
        end

        def destroy
            template = templates.find(params[:id])
            if template.allow_destroy
                #google_drive.spreadsheet_by_key(template.gs_key).delete if template.gs_key
                template.destroy
                head :no_content
            else
                render json: { errors: 'A page may not be deleted while being used in a report.' }, status: 422
            end
        end

        private
            def allowed_params
                params.require(:template).permit(
                    :name, :gs_id, :gs_key, :gs_url, :draft, :private_group, :private_world, :group_id, :group_edit, :group_editors,
                    {:sections => []},
                    {:fields_attributes => [
                        :id, :fieldtype, :_destroy, {:o => [
                            :section_id, :column_id, :column_order, :name, :placeholder, :tooltip, :required, :disabled, :glyphicon, :default_value, {:options => []}
                        ]}
                    ]}
                )
            end

            def update_worksheet
                if googler
                    if (formatted_params-formatted_fields).any? || params[:update_keys]
                        get_sheet

                        ws.list.keys = if ws.list.keys.length < 3
                            # If there are less than 3 keys, it is a new worksheet, so initialize all fields
                            base_keys + formatted_params
                        else
                            # else we need to refresh keys and find any new keys to add to the base
                            base_keys + refreshed_existing_keys + new_keys
                        end

                        ws.save if ws.dirty?

                    end
                end
            end

            def update_name
                if googler
                    ss = google_drive.spreadsheet_by_key(template.gs_key)
                    ss.title = params[:name]
                end
            end

            def ws
                @ws
            end

            def get_sheet
                @ws = google_drive.spreadsheet_by_key(template.gs_key).worksheets[0]
            end

            def template
                templates.find(params[:id])
            end

            def fields
                template.fields
            end

            def formatted_fields
                fields.select { |x| x.fieldtype != 'labelntext' }.map { |x| "#{x.id} #{x.o['name']}"}
            end

            def formatted_params
                params[:fields_attributes].select { |x| x['fieldtype'] != 'labelntext' }.map { |x| "#{x['id']} #{x['o']['name']}" }
            end

            def base_keys
                ['Report ID', 'Created At', 'Updated At']
            end

            def worksheet_keys
                keys = ws.list.keys.drop(3)
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
