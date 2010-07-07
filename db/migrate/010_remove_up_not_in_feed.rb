class RemoveUpNotInFeed < ActiveRecord::Migration
  def self.up
	  remove_column :users, :up_notinfeed
  end

  def self.down
     add_column :users, :up_notinfeed, :string
  end
end
