class CreateChatMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :sender, polymorphic: true, null: false
      t.text :content

      t.timestamps
    end
  end
end
