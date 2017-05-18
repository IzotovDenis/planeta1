class CreateImportsessions < ActiveRecord::Migration[5.0]
  def change
    create_table :importsessions do |t|
      t.string   "cookie"
      t.string   "status"
      t.string   "exchange_type"

      t.timestamps
    end
  end
end
