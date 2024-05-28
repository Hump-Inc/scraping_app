class CreateMedicalInstitutions < ActiveRecord::Migration[7.0]
  def change
    create_table :medical_institutions do |t|
      t.string :official_name
      t.string :postal_code
      t.string :address
      t.string :fax
      t.string :website
      t.string :email
      t.text :special_notes

      t.timestamps
    end
  end
end
