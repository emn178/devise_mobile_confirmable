require 'devise'
require 'devise_mobile_confirmable/engine'

module DeviseMobileConfirmable
end

module Devise
  mattr_accessor :mobile_field
  @@mobile_field = :mobile

  mattr_accessor :throttle_mobile_confirmation_token
  @@throttle_mobile_confirmation_token = 60.seconds

  mattr_accessor :max_mobile_confirmation_failure
  @@max_mobile_confirmation_failure = 3
end

Devise.add_module :mobile_confirmable, :model => 'devise_mobile_confirmable/model'
