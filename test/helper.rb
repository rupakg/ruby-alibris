require 'test/unit'
require 'pathname'
require 'rubygems'

require 'matchy'
require 'shoulda'
require 'mocha'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'alibris'

API_KEY = "your_alibris_api_key_here"

class Test::Unit::TestCase
end

FakeWeb.allow_net_connect = false


class Test::Unit::TestCase
end

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def alibris_url(url)
  url =~ /^http/ ? url : "http:/www.alibris.com:80#{url}"
end

def stub_get(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?

  FakeWeb.register_uri(:get, alibris_url(url), options)
end