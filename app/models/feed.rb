class Feed < ActiveRecord::Base
  # == Schema Information
  # Schema version: 2
  #
  # Table name: feeds
  #
  #  id          :integer(11)     not null, primary key
  #  feed_url_id :integer(11)
  #  title       :string(255)
  #  author      :string(255)
  #  link        :string(255)
  #  site_link   :string(255)
  #  site_title  :string(255)
  #  content     :text
  #  published   :datetime
  #  created_at  :datetime
  #  updated_at  :datetime
  #

  belongs_to :feed_url
  validates_uniqueness_of :title, :scope => [:link]
  validates_presence_of :feed_url_id
  validates_numericality_of :feed_url_id

end
