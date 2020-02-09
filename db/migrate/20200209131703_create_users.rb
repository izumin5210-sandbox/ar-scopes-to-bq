class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, index: true
      t.boolean :registered, index: true
      t.boolean :deleted, index: true

      t.timestamps
    end
  end
end
