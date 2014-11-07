# AuthNetReceiver

The goal of this project is to capture and process transactions posted via the Authorize.net [Silent Post URL](https://www.authorize.net/support/CNP/helpfiles/Account/Settings/Transaction_Format_Settings/Transaction_Response_Settings/Silent_Post_URL.htm). 

## What is that

The Silent Post URL is a feature of Authorize.net that makes a post to a user-defined URl any time a transaction is made. The feature itself is not terribly well documented, but [this blog post](http://www.johnconde.net/blog/all-about-authorize-nets-silent-post/) contains just about all you need to know.

## Ok, but why would I want it?

This tool is primarily useful for those using the [Automated Recurring Billing](http://developer.authorize.net/api/arb/) system, or ARB for sure. Subscriptions created in ARB will dutifully make their transactions at the requested schedule, but (at this time) there is no direct API for pulling down those transactions. By making use of the Silent Post, you can capture all ARB transactions and use that data to reconcile the state of your user's subscription. 

## Installation & Usage

1. Add the following to your Gemfile

        gem 'auth_net_receiver'

2. Run bundle install
3. Copy in database migrations to your new rails project

        bundle exec rake railties:install:migrations
        rake db:migrate

4. Mount the engine in your routes.rb file

        mount AuthNetReceiver::Engine => "/auth_net"

5. Configure the receiver (see section below)
6. Restart your application

## Configuration

The processing side will require some configuration before it works.

    AuthNetReceiver.configure do |config|
      config.hash_value = "HASH VALUE"
      config.gateway_login = "AUTH NET API LOGIN"
    end

The gateway login should be the same value you use when authenticating against Authorize.net. MD5 Hash is a secret value you configure in the Authorize.net dashboard. You can read more about the MD5 value [here](https://support.authorize.net/authkb/index?page=content&id=A588).

As a final step, you should log in to your Authorize.net account and paste the desired endpoing into Silent Post URL setting. It is strongly recommended that you try this in a [sandbox account](https://sandbox.authorize.net) first.

## Processing

Run the `auth_net_receiver:process` rake task to process all pending transactions:

    $ rake auth_net_receiver:process 
    D, [2014-11-06T19:31:38.191435 #39766] DEBUG -- : Processing Authorize.net transactions...
    D, [2014-11-06T19:31:38.289545 #39766] DEBUG -- : Done!
    D, [2014-11-06T19:31:38.289593 #39766] DEBUG -- : - 12 success
    D, [2014-11-06T19:31:38.289616 #39766] DEBUG -- : - 0 errrors
    D, [2014-11-06T19:31:38.289635 #39766] DEBUG -- : - 1 forgeries
