class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :password_digest
      t.string :name
      t.string :email

      t.timestamps
    end

    # insert a column into votes and stories tables of the user who created the particular story or vote
    add_column :stories, :user_id, :integer
    add_column :votes, :user_id, :integer
  end
end
