
require File.expand_path('../../lib/generators/active_record/devise_mobile_confirmable_generator.rb', File.dirname(__FILE__))

describe ActiveRecord::Generators::DeviseMobileConfirmableGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)
  arguments %w(user)

  before {
    allow(Time).to receive(:now).and_return(Time.at(1462341000))
    prepare_destination
    run_generator
  }

  it {
    assert_file "db/migrate/20160504055000_devise_mobile_confirmable_add_to_users.rb", <<-FIle
class DeviseMobileConfirmableAddToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string     :mobile
      t.string     :unconfirmed_mobile
      t.string     :mobile_confirmation_token
      t.datetime   :mobile_confirmed_at
      t.datetime   :mobile_confirmation_sent_at
      t.integer    :mobile_confirmation_failure
    end
    # remove unique: true if it's allowed
    add_index :users, :mobile, unique: true
  end

  def down
    change_table :users do |t|
      t.remove :mobile_confirmation_token, :mobile_confirmed_at, :mobile_confirmation_sent_at, :unconfirmed_mobile, :mobile_confirmation_failure
    end
  end
end
FIle
  }
end
