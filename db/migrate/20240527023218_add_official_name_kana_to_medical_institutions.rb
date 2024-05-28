class AddOfficialNameKanaToMedicalInstitutions < ActiveRecord::Migration[7.0]
  def change
    add_column :medical_institutions, :official_name_kana, :string
  end
end
