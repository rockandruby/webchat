class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_gon

  def index
    @users = User.where('id != ?', current_user.id).order(id: :asc)
    @chat = Chatter.get_chat(current_user.id, @users.first.id) if @users.any?
  end

  def pusher_auth
    case params[:channel_name]
      when "private-notifications_user_#{current_user.id}"
        render json: Pusher.authenticate(params[:channel_name], params[:socket_id])
      when "presence-users"
        render json: Pusher.authenticate(params[:channel_name], params[:socket_id], user_id: current_user.id, user_info: {
            nickname: current_user.nickname
        })
      else
        head 403
    end
  end

end
