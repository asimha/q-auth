class ApplicationController < ActionController::Base
  protect_from_forgery

  ## This filter method is used to fetch current user
  before_filter :stylesheet_filename, :javascript_filename, :set_default_title, :current_user

  include ApplicationHelper
  include AuthenticationHelper
  include NotificationHelper

  private

  def set_default_title
    set_title("Q-Auth")
  end

  def stylesheet_filename
    @stylesheet_filename = "application"
  end

  def javascript_filename
    @javascript_filename = "application"
  end

end
