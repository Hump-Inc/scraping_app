class CreateData < ActiveRecord::Migration[7.0]
  def change
    create_table :data do |t|
      t.string :name
      t.string :address
      t.string :postal_code

      t.timestamps
    end
  end
end
