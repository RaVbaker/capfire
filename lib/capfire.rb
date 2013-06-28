# Gem for applications to automatically post to Campfire after an deploy.

require 'broach'

class Capfire
  # To see how it actually works take a gander at the generator
  # or in the capistrano.rb
  class << self
    def config_file_path
      "config/capfire.yml"
    end

    def config_file_exists?
      File.exists?( config_file_path )
    end

    def valid_config?
      config = self.config
      config["post_message"] && config["room"] && config ["token"] && config["account"]
    end

    def config
      YAML::load( File.open( config_file_path ) )
    end

    # Campfire room
    def room
      self.config["room"]
    end

    # Campfire account
    def account
      self.config["account"]
    end

    # Campfire token
    def token
      self.config["token"]
    end

    # Who is deploying
    def deployer
      ENV["USER"]
    end

    # Link to github's excellent Compare View
    def github_compare_url(repo_url, first_commit, last_commit)
      repo_url.gsub!(/git@/, 'http://')
      repo_url.gsub!(/github\.com:/,'github.com/')
      repo_url.gsub!(/\.git/, '')
      "#{repo_url}/compare/#{first_commit}...#{last_commit}"
    end

    def default_post_message
      "#star# #deployer# finished the #application# deploy (#compare_url#)"
    end

    # Sound to play on campfire before deploy
    def pre_deploy_sound
      sound = self.config["pre_sound"]
      self.speak(sound, :type => :sound) if sound
    end

    # Sound to play on campfire after deploy
    def post_deploy_sound
      sound = self.config["post_sound"]
      self.speak(sound, :type => :sound) if sound
    end

    # Message to post to campfire on deploy
    def pre_deploy_message(args, compare_url, application)
      message = self.config["pre_message"]
      message = subs( message, args, compare_url, application )
      message
    end

    # Message to post to campfire on deploy
    def post_deploy_message(args, compare_url, application)
      message = self.config["post_message"]
      message = subs( message, args, compare_url, application )
      message
    end

    def subs( text, args, compare_url, application )
      # Basic emoji
      text = text.clone
      text.gsub!( /#sparkle#/, "\u{2728}" )
      text.gsub!( /#star#/, "\u{1F31F}" )
      text.gsub!( /#turd#/, "\u{1F4A9}" )
      text.gsub!( /#deployer#/, deployer )
      text.gsub!( /#application#/, application ) if application
      text.gsub!( /#args#/, args ) if args
      text.gsub!( /#compare_url#/, compare_url ) if compare_url
      text
    end

    def has_pre_deploy_message?
      self.config["pre_message"]
    end

    # Initializes a broach campfire room
    def broach
      Broach.tap do |broach|
        broach.settings = {
        'account' => self.account,
        'token' => self.token,
        'use_ssl' => true
        }
      end
    end

    def valid_credentials?
      !!self.broach.me
    end

    # Posts to campfire
    def speak(message, options={})
      self.broach.speak(self.room, message, options) if valid_credentials?
    end
  end
end
