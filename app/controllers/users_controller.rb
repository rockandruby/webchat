class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_gon

  def index
    @users = User.where('id != ?', current_user.id)
    @chat = Chatter.get_chat(current_user.id, @users.last.id) if @users.any?
  end

  def pusher_auth
    if params[:id].to_i == current_user.id
      response = Pusher.authenticate(params[:channel_name], params[:socket_id])
      return render json: response
    end
    head 403
  end
end
