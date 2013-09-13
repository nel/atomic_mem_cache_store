module AtomicStore
  VERSION = File.read(File.join(File.dirname(__FILE__),'..','VERSION') ).strip
  NEWLY_STORED = "STORED\r\n"

  module ClassMethods
    attr_accessor :grace_period
  end

  @grace_period = 90

  def self.included(base)
    @raw_arg = base::RAW_ARG
    base.extend(ClassMethods)
  end

  def read(key, options = nil)
    result = super

    if result.present?
      timer_key = timer_key(key)
      #check whether the cache is expired
      if @data.get(timer_key, true).nil?
        #optimistic lock to avoid concurrent recalculation
        if @data.add(timer_key, '', self.class.grace_period, @raw_arg) == NEWLY_STORED
          #trigger cache recalculation
          return handle_expired_read(key,result)
        end
        #already recalculated or expirated in another process/thread
      end
      #key not expired
    end
    result
  end

  def write(key, value, options = nil)
    expiry = (options && options[:expires_in]) || 0
    #extend write expiration period and reset expiration timer
    options[:expires_in] = expiry + 2*self.class.grace_period unless expiry.zero?
    @data.set(timer_key(key), '', expiry, @raw_arg)
    super
  end

  protected

  #to be overidden for something else than synchronous cache recalculation
  def handle_expired_read(key,result)
    nil
  end

  private

  def timer_key(key)
    "tk:#{key}"
  end
end
