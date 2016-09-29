# Fields Controller
module Api::V1 #:nodoc:
    class FieldsController < ApplicationController
        # before_action :authenticate_user!
        
        def index
            render json: Field.where(:template_id => params[:template_id]).where.not(:fieldtype => 'labelntext').as_json(only: [:id, :fieldtype, :o])
        end

        def show
        end

        def create
            template = Template.find(params[:template_id])
            @field = template.fields.new(allowed_params)
            @field.save
            render 'show', status: 201
        end

        def update
            field = Field.find(params[:id])
            field.update(allowed_params)
            head :no_content
        end

        def destroy
            field = Field.find(params[:id])
            field.destroy
            head :no_content
        end

        private
            def allowed_params
                params.require(:field).permit(:fieldtype, :o => [:section_id, :column_id, :column_order, :name, :fieldtype, :placeholder, :tooltip, :required, :disabled, :glyphicon, :default_value, {:options => []}
                ])
            end
    end
end