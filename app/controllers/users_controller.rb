class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    render plain: 'asdasdas'
  end
end
