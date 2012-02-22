# -*- encoding: utf-8 -*-
require 'rubygems'
require 'sinatra'
require 'sinatra/synchrony'
require 'faraday'

Faraday.default_adapter = :em_synchrony

get '/' do
  haml :index
end

get '/proxy' do
  logger.info params[:uri]
  Faraday.get(params[:uri]).body
end

helpers do
  def base_js
    <<-EOS
      jQuery(function($) {
        $("input#run").click(function() {
          $("pre#result").text("");
          try {
            eval(editor.getValue());
          } catch(err) {
            alert("Error:\\n" + err.message);
          }
        });
        
        $(document).bind('keydown', 'alt+r', function() { $("input#run").click(); });

        function get(real_url, callback) {
          url = "/proxy?uri=" + encodeURIComponent(real_url);
          $.get(url, callback);
        }
        
        function println(text) {
          $("pre#result").text($("pre#result").text()+text+"\\n");
        }
        
      });
    EOS
  end

  def code_mirror_js
    <<-EOS
      editor = CodeMirror.fromTextArea(document.getElementById("code"), {
        mode: 'javascript',
        lineNumbers: true,
        extraKeys: { 'Alt-R': function() { $("input#run").click(); } },
        matchBrackets: true
      });
    EOS
  end
  
  def example
    <<-EOS
get("http://engadget.com", function(result) {
  $(result).find("h4.post_title a").each(function() {
    println($(this).text());
  });
});
    EOS
  end
end
