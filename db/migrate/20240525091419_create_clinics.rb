class CreateClinics < ActiveRecord::Migration[7.0]
  def change
    create_table :clinics do |t|
      t.string :name
      t.string :email
      t.string :director_name
      t.string :homepage_url

      t.timestamps
    end
  end
end
