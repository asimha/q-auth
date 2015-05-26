module Admin
  class DesignationsController < Poodle::AdminController

    skip_before_filter :require_admin
    before_filter :require_super_admin

    private

    def permitted_params
      params[:designation].permit(:title, :responsibilities)
    end

  end
end
