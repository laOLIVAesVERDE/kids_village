class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.references :facility, foreign_key: true

      t.timestamps

    end
    add_index :posts, [:facility_id, :created_at]
  end
end
