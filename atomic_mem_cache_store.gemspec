# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "atomic_mem_cache_store"
  s.version     = File.read(File.join(File.dirname(__FILE__),'VERSION') ).strip
  s.authors     = ["Renaud (Nel) Morvan"]
  s.email       = ["nel@w3fu.com"]
  s.homepage    = "https://github.com/nel/atomic_mem_cache_store"
  s.summary     = %q{Rails memcached store with atomic expiration}
  s.description = %q{Rails memcached store optimized for the thundering herd issue. This limit cache recalculation to a single process while as long as key is not swept by LRU. Drop-in replacement of Rails memcached store.}

  s.rubyforge_project = "atomic_mem_cache_store"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "iconv"
  s.add_development_dependency "dalli", "~> 1.0.4"
  s.add_development_dependency "memcache-client"
  s.add_runtime_dependency "activesupport", "~> 2.1"
end
