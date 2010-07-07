class AddLastPostDate < ActiveRecord::Migration
  def self.up
    add_column :users, :last_post, :date
  end

  def self.down
    remove_column :users, :last_post
  end
end
