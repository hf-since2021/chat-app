class MessagesController < ApplicationController
  def index
    @message = Message.new
    @room = Room.find(params[:room_id])
    @messages = Message.includes(:room).order("created_at ASC")
  end

  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)
    #@message = Message.new(params[:message].permit(:content).merge(room_id: params[:room_id], user_id: current_user.id))
    #@message = Message.new(params.require(:message).permit(:content).merge(room_id: params[:room_id], user_id: current_user.id))    
    if @message.save
      redirect_to room_messages_path(@room)
    else
      @messages = @room.messages.includes(:user)
      render :index
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
  end
end
