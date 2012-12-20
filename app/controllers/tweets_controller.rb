class TweetsController < ApplicationController

  require 'twitter'

  NUM_OF_COUNT = 200

  def gather
    max_attempts = 3
    num_attempts = 0
    begin
      num_attempts += 1
      if $since_tweet_id
        tweets = Twitter.list_timeline('sfc_list', 'sfc-all', { :count => NUM_OF_COUNT, :since_id => $since_tweet_id })
      else
        tweets = Twitter.list_timeline('sfc_list', 'sfc-all', { :count => NUM_OF_COUNT })
      end
      tweets.each do |tweet|
        params = {:text => tweet.text, :user => tweet.user.screen_name, :profile_image_url => tweet.user.profile_image_url, :created_at => tweet.created_at}
        Tweet.create(params) unless Tweet.exists?(params)
      end
      $since_tweet_id = tweets[0].id
    rescue Twitter::Error::TooManyRequests => error
      logger.debug("error : #{error} #{error.rate_limit.limit}")
      if num_attempts <= max_attempts
        # NOTE: Your process could go to sleep for up to 15 minutes but if you
        # retry any sooner, it will almost certainly fail with the same exception.
        sleep error.rate_limit.reset_in
        retry
      else
        raise
      end
    end
  end

end
