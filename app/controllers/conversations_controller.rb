class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show]

  def index
    @conversations = Conversation.where('user1_id = ? OR user2_id = ?', current_user.id, current_user.id)
    render json: @conversations.map { |conversation| format_conversation(conversation) }
  end

  def show
    if @conversation.user1_id == current_user.id || @conversation.user2_id == current_user.id
      render json: format_conversation(@conversation)
    else
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def format_conversation(conversation)
    {
      id: conversation.id,
      with_user: {
        id: conversation.user1_id == current_user.id ? conversation.user2.id : conversation.user1.id,
        name: conversation.user1_id == current_user.id ? conversation.user2.name : conversation.user1.name,
        photo_url: conversation.user1_id == current_user.id ? conversation.user2.photo_url : conversation.user1.photo_url
      },
      last_message: format_message(conversation.chat_messages.last),
      unread_count: conversation.chat_messages.where.not(sender: current_user).count
    }
  end

  def format_message(message)
    return nil if message.nil?

    {
      id: message.id,
      sender: {
        id: message.sender.id,
        name: message.sender.name
      },
      sent_at: message.created_at
    }
  end
end
