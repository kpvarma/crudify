class CreateApiKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :devise_crud_api_keys do |t|
      t.string :key, null: false, unique: true
      t.datetime :expires_at, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :devise_crud_api_keys, :key, unique: true
    add_index :devise_crud_api_keys, :status
  end
end