class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.string :site
      t.boolean :processing
      t.string :subdomain

      t.timestamps
    end
  end

  def self.down
    drop_table :shops
  end
end
