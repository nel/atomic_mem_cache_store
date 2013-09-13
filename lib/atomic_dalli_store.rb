require 'dalli'
require 'dalli/memcache-client'
require 'active_support/cache/dalli_store23'
require 'atomic_store'

class AtomicDalliStore < ActiveSupport::Cache::DalliStore
  RAW_ARG = { :raw => true }

  include AtomicStore
end
