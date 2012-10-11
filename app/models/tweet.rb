class Tweet < ActiveRecord::Base
  attr_accessible :created_at, :profile_image_url, :text, :user
end
