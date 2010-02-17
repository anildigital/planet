class AlterStar < ActiveRecord::Migration
  def self.up
    change_column :feed_urls, :star, :boolean, :default => false
  end

  def self.down
    change_column :feed_urls, :star, :string
  end
end
