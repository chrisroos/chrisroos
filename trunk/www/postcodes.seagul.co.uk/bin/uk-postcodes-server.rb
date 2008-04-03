# *** Convert uk-postcodes.csv file to json
#
# 1. Delete the first, header, line from csv file
# 2. Convert comma separated fields to json formatted data
# 3. Output to file
# 4. Remove the erroneous final comma.  The output of awk leaves us with ...key:value},]
#    The ruby converts that to ...key:value}]
#
# cat uk-postcodes.csv | \
# sed -e"1d" | \
# awk -F"," 'BEGIN {print "["}; {print "{\"postcode\":\"" $1 "\",\"x\":\"" $2 "\",\"y\":\"" $3 "\",\"latitude\":\"" $4 "\",\"longitude\":\"" $4 "\"},"}; END {print "]"}' \
# > uk-postcodes.json
# ruby -e 'postcodes = File.open("uk-postcodes.json") { |f| f.read }; postcodes.sub!(/,\n\]/, "\n]"); File.open("uk-postcodes.json", "w") { |f| f.puts(postcodes) }'

require 'rubygems'
require 'mongrel'
require 'json'

postcodes_file = File.join(File.dirname(__FILE__), '..', 'data', 'uk-postcodes.json')
Postcodes = JSON.parse(File.open(postcodes_file) { |f| f.read })
Index = Postcodes.inject([]) { |index, postcode| index << postcode['postcode'].downcase }

class PostcodeHandler < Mongrel::HttpHandler
  def process(request, response)
    outcode = request.params['PATH_INFO'].sub(/^\//, '').downcase
    postcode_index = Index.index(outcode)
    if postcode_index
      response.start do |head, out|
        head["Content-Type"] = "text/plain"
        out << Postcodes[postcode_index].to_json
      end
    else
      response.start(404) do |head,out|
        out << "Postcode not found\n"
      end
    end
  end
end

config = Mongrel::Configurator.new :host => 'localhost', :port => '4000' do
  listener do
    uri "/postcodes", :handler => PostcodeHandler.new
  end
  trap("INT") { stop }
  run
end

config.join