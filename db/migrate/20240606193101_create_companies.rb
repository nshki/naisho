class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :website, null: false, index: {unique: true}
      t.string :category, null: false, index: true
      t.timestamps
    end
  end
end
