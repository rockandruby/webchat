class Chatter < ApplicationRecord
  belongs_to :creator, class_name: User, foreign_key: :creator_id
  belongs_to :receiver, class_name: User, foreign_key: :receiver_id

  has_many :messages

  class << self
    def get_chat(user1, user2)
      Chatter.where(creator_id: user1, receiver_id: user2).or(Chatter.where(creator_id: user2, receiver_id: user1)).first
    end
  end
end
