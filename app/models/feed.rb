class Feed < ActiveRecord::Base
  validates_uniqueness_of :title, :scope => [:site_url]
end
