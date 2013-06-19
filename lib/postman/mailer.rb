module Postman
  class Mailer < ActionMailer::Base
    # layout 'notification'
  
    def notify notification
      from = 'notificatins@example.com'
      to = notification.user.email
      @name = notification.user.name
      @object = notification.object
      @id = notification.uuid
      mail(
        from: from,
        reply_to: self.class.reply_to(notification),
        to: to,
        subject: 'foo bar'
      ) do |format|
        format.html { render "#{view_name(notification)}" }
        format.text { render "#{view_name(notification)}" }
      end
    end
    
    def receive email
      # Find out which notification was replied to
    end
    
    def view_name notification
      name = nil
      default_name = 'notifications/email'
      object = notification.object.class.to_s.downcase
      action = notification.action
      suggestions = []
      suggestions << "notifications/#{object}/#{action}/email"
      suggestions << "notifications/#{object}/#{action}.email"
      suggestions << "notifications/#{object}/email"
      suggestions << "notifications/#{object}.email"
      suggestions << default_name
      list = suggestions.join(', ')
      while suggestions.any? && name.nil?
        suggestion = suggestions.shift
        # name = suggestion if File.exists?("#{suggestion}.html.erb")
        name = suggestion if template_exists?(suggestion, ['notifications'])
      end
      if name.nil?
        # raise Postman::PostmanViewNotFound, "No view was found to render notification. Tried: #{list}"
        name = default_name
      end
    end
    
    def self.reply_to notification
      address = []
      address << 'n'
      address << notification.uuid
      domain = 'example.com'
      alias_char = '+'
      "#{address.join(alias_char)}@#{domain}"
    end
    
  end
end
