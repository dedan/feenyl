class AddUpNotInFeed < ActiveRecord::Migration
  def self.up
    add_column :users, :up_notinfeed, :string
  end

  def self.down
    remove_column :users, :up_notinfeed
  end
end

