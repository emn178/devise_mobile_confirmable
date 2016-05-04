require 'sms_carrier'

module Devise
  module Models
    module MobileConfirmable
      def mobile_confirmed?
        mobile_confirmed_at.present?
      end

      def change_mobile(new_mobile)
        errors.add(self.class.mobile_field, :blank) if new_mobile.blank?
        errors.add(self.class.mobile_field, :indifferent) if mobile == new_mobile
        errors.add(:base, :retry_later) unless can_send_mobile_confirmation_token?
        return false unless errors.empty?

        self.unconfirmed_mobile = new_mobile
        if mobile_confirmation_token_expired?
          self.mobile_confirmation_token = generate_mobile_confirmation_token
          self.mobile_confirmation_failure = 0
        end
        self.mobile_confirmation_sent_at = Time.now
        return false unless save
        send_mobile_confirmation_token
        errors.empty?
      end

      def confirm_mobile_token(token)
        errors.add(:mobile_confirmation_token, :blank) if token.blank?
        errors.add(:mobile_confirmation_token, :expired) if mobile_confirmation_token_expired?
        return false unless errors.empty?
        if mobile_confirmation_token != token
          update(:mobile_confirmation_failure => mobile_confirmation_failure + 1)
          errors.add(:mobile_confirmation_token, :invalid)
          return false
        end
        self.mobile = unconfirmed_mobile
        self.unconfirmed_mobile = nil
        self.mobile_confirmed_at = Time.now
        self.mobile_confirmation_failure = 0
        save
      end

      def seconds_to_unlock_mobile_confirmation_token
        return 0 if mobile_confirmation_sent_at.nil?
        self.class.throttle_mobile_confirmation_token - (Time.now - mobile_confirmation_sent_at).to_i
      end

      def can_send_mobile_confirmation_token?
        seconds_to_unlock_mobile_confirmation_token <= 0
      end

      def mobile_confirmation_token_expired?
        mobile_confirmation_token.nil? ||
        mobile_confirmation_failure >= self.class.max_mobile_confirmation_failure && self.class.max_mobile_confirmation_failure != 0
      end

      def mobile
        if self.class.mobile_field == :mobile
          super
        else
          self.send(self.class.mobile_field)
        end
      end

      def mobile=(value)
        if self.class.mobile_field == :mobile
          super
        else
          self.send(self.class.mobile_field.to_s + '=', value)
        end
      end

      protected

      def send_mobile_confirmation_token
        SmsCarrier::Base.sms(:to => unconfirmed_mobile, :body => I18n.t('devise.carrier.mobile_confirmation_token', :token => mobile_confirmation_token)).deliver_now
      end

      def generate_mobile_confirmation_token
        rand(100000..999999)
      end

      module ClassMethods
        Devise::Models.config(self, :mobile_field)
        Devise::Models.config(self, :throttle_mobile_confirmation_token)
        Devise::Models.config(self, :max_mobile_confirmation_failure)
      end
    end
  end
end
