helpers do

  CONSUMER_KEY = "qzR0s7m4xICKQivg5tukcA"       # what twitter.com/apps says   
  CONSUMER_SECRET = "m3961XWKBvLNraYL1T6xCCoTeLroVM9bZhnVgE4"

  def prepare_access_token(oauth_token = "183552804-ndrBa0Cj2CpyUZQMHQJyaWdM7uRAVkzdWtJCWFkb", oauth_token_secret = "zHNOk45PHL69QukGjqA0GfIMYFUoh4FG8Ipe8j8Qc")
    consumer = OAuth::Consumer.new("qzR0s7m4xICKQivg5tukcA", "m3961XWKBvLNraYL1T6xCCoTeLroVM9bZhnVgE4",
      { :site => "https://api.twitter.com",
        :request_token_path => '/oauth/request_token',
        :access_token_path => '/oauth/access_token',
        :authorize_path => '/oauth/authorize',
        :scheme => :header
      })
   
    # now create the access token object from passed values
    token_hash = { :oauth_token => oauth_token,
                   :oauth_token_secret => oauth_token_secret }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
    return access_token
  end
  
end
