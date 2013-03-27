before do 
  session[:oauth] ||= {}  

  @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, :site => "https://api.twitter.com")
  request_token = session[:oauth][:request_token]   
  request_token_secret = session[:oauth][:request_token_secret]
  if request_token.nil? || request_token_secret.nil?
    @request_token = @consumer.get_request_token(:oauth_callback => "http://127.0.0.1:9292/auth")
    session[:oauth][:request_token] = @request_token.token
    session[:oauth][:request_token_secret] = @request_token.secret
  else
    @request_token = OAuth::RequestToken.new(@consumer, request_token, request_token_secret)
  end
end


get '/tweet' do
    @client = Twitter::Client.new(
    :consumer_key => CONSUMER_KEY,
    :consumer_secret => CONSUMER_SECRET,
    :oauth_token => session[:oauth][:access_token],
    :oauth_token_secret => session[:oauth][:access_token_secret]
    )

  erb :index
end


get '/' do
  erb :home
end

get "/request" do

  redirect @request_token.authorize_url
end


get "/auth" do
  access_token = session[:oauth][:access_token]   
  access_token_secret = session[:oauth][:access_token_secret]
  unless access_token.nil? || access_token_secret.nil?
    @access_token = OAuth::AccessToken.new(@consumer, access_token, access_token_secret)    
    session[:oauth][:access_token] = params[:oauth_token]
    session[:oauth][:access_token_secret] = params[:oauth_verifier]

    @client = Twitter::Client.new(
    :consumer_key => CONSUMER_KEY,
    :consumer_secret => CONSUMER_SECRET,
    :oauth_token => params[:oauth_token],
    :oauth_token_secret => params[:oauth_verifier]
    )
  end 

    @client = Twitter::Client.new(
    :consumer_key => CONSUMER_KEY,
    :consumer_secret => CONSUMER_SECRET,
    :oauth_token => access_token,
    :oauth_token_secret => access_token_secret
    )

  redirect "/tweet"
end


post '/tweet' do  
  client.update(params[:tweet])
  "#{params[:tweet]}"
end
