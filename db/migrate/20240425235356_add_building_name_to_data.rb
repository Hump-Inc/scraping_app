class AddBuildingNameToData < ActiveRecord::Migration[7.0]
  def change
    add_column :data, :building_name, :string
  end
end
