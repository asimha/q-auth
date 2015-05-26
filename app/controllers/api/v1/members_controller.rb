module Api
  module V1
    class MembersController < Api::V1::BaseController

      before_filter :parse_pagination_params

      def show
        proc_code = Proc.new do
          # Fetching the user
          @data = User.find_by_id(params[:id])
          @success = true
        end
        render_json_response(proc_code)
      end

      def index
        proc_code = Proc.new do
          # Fetching the users
          relation = User.where("")
          relation = relation.search(params[:query].strip) if params[:query] && !params[:query].blank?

          @data = relation.order("name asc").page(@current_page).per(@per_page)
          @success = true
        end
        render_json_response(proc_code)
      end

    end
  end
end
