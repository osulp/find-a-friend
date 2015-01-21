class SubscriptionList < BasicObject
  def initialize(*subscribers)
    @subscribers = subscribers
  end

  def method_missing(method, *args, &block)
    @subscribers.each do |subscriber|
      if subscriber.respond_to?(method, true)
        subscriber.__send__(method, *args, &block)
      end
    end
  end
end
