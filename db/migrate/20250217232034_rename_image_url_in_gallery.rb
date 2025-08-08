class RenameImageUrlInGallery < ActiveRecord::Migration[7.0]
  def change
    rename_column :galleries, :image_url, :image_1
  end
end
