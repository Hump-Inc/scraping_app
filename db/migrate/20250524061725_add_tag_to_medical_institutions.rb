class AddTagToMedicalInstitutions < ActiveRecord::Migration[7.1]
  def change
    add_column :medical_institutions, :tag, :string
  end
end
