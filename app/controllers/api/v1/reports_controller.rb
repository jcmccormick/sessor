module Api::V1 #:nodoc:
  class ReportsController < ApiController
    nested_attributes_names = Report.nested_attributes_options.keys.map do |key|
      key.to_s.concat('_attributes').to_sym
    end
    wrap_parameters include: Report.attribute_names + nested_attributes_names

    def index
      max_per_page = 5

      pre_paginated_reports = if params.has_key?(:keywords)

        keywords = params[:keywords]

        query = if keywords.to_i > 0
          {:id => keywords.to_i}
        else
          {:title => keywords}
        end
        current_user.reports.where(query)
      else
        current_user.reports
      end

      paginate pre_paginated_reports.count, max_per_page do |limit, offset|
        render json: pre_paginated_reports.order(id: :desc).limit(limit).offset(offset).index_minned
      end
    end

    def show
      @report = current_user.reports.find(params[:id])
    end

    def create
      templates = current_user.templates.find(params[:template_ids])
      @report = current_user.reports.new(allowed_params)
      @report.templates << templates
      @report.save
      current_user.reports << @report
      render 'show', status: 201
    end

    def update
      report = current_user.reports.find(params[:id])
      params[:template_ids].each do |template_id|
        template = current_user.templates.find(template_id)
        report.templates << template unless report.templates.include?(template)
      end
      report.update_attributes(allowed_params)
      current_user.reports << report unless current_user.reports.include?(report)
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
          :title, :allow_title, :submission, :response, :active, :location,
          values_attributes: [
            :id, :input
          ]      
        )
      end
  end
end
