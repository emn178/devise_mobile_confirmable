module DeviseMobileConfirmable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../", __FILE__)
      desc "Add DeviseMobileConfirmable config variables to the Devise initializer and copy DeviseMobileConfirmable locale files to your application."

      def add_config_options_to_initializer
        devise_initializer_path = File.join(destination_root, "config" , "initializers", "devise.rb")
        if File.exist?(devise_initializer_path)
          old_content = File.read(devise_initializer_path)

          if old_content.include?('# ==> Configuration for :mobile_confirmable')
            false
          else
            inject_into_file(devise_initializer_path, :before => "  # ==> Configuration for :confirmable\n") do
<<-CONTENT
  # ==> Configuration for :mobile_confirmable
  # Specify mobile field in table.
  # Default: :mobile
  # config.mobile_field = :mobile

  # Prevent too many requests for sending token by SMS.
  # Default: 60.seconds
  # config.throttle_mobile_confirmation_token = 60.seconds

  # Expire token if too many retries. This is for preventing from brute force attack. 
  # Set to 0 to disable this feature.
  # Default: 3
  # config.max_mobile_confirmation_failure = 3

CONTENT
            end
          end
        end
      end

      def copy_locale
        copy_file "config/locales/en.yml", "config/locales/devise_mobile_confirmable.en.yml"
      end
    end
  end
end
