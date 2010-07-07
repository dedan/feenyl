class AddRemindMe < ActiveRecord::Migration
  def self.up
	 add_column :users, :remind_me, :boolean, :null => false, :default => false
	 add_column :users, :reminded, :boolean, :null => false, :default => false
  end

  def self.down
	 remove_column :users, :remind_me
	 remove_column :users, :reminded
  end
end
