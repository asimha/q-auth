module Api
  module V1
    class DesignationsController < Api::V1::BaseController

      skip_before_filter :require_auth_token
      before_filter :parse_pagination_params, only: :index

      def show
        proc_code = Proc.new do
          # Fetching the Designation
          @data = Designation.find_by_id(params[:id])
          @success = true
        end
        render_json_response(proc_code)
      end

      def index
        proc_code = Proc.new do
          # Fetching the Designations
          relation = Designation.where("")
          relation = relation.search(params[:query].strip) if params[:query] && !params[:query].blank?

          @data = relation.order("title asc").page(@current_page).per(@per_page)
          @success = true
        end
        render_json_response(proc_code)
      end
    end
  end
end
