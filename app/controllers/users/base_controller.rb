module Users
  class BaseController < ApplicationController
    layout 'poodle/application'
    before_filter :require_user, :set_navs, :parse_pagination_params
  end
end
