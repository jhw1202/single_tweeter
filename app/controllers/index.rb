get '/' do
  erb :index
end

post '/tweet' do  
  Twitter.update(params[:tweet])
  "#{params[:tweet]}"
end
