require 'active_support'
require 'atomic_store'

class AtomicMemCacheStore < ActiveSupport::Cache::CompressedMemCacheStore
  RAW_ARG = true

  include AtomicStore
end
