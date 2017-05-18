class CreateBanners < ActiveRecord::Migration[5.1]
  def change
    create_table :banners do |t|
      t.string :image
      t.string :title
      t.string :link
      t.integer :advert_place_id

      t.timestamps
    end
  end
end
