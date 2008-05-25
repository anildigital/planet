class CreateFeedUrls < ActiveRecord::Migration
  def self.up
    create_table :feed_urls do |t|
      t.string :feed_url
      t.string :star

      t.timestamps
    end
  end

  def self.down
    drop_table :feed_urls
  end
end
