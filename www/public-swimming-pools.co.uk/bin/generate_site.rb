require 'erb'
include ERB::Util
require File.join(File.dirname(__FILE__), *%w[.. lib swimming_pools])

template = DATA.read
public_dir = File.join(File.dirname(__FILE__), '..', 'public')

SwimmingPools.find_all.each do |swimming_pool|
  erb = ERB.new(template)
  File.open(File.join(public_dir, "#{swimming_pool.permalink}.html"), 'w') do |file|
    file.puts(erb.result(binding))
  end
end

template = File.read(File.join(File.dirname(__FILE__), *%w[index.html.erb]))
erb = ERB.new(template)
File.open(File.join(public_dir, "index.html"), 'w') do |file|
  file.puts(erb.result(binding))
end

__END__
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <link rel="stylesheet" href="/stylesheets/swimming-pools.css" type="text/css" media="screen" charset="utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%= h(swimming_pool.name) %></title>
  </head>
  <body>
    
    <h1><a href="/">Home</a> - <%= h(swimming_pool.name) %></h1>
  
    <div class="mapContainer">
      <% img_url = 'http://maps.google.com/staticmap?' %>
      <% img_url_params = ["center=#{swimming_pool.latitude},#{swimming_pool.longitude}"] %>
      <% img_url_params << 'zoom=14' %>
      <% img_url_params << 'size=200x200' %>
      <% img_url_params << "markers=#{swimming_pool.latitude},#{swimming_pool.longitude}" %>
      <% img_url_params << 'key=ABQIAAAAKHjf8pvj0mv3o07jD0Tc5RQaqNW12GnHBM9UqBhN-tKTStROsxS_YKqdsgFyjjinVKdFKNOHhZmPOQ' %>
      <% img_url = img_url + img_url_params.join('&') %>
      <img width="200px" height="200px" src="<%= h(img_url) %>" alt="<%= h(swimming_pool.name) %>" />
    </div>
  
    <table>
      <tr>
        <td class="attribute">Address</td>
        <td class="address"><%= h(swimming_pool.address) %></td>
      </tr>
      <tr>
        <td class="attribute">Postcode</td>
        <td class="postcode"><%= h(swimming_pool.postcode) %></td>
      </tr>
      <tr>
        <td class="attribute">Phone</td>
        <td class="phone"><%= h(swimming_pool.phone) %></td>
      </tr>
      <tr>
        <td class="attribute">Fax</td>
        <td class="fax"><%= h(swimming_pool.fax) %></td>
      </tr>
      <tr>
        <td class="attribute">Email</td>
        <td><a class="email" href="mailto:<%= h(swimming_pool.email) %>"><%= h(swimming_pool.email) %></a></td>
      </tr>
      <tr>
        <td class="attribute">Website</td>
        <td><a class="website" href="<%= h(swimming_pool.website) %>"><%= h(swimming_pool.website_domain) %></a></td>
      </tr>
      <tr>
        <td class="attribute">Latitude</td>
        <td class="latitude"><%= h(swimming_pool.latitude) %></td>
      </tr>
      <tr>
        <td class="attribute">Longitude</td>
        <td class="longitude"><%= h(swimming_pool.longitude) %></td>
      </tr>
    </table>
    
    <div class="comments">
      <div id="disqus_thread"></div>
      <script type="text/javascript" src="http://disqus.com/forums/public-swimming-pools/embed.js"></script>
      <noscript>
        <p><a href="http://public-swimming-pools.disqus.com/?url=ref">View the forum thread.</a></p>
      </noscript>
      <a href="http://disqus.com" class="dsq-brlink">blog comments powered by <span class="logo-disqus">Disqus</span></a>
    </div>
  
    <div class="footer">
      <a href="/">Home</a>
      <a href="/about">About</a>
    </div>
    
    <!-- <div class="footer">
      <ul>
        <li><a href="/">Home</a></li>
        <li><a href="/about">About</a></li>
        <li><a href="http://groups.google.com/group/public-swimming-pools">Forum</a></li>
      </ul>
    </div> -->
    
    <script type="text/javascript">
      var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
      document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
      var pageTracker = _gat._getTracker("UA-160238-6");
      pageTracker._initData();
      pageTracker._trackPageview();
    </script>
  </body>
</html>