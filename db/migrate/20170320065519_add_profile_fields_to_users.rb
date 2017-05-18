class AddProfileFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :inn, :string
  	add_column :users, :person, :string
  	add_column :users, :city, :string
  	add_column :users, :legal_address, :string
  	add_column :users, :actual_address, :string
  	add_column :users, :kpp, :string
  	add_column :users, :bank_name, :string
  	add_column :users, :curr_account, :string
  	add_column :users, :corr_account, :string
  	add_column :users, :bik, :string
  	add_column :users, :phone, :string
  	add_column :users, :note, :text
  end
end
