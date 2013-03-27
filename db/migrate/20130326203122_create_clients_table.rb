class CreateClientsTable < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :user_id
      t.string :access_token
      t.string :access_token_secret
    end
  end
end
