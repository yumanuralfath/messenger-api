FactoryBot.define do
  factory :chat_message do
    content { "This is a chat message content" }
    association :conversation
    association :sender, factory: :user # Asumsikan model User digunakan sebagai sender

    # Tambahkan atribut lain sesuai kebutuhan
  end
end
