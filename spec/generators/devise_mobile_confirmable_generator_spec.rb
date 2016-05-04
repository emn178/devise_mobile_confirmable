require File.expand_path('../../lib/generators/devise_mobile_confirmable/devise_mobile_confirmable_generator.rb', File.dirname(__FILE__))

describe DeviseMobileConfirmable::Generators::DeviseMobileConfirmableGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)
  arguments %w(user)

  before {
    prepare_destination
    FileUtils.mkdir_p(File.expand_path("app/models", destination_root))
    FileUtils.cp(File.expand_path("../../fixtures/user.rb", __FILE__), File.expand_path("app/models/user.rb", destination_root))
    run_generator
  }

  it {
    assert_file "app/models/user.rb", <<-FIle
class User < ActiveRecord::Base
  devise :mobile_confirmable, :database_authenticatable, :registerable, :validatable
end
FIle
  }
end
