# Capfire (modified)

I made modifications to Capfire. Whee.

Add `config/capfire.yml` with something like:

    room: "The Room"
    token: 1c8bf396ade280b65ee5f7b428e43b9f3e6a6dc6
    account: subdomain
    pre_message: "#deployer# started a #application# deploy with `cap #args# (#compare_url#)"
    post_message: "#deployer# finished the #application# deploy (#compare_url#)"
    idiot_message: "#deployer# tried to deploy without pushing first. lol."

And add `require "capfire/capistrano"` to your Capfile

Original README below:

# Capfire (original)

Inspired by http://github.com/blog/609-tracking-deploys-with-compare-view we , http://10to1.be, wanted the same for our deploys without having to copy paste each deploy script.

This gem adds a way to send a message to campfire after a deploy, in the message is the app-name, the github-compare view url and the deployer.

Since version 0.3.0 capfire will also check if the currently deployed version differs from the version you're about to deploy, aka see if you forgot to do a push before deploying. If this happens it'll also post a message to Campfire, since we all know public shaming JustWorks(tm).

## Install
`gem install capfire`

Now either the generator:
`script/generate capfire -k "campfire_token" -r "chat_room" -a "campfire_account"`
This will create a ~/.campfire file and add a line to your config/deploy.rb file.

Or do it by hand:
In your config/deploy.rb append `require capfire/capistrano`, in your home folder create .campfire with the following contents

    campfire:
      account: your_campfire_account
      token: your_campfire_token
      room: the_campfire_chatroom_to_post in
      message: "I (#deployer#) deployed #application# with `cap #args# (#compare_url#)"


From now on your deploys will send a message to Campfire containing the Github-compare view url.

## Options

Since it's initial release a few options have crept into capfire, take a look at `lib/capfire/capistrano' and look for cowsay, the same for the messages, they're all adjustable in your settings file.
'
## Multiple Projects

Either run the generator (without options since you've arleady got a ~/.campfire file it won't complain) again or append by hand the `require capfire/capistrano` line to your deploy file.

## Usage
After the install you're done. Really, do a `cap deploy` and it should post to campfire.

If anoyone on the project doesn't have Capfire installed he won't notice a difference, no message will be sent.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Piet Jaspers 10to1. See LICENSE for details.
