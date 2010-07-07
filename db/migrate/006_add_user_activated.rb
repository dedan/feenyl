class AddUserActivated < ActiveRecord::Migration
  def self.up
    add_column :users, :activated, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :users, :activated
  end
end
