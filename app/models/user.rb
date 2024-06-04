class User < ApplicationRecord
  # encrypt password
  has_secure_password

  # associations
  has_many :conversations_as_user1, class_name: 'Conversation', foreign_key: 'user1_id', dependent: :destroy
  has_many :conversations_as_user2, class_name: 'Conversation', foreign_key: 'user2_id', dependent: :destroy
  has_many :chat_messages, as: :sender, dependent: :destroy

  #function to find or create conversation
  def find_or_create_conversation_with(other_user)
    conversation = Conversation.between(self, other_user).first
    conversation ||= Conversation.create(user1: self, user2: other_user)
    conversation
  end

  # function to include conversation
  def include_conversations
    self.conversations_as_user1.includes(:chat_messages).each { |conversation| conversation.chat_messages }
    self.conversations_as_user2.includes(:chat_messages).each { |conversation| conversation.chat_messages }
  end
end
