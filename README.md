# devise_mobile_confirmable

[![Build Status](https://api.travis-ci.org/emn178/devise_mobile_confirmable.png)](https://travis-ci.org/emn178/devise_mobile_confirmable)
[![Coverage Status](https://coveralls.io/repos/emn178/devise_mobile_confirmable/badge.svg?branch=master)](https://coveralls.io/r/emn178/devise_mobile_confirmable?branch=master)

It adds support to devise for confirming users' mobile by SMS.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise_mobile_confirmable'
```

And then execute:

    bundle

Or install it yourself as:

    gem install devise_mobile_confirmable

Run the following generator to add DeviseMobileConfirmable's configuration option into the Devise configuration file (config/initializers/devise.rb):

    rails g devise_mobile_confirmable:install

## Requirements

[devise](https://github.com/plataformatec/devise)  
[SMS Carrier](https://github.com/emn178/sms_carrier)

## Usage
Add DeviseMobileConfirmable to your Devise models using the following generator:

    rails g devise_mobile_confirmable MODEL

For example

    rails g devise_mobile_confirmable user

And you can use following methods:
```Ruby
user.mobile_confirmed?             # true if confirmed
user.change_mobile '+886987654321' # send SMS with token to user
user.confirm_mobile_token '123456' # user input the token and confirm his mobile phone
user.mobile                        # eg. '+886987654321'

# return how many seconds to enable next SMS request, equal or less than 0 will unlock
user.seconds_to_unlock_mobile_confirmation_token
```
You can overwrite token generating method, in model class:
```Ruby
def generate_mobile_confirmation_token
  # return your token
end
```

## Configuration
You can set options in devise.rb
```Ruby
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
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Contact
The project's website is located at https://github.com/emn178/devise_mobile_confirmable  
Author: Chen, Yi-Cyuan (emn178@gmail.com)
