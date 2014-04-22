require 'active_support'
require 'atomic_store'

module ActiveSupport
  module Cache
    class AtomicMemCacheStore < ActiveSupport::Cache::MemCacheStore
      RAW_ARG = true

      include AtomicStore
    end
  end
end
