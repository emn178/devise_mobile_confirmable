class DeviseMobileConfirmableAddToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string     :mobile
      t.string     :unconfirmed_mobile
      t.string     :mobile_confirmation_token
      t.datetime   :mobile_confirmed_at
      t.datetime   :mobile_confirmation_sent_at
      t.integer    :mobile_confirmation_failure, default: 0, null: false
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
