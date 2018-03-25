class ChattersController < ApplicationController
  before_action :authenticate_user!

  def create
    chat = Chatter.get_chat(current_user.id, params[:user_id]) || Chatter.create!(creator: current_user, receiver: User.find(params[:user_id]))
    message = chat.messages.create!(text: params[:message], author: current_user)
    channels = ["private-notifications_user_#{params[:user_id]}", "private-notifications_user_#{current_user.id}"]
    data = {
        message: params[:message],
        sender: current_user.id,
        receiver: params[:user_id],
        created_at: message.created_at.time.to_formatted_s(:short)
    }
    message.created_at.time.to_formatted_s(:short)
    Pusher.trigger(channels, 'receive_message', data)
  end

  def show
    respond_to do |format|
      format.js do
        @messages = Chatter.get_chat(current_user.id, params[:id]).try(:messages) || []
      end
    end
  end
end
