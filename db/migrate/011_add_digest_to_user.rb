class AddDigestToUser < ActiveRecord::Migration
  def self.up
	 add_column :users, :digest, :string
  end

  def self.down
	 remove_column :users, :digest
  end
end
