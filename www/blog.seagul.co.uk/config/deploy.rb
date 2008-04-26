set :application, "blog.seagul.co.uk"
set :repository,  "http://chrisroos.googlecode.com/svn/trunk/www/#{application}"

set :deploy_to, "/home/chrisroos/www/#{application}"
set :deploy_via, :copy

role :app, "jail0093.vps.exonetric.net"
role :web, "jail0093.vps.exonetric.net"
role :db,  "jail0093.vps.exonetric.net", :primary => true