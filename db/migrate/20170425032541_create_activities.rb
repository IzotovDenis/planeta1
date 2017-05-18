class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.integer :user_id
      t.hstore :log
      t.string :controller
      t.string :action
      t.string :ip

      t.timestamps
    end
  end
end
