class CreateGalleries < ActiveRecord::Migration[7.0]
  def change
    create_table :galleries do |t|
      t.string :image_url
      t.text :description

      t.timestamps
    end
  end
end
