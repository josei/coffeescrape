jQuery(function($) {
  $("input#run").click(function() {
    $("pre#result").text("");
    try {
      eval(editor.getValue());
    } catch(err) {
      alert("Error:\n" + err.message);
    }
  });
  
  $(document).bind('keydown', 'alt+r', function() { $("input#run").click(); });

  function get(real_url, callback) {
    url = "/get?uri=" + encodeURIComponent(real_url);
    $.get(url, callback);
  }
  
  function linkify(html) {
    var noProtocolUrl = /(^|["'(\s]|&lt;)(www\..+?\..+?)((?:[:?]|\.+)?(?:\s|$)|&gt;|[)"',])/g;
    var httpOrMailtoUrl = /(^|["'(\s]|&lt;)((?:(?:https?|ftp):\/\/|mailto:).+?)((?:[:?]|\.+)?(?:\s|$)|&gt;|[)"',])/g;
    return html.replace( noProtocolUrl, '$1<a href="<``>://$2">$2</a>$3' )
               .replace( httpOrMailtoUrl, '$1<a href="$2">$2</a>$3' )
               .replace( /"<``>/g, '"http' );
  }

  function println(text) {
    $("pre#result").html($("pre#result").html()+linkify(text)+"\n");    
  }
});