require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'emOMYuLg8S0vvdXZ2TJV4wgIX'
  config.consumer_secret = 'B8Pi6OTw1Sc3ghc6Cg2XFXeerON68e5BN7R3Y7KPsSVQavEkhZ'
  config.access_token = '21625700-PRqzpL0QR66RctLD2s8ObOVvHscVDY4MCIfacStnC'
  config.access_token_secret = '73mWRgTLgp4mYcNwX6wXE4gtLcJS3yeNvHM2Z7lKwDpX3'
end

search_term = URI::encode('#todayilearned')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end
