# Gem for applications to automatically post to Campfire after an deploy.

require 'broach'

class Capfire
  # To see how it actually works take a gander at the generator
  # or in the capistrano.rb
  class << self
    def config_file_exists?
      File.exists?(config_file_path)
    end

    def valid_config?
      (post_message && room && token && account)
    end

    def has_pre_deploy_message?
      !pre_message.nil?
    end

    # Link to github's excellent Compare View
    def github_compare_url(repo_url, first_commit, last_commit)
      url = repo_url.clone
      url.gsub!(/git@/, 'https://')
      url.gsub!(/github\.com:/,'github.com/')
      url.gsub!(/\.git/, '')
      "#{url}/compare/#{first_commit}...#{last_commit}"
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
      subs(pre_message, args, compare_url, application)
    end

    # Message to post to campfire on deploy
    def post_deploy_message(args, compare_url, application)
      subs(post_message, args, compare_url, application)
    end

    def valid_credentials?
      !!broach.me
    end

    def speak(message, options={})
      broach.speak(self.room, message, options) if valid_credentials?
    end

    protected
      def config_file_path
        "config/capfire.yml"
      end

      def config
        YAML::load(File.open(config_file_path))
      end

      # Campfire room
      def room
        config["room"]
      end

      # Campfire account
      def account
        config["account"]
      end

      # Campfire token
      def token
        config["token"]
      end

      # Who is deploying
      def deployer
        ENV["USER"] || `git config user.email`
      end

      # Message sended before deploy
      def pre_message
        config["pre_message"]
      end

      # Message sended after deploy
      def post_message
        config["post_message"]
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

      def subs(text, args, compare_url, application)
        # Basic emoji
        text = text.clone
        text.gsub!('#sparkle#', "\u{2728}")
        text.gsub!('#star#', "\u{1F31F}")
        text.gsub!('#turd#', "\u{1F4A9}")
        text.gsub!('#deployer#', deployer)
        text.gsub!('#application#', application) if application
        text.gsub!('#args#', args) if args
        text.gsub!('#compare_url#', compare_url) if compare_url
        text
      end
  end
end
