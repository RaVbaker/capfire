require 'spec_helper'
require 'capfire'

describe Capfire do
  describe "#deployer" do
    it "should return ENV['USER']" do
      ENV.should_receive(:[]).with("USER")
      Capfire.deployer
    end
  end
end