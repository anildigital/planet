class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.integer :feed_url_id
      t.string :title, :author, :link
      t.text :content
      t.datetime :published
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
