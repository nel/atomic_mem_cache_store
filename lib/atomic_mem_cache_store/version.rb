require File.join(File.dirname(__FILE__),'..','atomic_mem_cache_store')

class AtomicMemCacheStore
  VERSION = File.read(File.join(File.dirname(__FILE__),'..', '..','VERSION') ).strip
end
