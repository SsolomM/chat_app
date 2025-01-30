# == Schema Information
#
# Table name: messages
#
#  id          :bigint           not null, primary key
#  app_token   :string
#  chat_number :integer
#  number      :integer
#  sender      :string
#  text        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_messages_on_app_token_and_chat_number  (app_token,chat_number)
#
# Foreign Keys
#
#  fk_rails_5aeb3c63fc  (["app_token", "chat_number"] => chats.["app_token", "number"])
#
class Message < ApplicationRecord
    # associations
    belongs_to :chat, foreign_key: [ :app_token, :chat_number ], primary_key: [ :app_token, :number ]

    # validations
    validates :number, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :number, uniqueness: { scope: [ :app_token, :chat_number ] }
    validates :text, :sender, presence: true

    # callbacks
    before_validation(on: :create) do
        if chat.present?
            chat.with_lock do
                chat.message_sequence += 1
                self.number = chat.message_sequence
                chat.save
            end
        end
    end

    # serialization
    def as_json(options = {})
        super(only: [ :number, :sender, :text, :app_token, :chat_number ])
    end
end
