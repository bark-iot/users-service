require 'rack/test'
require 'rspec'
require 'pry'

$VERBOSE = nil
ENV['RACK_ENV'] = 'test'

require File.expand_path '../../service.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure { |c| c.include RSpecMixin }