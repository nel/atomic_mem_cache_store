shared_examples "an atomic store" do

  before(:all) do
    begin
      @store = described_class.new('127.0.0.1', :namespace => "spec-atomic")
      @store.read('test')
    rescue MemCache::MemCacheError
      puts "You need a real memcache server to execute the specs, you can run those test on production server, this won't flush your memcache"
    end
  end

  before(:each) do
    @seed = "#{Time.now.to_i}#{rand(1000000000000000000000000)}"
    described_class.grace_period = 90
  end

  def prefix_key(value)
    "#{@seed}#{value}"
  end

  describe "with expiry" do
    it "returns nil when key has not been set" do
      @store.read(prefix_key('unknown')).should be_nil
    end

    it "returns value when key has been set and is not expired" do
      key = prefix_key('not-expired')
      @store.write(key, true, :expires_in => 10)
      @store.read(key).should be
    end

    it "returns new value when key is rewriten" do
      key = prefix_key('not-expired')
      @store.write(key, 1, :expires_in => 10)
      @store.write(key, 2, :expires_in => 10)
      @store.read(key).should be 2
    end

    it "returns nil once when key is expired, and then the old value" do
      key = prefix_key('expired')

      @store.write(key, 1, :expires_in => 1)
      sleep 2
      @store.read(key).should be_nil
      @store.read(key).should be 1
      @store.read(key).should be 1
    end

    it "returns nil when 2 times the grace period is passed" do
      described_class.grace_period = 1
      key = prefix_key('expired')

      @store.write(key, 1, :expires_in => 1)
      sleep 2
      @store.read(key).should be_nil
      @store.read(key).should be 1
      sleep 2
      @store.read(key).should be_nil
    end
  end

  describe "without expiry" do
    it "returns nil when key has not been set" do
      @store.read(prefix_key('unknown')).should be_nil
    end

    it "returns value when key is set" do
      key = prefix_key('key-without-expiry')

      @store.write(key, 1)
      @store.read(key).should be 1
    end

    it "returns new value when key is rewriten" do
      key = prefix_key('key-without-expiry')

      @store.write(key, 1)
      @store.write(key, 2)
      @store.read(key).should be 2
    end
  end

end
