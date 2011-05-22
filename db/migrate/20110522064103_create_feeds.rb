class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.integer :feed_url_id
      t.string :title, :author, :link, :site_link, :site_title
      t.text :content
      t.datetime :published
      t.timestamps
    end
  end
end
