class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :address
      t.integer :role, default: 2

      t.timestamps
    end
  end
end
