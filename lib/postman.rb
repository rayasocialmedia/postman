require 'postman/version'
require 'postman/exceptions'
require 'postman/tracker'
require 'postman/redis'
require 'postman/mailer'

module Postman
  extend Postman::Redis
  
  mattr_accessor :debug
  @@debug = true
  
  mattr_accessor :enabled
  @@enabled = true
  
  mattr_accessor :backend
  @@backend = false

  mattr_accessor :redis_params

  def self.setup
    yield self
  end
  
  def self.deliver
    list = []
    # Find all unprocessed trails
    unprocessed = Trail.find_all_by_status(Trail::UNPROCESSED)
    unprocessed.each do |trail|
      # list[trail.object.class.to_s] << trail
      # Combine lists of subscribers for the object
      Subscription.find_all_by_object(trail.object).each do |subscription|
        if trail.originator.nil? || subscription.subscriber.id != trail.originator.id
          subscription.subscriber.notify(trail.object, trail.action, trail.timestamp)
        end
        trail.processed!
      end
    end
    # Find all unrouted notifications
    # For each notification, find media to deliver
    # Honor user preferences
    # Send push notifications
    # Find all undelivered notifications
    # For each notification, attempt to deliver
    # If failed, defer sending and increment retry count
    # If retry count exceeded maximum, raise delivery error
  end

end

require 'postman/engine'
