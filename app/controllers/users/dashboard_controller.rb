module Users
  class DashboardController < Users::BaseController

    # GET /dashboard
    def index
    end

    private

    def set_navs
      set_nav("user/dashboard")
    end

  end
end

