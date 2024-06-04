FactoryBot.define do
  factory :conversation do
    association :user1, factory: :user
    association :user2, factory: :user
    # Add other attributes as needed

    # Contoh: membuat beberapa chat messages setelah membuat conversation
    after(:create) do |conversation|
      create_list(:chat_message, 5, conversation: conversation)
    end
  end
end
