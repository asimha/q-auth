class BackdoorController < ApplicationController

  layout 'poodle/public'

  def index
  	relation = User.where("")
    if params[:query]
      @query = params[:query].strip
      relation = relation.search(@query) if !@query.blank?
    end
    @per_page = params[:per_page] || "20"
    @users = relation.order("created_at desc").page(@current_page).per(@per_page)
  end

  def enter
    @user = User.find(params[:id])
    masquerade_as_user(@user)
  end


end
