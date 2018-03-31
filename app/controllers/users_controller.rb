class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_gon

  def index
    @users = User.where('id != ?', current_user.id).order(id: :asc)
    @chat = Chatter.get_chat(current_user.id, @users.first.id) if @users.any?
    @new_senders = ActiveRecord::Base.connection.execute("select distinct author_id from messages where chatter_id in
     (select id from chatters where creator_id = #{current_user.id} or receiver_id = #{current_user.id})
     and author_id != #{current_user.id} and is_read=false").pluck('author_id')
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
