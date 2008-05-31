class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.column :link, :string
      t.column :title, :string
      t.column :description, :text
      t.column :pubDate, :datetime
      t.column :error_tag, :integer
      t.column :site_url, :string
      t.column :href, :string
      t.column :copyright, :string
      t.column :license, :string
      t.column :feed_version, :string
      t.column :tags, :string 
      t.column :star, :string
      t.column :updated, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
