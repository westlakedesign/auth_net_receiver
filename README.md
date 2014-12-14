# AuthNetReceiver

The goal of this project is to capture and process transactions posted via the Authorize.Net [Silent Post URL](https://www.authorize.net/support/CNP/helpfiles/Account/Settings/Transaction_Format_Settings/Transaction_Response_Settings/Silent_Post_URL.htm) for use in a Ruby on Rails web application. 

## What is that?

The Silent Post URL is a feature of Authorize.Net that makes a post to a user-defined URL any time a transaction is made. Take note of the following rules:

- Transactions are sent in real time
- Each transaction is only ever sent once, regardless of server response
- A transaction must be accepted within 2 seconds.

For this reason, Authorize.net recommends that the post action is only used to collect raw data, while parsing and validation is pushed off to a later time.

This is primarily useful for those using the [Automated Recurring Billing](http://developer.authorize.net/api/arb/) system, or ARB for short. Subscriptions created in ARB will make their transactions at the requested schedule, but (at this time) there is no direct API for pulling down those transactions. By making use of the Silent Post, you can capture all ARB transactions and use that data to reconcile the state of your user's subscription. 

## Requirements

AuthNetReceiver is tested against Rails 4.1+ and Ruby 2+.

## Installation & Usage

1. Add the gem to your Gemfile

        gem 'auth_net_receiver'

2. Run bundle install
3. Copy the database migrations to your rails project

        bundle exec rake railties:install:migrations
        rake db:migrate

4. Mount the engine in your routes.rb file

        mount AuthNetReceiver::Engine => "/auth_net"

5. Configure the receiver (see section below)
6. Restart your application

## Configuration

The processing side will require some configuration before it works.

    AuthNetReceiver.configure do |config|
      config.gateway_login = "AUTH NET API LOGIN"
      config.hash_value = "HASH VALUE"
    end

The gateway login should be the same value you use when authenticating against Authorize.Net. MD5 Hash is a secret value you configure in the Authorize.Net dashboard. You can read more about the MD5 value [here](https://support.authorize.net/authkb/index?page=content&id=A588).

As a final step, you should log in to your Authorize.Net account and enter the desired endpoint into Silent Post URL setting. Depending on how you mounted the engine in your routes.rb file, the URL will look something like this: `http://sample.com/auth_net/transactions/receiver`. It is strongly recommended that you try this in a [sandbox account](https://sandbox.authorize.net) first. 

**NOTE:** Because Authorize.Net has to actually make an HTTP post to your endpoint, it is not possible to run this application on localhost without a bit of work on the networking side. I won't attempt to cover the entire topic here, but if you are comfortable with DNS and port forwards you can probably figure out the rest. 

## Processing with ActiveJob

If you are running Rails 4.2, we can take advantage of [ActiveJob](http://edgeguides.rubyonrails.org/active_job_basics.html) and process transactions in the background. Set `AuthNetReceiver.config.active_job = false` if you wish to disable this feature.

## Processing without ActiveJob

If you are not using ActiveJob, raw transactions will pile up in the database and need to be processed manually. Run the `auth_net_receiver:process` rake task to process all pending transactions:

    $ rake auth_net_receiver:process 
    D, [2014-11-06T19:31:38.191435 #39766] DEBUG -- : Processing Authorize.Net transactions...
    D, [2014-11-06T19:31:38.289545 #39766] DEBUG -- : Done!
    D, [2014-11-06T19:31:38.289593 #39766] DEBUG -- : - 12 authentic
    D, [2014-11-06T19:31:38.289616 #39766] DEBUG -- : - 0 errrors
    D, [2014-11-06T19:31:38.289635 #39766] DEBUG -- : - 1 forgeries

## Useful resources:

- [Silent Post URL](https://support.authorize.net/authkb/index?page=content&id=A609&actp=search&viewlocale=en_US&searchid=1415328138657)
- [What is the MD5 Hash Security feature, and how does it work?](https://support.authorize.net/authkb/index?page=content&id=A588)
- [Silent Post returned value pairs](https://support.authorize.net/authkb/index?page=content&id=A170&actp=search&viewlocale=en_US&searchid=1415328138657)
- [All About Authorize.Net’s Silent Post](http://www.johnconde.net/blog/all-about-authorize-nets-silent-post/)
- [(ARB) API Guide - Authorize.Net](http://www.authorize.net/support/ARB_guide.pdf)
