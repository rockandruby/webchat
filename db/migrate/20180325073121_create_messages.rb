class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.belongs_to :author
      t.belongs_to :chatter
      t.boolean :is_read, default: false
      t.text :text
      t.timestamps
    end
  end
end
