class Users::ImagesController < Poodle::ImagesController
  before_filter :require_user
end
