class AddSiteUrl < ActiveRecord::Migration
  def self.up
    add_column :feed_urls, :site_url, :string
  end

  def self.down
    remove_column :feed_urls, :site_url, :string
  end
end
