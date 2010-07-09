require 'rubygems'
require 'sinatra'

configure do
  require 'memcached'
  CACHE = Memcached.new
end

helpers do	
	def build_key(namespace,key)
		"#{params[:namespace]}:#{params[:key]}"
	end
end

get '/:namespace/:key' do
  key = build_key(params[:namespace], params[:key])
  
  value = nil
  
  begin
  	value = CACHE.get key
  rescue
  end
  
  value
end

post '/:namespace/:key' do
  key = build_key(params[:namespace], params[:key])
  value = params[:value]
  
  CACHE.set key, value
end

delete '/:namespace/:key' do
  key = build_key(params[:namespace], params[:key])
  
  CACHE.delete key
end
