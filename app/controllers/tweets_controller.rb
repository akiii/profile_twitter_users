class TweetsController < ApplicationController

  require 'twitter'

  def gather
    max_attempts = 3
    num_attempts = 0
    begin
      num_attempts += 1
      tweets = Twitter.list_timeline('sfc_list', 'sfc-all', :since_id => $since_tweet_id, :count => 200)
      tweets.each do |tweet|
        puts tweet.created_at
        puts tweet.user.screen_name
        puts tweet.user.profile_image_url
        puts tweet.text
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
