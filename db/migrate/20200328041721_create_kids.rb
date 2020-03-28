class CreateKids < ActiveRecord::Migration[5.1]
  def change
    create_table :kids do |t|
      t.string :name
      t.string :school
      t.string :email
      t.text :introduction
      t.references :facility, foreign_key: true

      t.timestamps
    end
    add_index :kids, [:facility_id, :created_at]
  end
end
