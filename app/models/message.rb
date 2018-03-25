class Message < ApplicationRecord
  belongs_to :author, class_name: User, foreign_key: :author_id
  belongs_to :chatter

  validates :text, presence: true
end
