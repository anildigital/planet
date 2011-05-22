class CreateFeedUrls < ActiveRecord::Migration
  def change
    create_table :feed_urls do |t|
      t.string :feed_url, :title, :site_url
      t.boolean :star, :default => false
      t.timestamps
    end
  end
end
