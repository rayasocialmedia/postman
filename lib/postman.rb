require 'postman/version'
require 'postman/exceptions'
require 'postman/tracker'
require 'postman/redis'

module Postman
  extend Postman::Redis
  
  mattr_accessor :debug
  @@debug = true
  
  mattr_accessor :enabled
  @@enabled = true
  
  mattr_accessor :backend
  @@backend = false

  mattr_reader :redis
  mattr_accessor :redis_params


  def self.setup
    yield self
  end
  
  def self.process
    list = []
    # Find all unprocessed trails
    unprocessed = Trail.find_all_by_status(Trail::UNPROCESSED)
    unprocessed.each do |trail|
      # list[trail.object.class.to_s] << trail
      # Combine lists of subscribers for the object
      Subscription.find_all_by_object(trail.object).each do |subscription|
        subscription.user.notify(trail.object, trail.action, trail.timestamp)
      end
    end
    # Add notifications to users inboxes
    # Mark as processed
  end
  
  
  def self.route
    # Find all unrouted notifications
    # For each notification, find media to deliver
    # Honor user preferences
    # Send push notifications
  end
  
  def self.deliver
    # Find all undelivered notifications
    # For each notification, attempt to deliver
    # If failed, defer sending and increment retry count
    # If retry count exceeded maximum, raise delivery error
  end

end

require 'postman/rails/engine'
