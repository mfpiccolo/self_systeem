class User::BaseController < ApplicationController
  before_filter :authenticate_user!

  layout "user"
end

