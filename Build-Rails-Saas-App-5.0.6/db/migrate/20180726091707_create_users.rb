class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :hash_id
      t.string :time_zone

      t.timestamps
    end
    add_index :users, :hash_id
  end
end
