class CreatePostImages < ActiveRecord::Migration[5.2]
  def change
    create_table :post_images do |t|
      t.text :image
      t.text :shop_name
      t.text :caption
      t.integer :user_id

      t.timestamps
    end
  end
end
