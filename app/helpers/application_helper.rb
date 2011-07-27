module ApplicationHelper
	
	def google_analytics_js #use <%= google_analytics_js %> to then output this in the view. SO EASY Update this with proper Analytics code
	  '<script type="text/javascript">
	  var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
	  document.write(unescape("%3Cscript src="" + gaJsHost + google-analytics.com/ga.js type="text/javascript"%3E%3C/script%3E"));
	  </script>
	  <script type="text/javascript">
	  _uacct = "UA-nnnnnnn-n";
	  urchinTracker();
	  </script>'
	end
end
