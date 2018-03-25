class CreateChatters < ActiveRecord::Migration[5.1]
  def change
    create_table :chatters do |t|
      t.belongs_to :creator
      t.belongs_to :receiver
      t.index([:creator_id, :receiver_id], unique: true)
      t.index([:receiver_id, :creator_id], unique: true)
      t.timestamps
    end
  end
end
