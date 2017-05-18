class AddOgrnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :ogrn, :string
  end
end
