class AddImage2AndImage3ToGallery < ActiveRecord::Migration[7.0]
  def change
    add_column :galleries, :image_2, :string
    add_column :galleries, :image_3, :string
  end
end
