class User < ApplicationRecord
  # encrypt password
  has_secure_password
  has_many :conversations_as_user1, class_name: 'Conversation', foreign_key: 'user1_id', dependent: :destroy
  has_many :conversations_as_user2, class_name: 'Conversation', foreign_key: 'user2_id', dependent: :destroy
  has_many :chat_messages, as: :sender, dependent: :destroy
end
