class AddPhoneNumberToMedicalInstitutions < ActiveRecord::Migration[7.0]
  def change
    add_column :medical_institutions, :phone_number, :string
  end
end
