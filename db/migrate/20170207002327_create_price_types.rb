class CreatePriceTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :price_types do |t|
      t.string :cid
      t.string :title
      t.string :currency_name

      t.timestamps
    end
  end
end
