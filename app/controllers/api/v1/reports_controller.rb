module Api::V1 #:nodoc:
  class ReportsController < ApiController
    
    nested_attributes_names = Report.nested_attributes_options.keys.map do |key|
      key.to_s.concat('_attributes').to_sym
    end
    wrap_parameters include: Report.attribute_names + nested_attributes_names

    def index

      queried_reports = if params.has_key?(:keywords)

        keywords = params[:keywords]

        query = if keywords.to_i > 0
          {:id => keywords.to_i}
        else
          {:title => keywords}
        end
        render json: current_user.reports.where(query).page(params[:page]).per(10).order(id: :desc).index_minned
      else
        render json: current_user.reports.page(params[:page]).per(10).order(id: :desc).index_minned
      end

    end

    def show
      @report = current_user.reports.find(params[:id])
      @report.populate_values
      @report.reload unless !@report.changed
      @report
    end

    def create
      @report = current_user.reports.new(allowed_params)
      @report.save
      @report.populate_values
      @report.reload unless !@report.changed
      current_user.reports << @report
      render 'show', status: 201
    end

    def update
      report = current_user.reports.find(params[:id])
      report.template_order = params[:template_order]
      if params.has_key?(:did)
        report.disassociate_template(params[:did])
        report.update_attributes(params.require(:report).permit({:template_order => []}))
      else
        report.populate_values
        report.update_attributes(allowed_params)
      end
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
          :id, :title, {:template_order => []}, :allow_title, :submission, :response, :active, :location,
          values_attributes: [
            :id, :input, :field_id
          ]      
        )
      end
  end
end
