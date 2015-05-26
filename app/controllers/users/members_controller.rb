module Users
  class MembersController < Users::BaseController
    def index
      get_collections
    end

    def show
      @user = User.find(params[:id])
    end

    def set_navs
      set_nav("users/members")
    end

    private

    def get_collections
      relation = User.where("status = 'active'")
      @filters = {}
      if params[:query]
        @query = params[:query].strip
        relation = relation.search(@query) if !@query.blank?
      end

      @per_page = params[:per_page] || "21"
      @users = relation.order("name asc").page(@current_page).per(@per_page)

      @user = @users.first unless @user
      return true
    end
  end
end