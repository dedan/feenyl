class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
	   t.column :user_id,  :integer
	   t.column :post_id,  :integer 
    end
  end

  def self.down
    drop_table :ratings
  end
end
