class Conversation < ApplicationRecord
  # Associations
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'
  has_many :chat_messages, dependent: :destroy

  def self.between(user1, user2)
    where('(user1_id = :user1_id AND user2_id = :user2_id) OR (user1_id = :user2_id AND user2_id = :user1_id)', user1_id: user1.id, user2_id: user2.id)
  end
end
