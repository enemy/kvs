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
	halt 404
  end
  
  value
end

put '/:namespace/:key' do
  key = build_key(params[:namespace], params[:key])
  value = params[:value]
  
  CACHE.set key, value
end

delete '/:namespace/:key' do
  key = build_key(params[:namespace], params[:key])

  begin  
    CACHE.delete key
  rescue
    halt 404
  end
end

get '/' do
  File.open('public/index.html').read
end

