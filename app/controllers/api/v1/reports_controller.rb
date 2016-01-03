# Reports Controller
module Api::V1 #:nodoc:
    class ReportsController < ApplicationController
        before_action :authenticate_user!
        include Sheeted

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
            render 'show', status: 201
        end

        def update
            report = current_user.reports.find(params[:id])
            report.template_order = params[:template_order]
            if params.has_key?(:did)
                report.disassociate_template(params[:did])
                report.update_attributes(params.require(:report).permit({:template_order => []}))
            else
                update_worksheet(report)
                report.update_attributes(allowed_params)
            end
            current_user.reports << report unless current_user.reports.include?(report)
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
                        :id, :input, :field_id
                    ]      
                )
            end

            def update_worksheet(report)
                report.template_order.each do |template_id|
                    template = current_user.templates.find_by_id(template_id)
                    report.templates << template unless report.templates.include?(template)
                    

                    if template.fields.length && worksheet = google_drive.worksheet_by_url(template.gs_id)
                        report_found = false
                        worksheet.list.each do |row|
                            if row['Report ID'] == report.id.to_s
                                report_found = true
                                row['Updated At'] = Time.now
                                template.fields.where.not(fieldtype: 'labelntext').each do |field|
                                    params[:values_attributes].each do |value|
                                        puts value
                                        if field.id.to_s == value['field_id'].to_s
                                            row["#{field.id} #{field.o['name']}"] = value['input']
                                        end
                                    end
                                end
                            end
                        end
                        if !report_found
                            new_row = Hash.new
                            new_row['Report ID'] = report.id
                            new_row['Created At'] = report.created_at
                            new_row['Updated At'] = Time.now
                            template.fields.where.not(fieldtype: 'labelntext').each do |field|
                                new_row["#{field.id} #{field.o['name']}"] = field.o['default_value']
                            end
                            worksheet.list.push new_row
                        end
                        worksheet.save if worksheet.dirty?
                    end
                end
            end

            def call_worksheet
                @report.template_order
            end


                        # field_ids = template.fields.map { |x| x.id }
                        # if template.fields.where.not(fieldtype: 'labelntext').count > values.where(field_id: field_ids).count
                        #   template.fields.where.not(fieldtype: 'labelntext').each do |field|
                        #       Value.where(report_id: self.id, field_id: field.id).first_or_create do |value|
                        #           value.input = field.default_value
                        #       end
                        #   end
                        # end
                    # else
                    #   worksheet
                    # end
                # end
                # if self.changed?
                #   exclude_ids = Field.where(template_id: template_order).where.not(fieldtype: 'labelntext').map { |x| x.id }
                #   pp exclude_ids
                #   values.where.not(field_id: exclude_ids).destroy_all
                # end
            # end

            def disassociate_template(did, unvalued=[])
                template = templates.find(did)
                template.fields.each do |field|
                    values.each do |value|
                        if field.id == value.field_id
                            unvalued.push value.id
                        end
                    end
                end
                values.where(:id => unvalued).destroy_all
                templates.delete(template)
            end
    end
end
