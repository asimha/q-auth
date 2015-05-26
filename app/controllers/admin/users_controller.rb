module Admin
  class UsersController < Poodle::AdminController

    def create
      @user = User.new
      @user.assign_attributes(permitted_params)
      @user.assign_default_password_if_nil
      save_resource(@user)
    end

    def make_admin
      change_role("admin")
    end

    def make_super_admin
      change_role("super_admin")
    end

    def remove_admin
      change_role("user")
    end

    def remove_super_admin
      change_role("admin")
    end

    def update_status
      @user = User.find(params[:id])
      @user.update_attribute(:status, params[:status])
      render_show
    end

    def masquerade
      @user = User.find(params[:id])
      masquerade_as_user(@user)
    end

    private

    def get_collections
      # Fetching the users
      relation = User.where("")
      @filters = {}
      if params[:query]
        @query = params[:query].strip
        relation = relation.search(@query) if !@query.blank?
      end

      if params[:status]
        @status = params[:status].strip
        relation = relation.status(@status) if !@status.blank?
      end

      if params[:user_type]
        @user_type = params[:user_type].strip
        relation = relation.user_type(@user_type) if !@user_type.blank?
      end

      @per_page = params[:per_page] || "20"
      @users = relation.order("created_at desc").page(@current_page).per(@per_page)

      ## Initializing the @user object so that we can render the show partial
      @user = @users.first unless @user

      return true
    end

    def change_role(new_role)
      @user = User.find(params[:id])
      @user.update_attribute(:user_type, new_role)
      render_show
    end

    def permitted_params
      params[:user].permit(:name, :username, :email, :phone, :designation_overridden, :linkedin, :skype, :department_id, :designation_id)
    end

  end
end
