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
  puts "1"
  access_token = session[:oauth][:access_token]
  access_token_secret = session[:oauth][:access_token_secret]
  puts "2"
  puts access_token
  puts access_token_secret

  if access_token && access_token_secret
    puts "3"
    @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    session[:oauth] = {
    :access_token => @access_token.token,
    :access_token_secret => @access_token.secret      
    }
    
    
    @client = Twitter::Client.new(
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET,
      :oauth_token => access_token,
      :oauth_token_secret => access_token_secret
    )

    client = Client.find_or_create_by_access_token(access_token)
    client.access_token_secret = access_token_secret
    client.user_id = @client.user.id
    client.save

  else 
    puts "4"
    # puts access_token
    # puts access_token_secret
    puts "%" * 100
    # binding.pry
    puts "params oauth token: #{params[:oauth_token]}"
    puts "params oauth verifier: #{params[:oauth_verifier]}"
    @client = Twitter::Client.new(
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET,
      :oauth_token => session[:oauth][:access_token],
      :oauth_token_secret => session[:oauth][:access_token_secret]
    )


    client = Client.find_or_create_by_access_token(session[:oauth][:access_token])
    client.access_token_secret = session[:oauth][:access_token_secret]
    client.user_id = @client.user.id
    client.save
  end

  redirect "/tweet"
end


post '/tweet' do

  client = Client.find_by_access_token(session[:oauth][:access_token])
    john = Twitter::Client.new(
  :oauth_token => client.access_token,
  :oauth_token_secret => client.access_token_secret
)
  puts client.inspect
  john.update(params[:tweet])
  # puts @client.inspect
  # Thread.new{@client.update(params[:tweet])}
  "#{params[:tweet]}"
end
