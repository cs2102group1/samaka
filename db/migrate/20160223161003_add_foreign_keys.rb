class AddForeignKeys < ActiveRecord::Migration
  def change
    add_index :journeys, :start, unique: true
    add_foreign_key "drivers", "journeys", column: "start", primary_key: "start", name: "drivers_start_fkey", on_delete: :cascade
    add_foreign_key "drivers", "users", column: "email", primary_key: "email", name: "drivers_email_fkey", on_delete: :cascade
    add_foreign_key "passengers", "journeys", column: "start", primary_key: "start", name: "passengers_start_fkey", on_delete: :cascade
    add_foreign_key "passengers", "users", column: "email", primary_key: "email", name: "passengers_email_fkey", on_delete: :cascade
  end
end
