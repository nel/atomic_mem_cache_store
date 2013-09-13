require 'iconv'

begin
  require 'spec/autorun'
rescue LoadError
  require 'rspec'
end
require File.expand_path(File.dirname(__FILE__) + '/../lib/atomic_mem_cache_store')
require File.expand_path(File.dirname(__FILE__) + '/../lib/atomic_dalli_store')
Dir["./spec/support/**/*.rb"].sort.each {|f| require f}
