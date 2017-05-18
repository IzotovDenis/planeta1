class CreateAuthTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :auth_tokens do |t|
      t.string :val
      t.datetime :expire_at
      t.integer :user_id
      
      t.index :val

      t.timestamps
    end
  end
end
