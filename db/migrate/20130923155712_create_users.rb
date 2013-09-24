class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :invite_code
      t.string :type

      t.timestamps
    end

    add_index :users, :invite_code, :unique => true
  end
end