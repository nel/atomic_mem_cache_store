require_relative '../../lib/active_support/cache/atomic_mem_cache_store'
require 'active_support/per_thread_registry'
require 'shared_atomic_store_examples'

describe ActiveSupport::Cache::AtomicMemCacheStore do
  it_behaves_like 'an atomic store'
end
