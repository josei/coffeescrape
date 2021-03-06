# -*- encoding: utf-8 -*-
require 'rubygems'
require 'bundler'
Bundler.require

Faraday.default_adapter = :em_synchrony

class JavaScrape < Sinatra::Base
  register Sinatra::Synchrony
  
  Connection = Faraday.new do |builder|
    builder.use FaradayMiddleware::FollowRedirects, :limit=>3
    builder.adapter Faraday.default_adapter
  end
  
  get '/' do
    haml :index
  end

  get '/get' do
    Connection.get(params[:uri]).body
  end

  post '/post' do
    Connection.post(params[:uri], params.reject{|k| k=="uri"}).body
  end

  helpers do
    def code_mirror_js
      <<-EOS
        editor = CodeMirror.fromTextArea(document.getElementById("code"), {
          mode: 'coffeescript',
          lineNumbers: true,
          extraKeys: { 'Alt-R': function() { $("input#run").click(); } },
          matchBrackets: true
        });
      EOS
    end
  
    def example
      <<-EOS
get "http://engadget.com", (result) ->
  $(result).find("h4.post_title a").each ->
    println $(this).text()
    println $(this).attr("href")
EOS
    end
  end
end
