# AtomicMemCacheStore

## Why ?

Anyone caching slow content on a website with moderate to heavy traffic will
sooner of later be a victim of the [thundering herd issue](http://en.wikipedia.org/wiki/Thundering_herd_problem) also called Dog-pile Effect.

Basically cache invalidation of a high traffic page will trigger several concurrent cache recalculation that could lead to pikes of load and transient slow down of your architecture.

Rails (and any framework relying on active support cache store) does not offer any built-in solution to this problem. You have to make your own based on sweeper, cron and/or periodical cache warming up. This tend to explode your view/model logic across several files and technology and lead to maintenance/debugging nightmare.

## What ?

This gem is a drop-in alternative to active support memcache store that preserve the simplicity of your built-in framework cache methods (action, fragment, Rails.cache) while providing atomic cache invalidation and serving cold cache in the meantime.

Out of the box the cache calculation is made directly in the current process were cache has been invalidated for the first time. But you could override this cache store to support async cache calculation.

## How ?

Install the gem

    gem install atomic_mem_cache_store
	
or add it to your Gemfile

	gem 'atomic_mem_cache_store'

Then use it directly

	cache = AtomicMemCacheStore.new
	cache.write('key', 'value', :expires_in => 10)
	cache.read('key')

Or for Rails add it in your config/environments/<env>.rb

	config.cache_store = :atomic_mem_cache_store, %w( 127.0.0.1 ), { :namespace => "cache:#{Rails.env}" }

If you want to use Dalli instead, do the following:

  cache = AtomicDalliStore.new
  cache.write('key', 'value', :expires_in => 10)
  cache.read('key')

Or for Rails add it in your config/environments/<env>.rb

  config.cache_store = :atomic_dalli_store, %w( 127.0.0.1 ), { :namespace => "cache:#{Rails.env}" }

It supports the same parameters as [ActiveSupport::Cache::MemCacheStore](http://apidock.com/rails/ActiveSupport/Cache/MemCacheStore)

## When ?

- You are using memcached
- If you have high traffic or slow cache recalculation
- If you use fragment cache with expiry
- If you use Rails.cache.fetch with expiry
- If you use caching with expiry and trigger recalculation when you get an empty cache

## Drawbacks

- If you use only memcache cache without expiry, you won't benefit from any improvement as your cache invalidation will be due to LRU algorithm or manual sweeping. This will work as before though.

- This will not prevent your app from thundering herd effect due to LRU key sweeping as in this case the cache value is lost. This is not worse than what you have now, though.

- If you try to access key value directly be careful as you will bypass the atomicity mechanism. (this will work though even if the expiration of the key will be longer than expected).

- Current implementation will double number of memcache read AND write (to read
  the lock). It could be reduced but at the expense of changing the nature of
  key (make it array or prefix it) thus making it uncompatible with direct access, multiget and adding
  complexe type support overhead.

## TL;DR

Basically unless you are doing weird stuff without your cache store, this should be a drop-in replacement with no real corner cases. Worse that can happen is more query to memcache, and slightly longer expiry on keys.

## License

MIT

## Copyright

Renaud Morvan (nel@w3fu.com)
