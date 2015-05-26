# Be sure to restart your server when you modify this file.
# http://excid3.com/blog/sharing-a-devise-user-session-across-subdomains-with-rails-3/
# https://github.com/rails/rails/issues/12881
QAuth::Application.config.session_store :cookie_store, key: 'QAUTH_QAUTHUID'
