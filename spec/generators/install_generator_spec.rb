require File.expand_path('../../lib/generators/devise_mobile_confirmable/install_generator.rb', File.dirname(__FILE__))

describe DeviseMobileConfirmable::Generators::InstallGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)

  before {
    prepare_destination
    setup
    run_generator
  }
  let(:setup) {}
  let(:device_rb) {
    <<-FIle
Devise.setup do |config|
  # Send a notification email when the user's password is changed
  # config.send_password_change_notification = false


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

  # ==> Configuration for :confirmable
  # A period that the user is allowed to access the website even without
  # confirming their account. For instance, if set to 2.days, the user will be
  # able to access the website for two days without confirming their account,
  # access will be blocked just in the third day. Default is 0.days, meaning
  # the user cannot access the website without confirming their account.
  # config.allow_unconfirmed_access_for = 2.days
end
FIle
  }

  context 'when devise can inject' do
    let(:setup) {
      FileUtils.mkdir_p(File.expand_path("config/initializers", destination_root))
      FileUtils.cp(File.expand_path("../../fixtures/devise.rb", __FILE__), File.expand_path("config/initializers/devise.rb", destination_root))
    }
    it {
      assert_file "config/locales/devise_mobile_confirmable.en.yml", <<-FIle
en:
  errors:
    messages:
      indifferent: is indifferent
      retry_later: Please retry later
  devise:
    carrier:
      mobile_confirmation_token: Your token is %{token}
FIle
    }
    it { assert_file "config/initializers/devise.rb", device_rb }
  end

  context 'when devise is not found' do
    it { 
      expect(destination_root).to have_structure {
        no_file "config/initializers/devise.rb"
      }
    }
  end

  context 'when devise is not matched' do
    let(:setup) {
      FileUtils.mkdir_p(File.expand_path("config/initializers", destination_root))
      FileUtils.cp(File.expand_path("../../fixtures/devise2.rb", __FILE__), File.expand_path("config/initializers/devise.rb", destination_root))
    }
    it { assert_file "config/initializers/devise.rb", device_rb }
  end
end
