class AddAddressStreetToDatum < ActiveRecord::Migration[7.0]
  def change
    add_column :data, :address_street, :string
  end
end
