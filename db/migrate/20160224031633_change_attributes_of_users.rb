class ChangeAttributesOfUsers < ActiveRecord::Migration
  def change
    change_column :users, :role, :string, null: false, default: User::STRING_ROLE_MEMBER
  end
end
