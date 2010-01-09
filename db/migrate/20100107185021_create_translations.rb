class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.integer :shop_id
      t.string :to_lang
      t.boolean :paid

      t.timestamps
    end
  end

  def self.down
    drop_table :translations
  end
end
