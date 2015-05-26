require "rails_helper"

describe Public::UserSessionsController, :type => :controller do
  it "sign_in" do
    expect(:get => sign_in_path).to route_to(:action => 'sign_in', :controller => 'public/user_sessions')
  end

  it "create_session" do
    expect(:post => create_session_path).to route_to(:action => 'create_session', :controller => 'public/user_sessions')
  end

  it "sign_out" do
    expect(:delete => sign_out_path).to route_to(:action => 'sign_out', :controller => 'public/user_sessions')
  end
end