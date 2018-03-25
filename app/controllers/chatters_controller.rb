class ChattersController < ApplicationController
  before_action :authenticate_user!

  def create
    chat = Chatter.get_chat(current_user.id, params[:user_id]) || Chatter.create!(creator: current_user, receiver: User.find(params[:user_id]))
    chat.messages.create!(text: params[:message], author: current_user)
  end
end
