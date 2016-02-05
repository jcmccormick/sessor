# Reports Controller
module Api::V1 #:nodoc:
    class ReportsController < ApplicationController
        before_action :authenticate_user!
        # include Sheeted

        wrap_parameters include: Report.wrapped_params

        def index
            render json: current_user.reports.as_json(only: [:id, :title, :updated_at, :template_order])
        end

        def show
            @report = current_user.reports.eager_load({:templates => :fields}).find(params[:id])
        end

        def create
            @report = current_user.reports.new(allowed_params)
            @report.save
            current_user.reports << @report
            update_worksheet(@report)
            update_templates(@report)
            render 'show', status: 201
        end

        def update
            report = current_user.reports.find(params[:id])
            current_user.reports << report unless current_user.reports.include?(report)

            if params.has_key?(:did)
                report.disassociate_template(params[:did])
                report.update_attributes(params.require(:report).permit({:template_order => []}))
            else
                update_worksheet(report)
                update_templates(report)
                report.update_attributes(allowed_params)
            end
            
            report.touch if report.values.find_index { |x| x.changed? }

            head :no_content
        end

        def destroy
            report = current_user.reports.find(params[:id])
            report.destroy
            head :no_content
        end

        private
            def allowed_params
                params.require(:report).permit(
                    :id, :title, {:template_order => []}, :allow_title, :submission, :response, :active, :location,
                    values_attributes: [
                        :id, :input, :field_id, :report_id
                    ]      
                )
            end

            def update_templates(report)
                params[:template_order].each do |tid|
                    template = current_user.templates.find_by_id(tid)
                    report.templates << template unless report.templates.include?(template)
                end
            end

            def update_worksheet(report)
                current_user.googler && report.template_order.each do |template_id|
                    template = current_user.templates.find_by_id(template_id)
                    fields = template.fields.where.not(fieldtype: 'labelntext')
                    report.templates << template unless report.templates.include?(template)
                    
                    if fields.any? && params[:values_attributes] && ws = google_drive.worksheet_by_url(template.gs_id)
                        ids = ws.rows.map { |x| x[0].to_i }.drop(1)
                        searched = [*ids.each_with_index].bsearch { |x, _| x >= report.id.to_i}
                        if searched
                            index = searched.last + 2
                            ws[index, 3] = Time.now
                            params[:values_attributes].each do |value|
                                fields.each do |field|
                                    list_index = ws.list.keys.find_index("#{field.id} #{field.o['name']}") + 1
                                    ws[index, list_index] = value['input'] if value['field_id'] == field.id
                                end
                            end
                        else
                            new_row = Hash.new
                            new_row['Report ID'] = report.id
                            new_row['Created At'] = report.created_at
                            new_row['Updated At'] = Time.now
                            fields.each do |field|
                                new_row["#{field.id} #{field.o['name']}"] = field.o['default_value']
                            end
                            ws.list.push new_row
                        end

                        ws.save if ws.dirty?
                    end
                end
            end
    end
end
