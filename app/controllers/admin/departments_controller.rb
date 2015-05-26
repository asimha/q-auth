module Admin
  class DepartmentsController < Poodle::AdminController

    skip_before_filter :require_admin
    before_filter :require_super_admin

    private

    def permitted_params
      params[:department].permit(:name, :description)
    end

  end
end
