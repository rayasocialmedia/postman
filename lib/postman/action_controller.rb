module Recognition
  # Extending ActionController
  module ActionController
    def self.included(base)
      base.extend ClassMethods
    end
  
    module ClassMethods
    end
  end
end