class MessagesController < ApplicationController

  # GET /conversations/:conversation_id/messages
  def index
    conversation = Conversation.find(params[:conversation_id])
    if [conversation.user1, conversation.user2].include?(current_user)
      messages = conversation.chat_messages.order(created_at: :asc).map do |message|
        {
          id: message.id,
          message: message.content,
          sender: {
            id: message.sender.id,
            name: message.sender.name
          },
          sent_at: message.created_at.strftime('%Y-%m-%d %H:%M:%S')
        }
      end
      render json: messages, status: :ok
    else
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Conversation not found' }, status: :not_found
  end

  # POST /messages
  def create
    recipient = User.find(params[:recipient_id])
    conversation = current_user.find_or_create_conversation_with(recipient)
    message = conversation.chat_messages.build(sender: current_user, content: params[:message])

  if message.save
    render json: {
      id: message.id,
      message: message.content,
      sender: {
        id: message.sender_id,
        name: message.sender.name
      },
      sent_at: message.created_at,
      conversation: {
        id: conversation.id,
        with_user: {
          id: recipient.id,
          name: recipient.name,
          photo_url: recipient.photo_url
        }
      }
    }, status: :created
  else
    render json: message.errors, status: :unprocessable_entity
  end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Recipient not found' }, status: :not_found
  end
end
