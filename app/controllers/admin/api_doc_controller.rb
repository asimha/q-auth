module Admin
  class ApiDocController < Admin::BaseController
    def index
    end

    private

    def set_navs
      set_nav("admin/api_doc")
    end
  end
end
