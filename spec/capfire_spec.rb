require 'spec_helper'
require 'capfire'

module Broach;end

describe Capfire do
  describe "#valid_config?" do
    let(:config_file) { config_example }
    before { stub_config }
    subject { Capfire.valid_config? }
    it { should be_true }

    context "config_file wthout `room`" do
      let(:config_file) { config_example("room:")}
      it {should_not be_true }
    end

    context "config_file wthout `account`" do
      let(:config_file) { config_example("account:") }
      it {should_not be_true }
    end

    context "config_file wthout `token`" do
      let(:config_file) { config_example("token:") }
      it {should_not be_true }
    end

    context "config_file wthout `post_message`" do
      let(:config_file) { config_example("post_message:") }
      it {should_not be_true }
    end

    context "config_file wthout `pre_message`" do
      let(:config_file) { config_example("pre_message:") }
      it {should be_true }
    end
  end

  describe "#config_file_exists?" do
    it "should check that file exists" do
      File.should_receive(:exists?).with("config/capfire.yml")
      Capfire.config_file_exists?
    end
  end

  describe "#github_compare_url" do
    let(:repo_address) {"git@github.com:RaVbaker/capfire.git" }
    let(:first_commit) { "01ABCDEF" }
    let(:last_commit) { "98765431" }
    subject { Capfire.github_compare_url(repo_address, first_commit, last_commit) }
    it "should convert github repo address into url" do
      subject.should == "https://github.com/RaVbaker/capfire/compare/#{first_commit}...#{last_commit}"
    end
    it "should not change repo_address directly" do
      repo_address_copy = repo_address.clone
      subject
      repo_address.should == repo_address_copy
    end
  end

  describe "#has_pre_deploy_message?" do
    let(:config_file) { config_example }
    before { stub_config }
    subject { Capfire.has_pre_deploy_message? }
    it {should be_true }
    context "when `pre_message` not defined" do
      let(:config_file) { config_example("pre_message:") }
      it{should be_false}
    end
  end

  describe "#valid_credentials?" do
    before { stub_broach }
    subject { Capfire.valid_credentials? }
    let(:me) { "MyName" }
    it "should set up Broach" do
      Broach.should_receive(:settings=)
      Broach.should_receive(:me)
      subject.should be_true
    end

    context "when no :me in broach" do
      let(:me) { nil }
      it { should be_false }
    end
  end

  describe "#speak" do
    let(:me) {"MyName"}
    before { stub_broach }
    subject{ Capfire.speak(message, options) }
    let(:message) {"My message"}
    let(:options) { Hash.new }

    it "should call Broach.speak" do
      Broach.should_receive(:speak).with("MyRoom", message, options)
      subject
    end

    context "when not valid credentials" do
      let(:me) {nil}
      it "should not call Broach.speak" do
        Broach.should_not_receive(:speak)
        subject
      end
    end
  end

  describe "#post_deploy_message" do
    let(:post_message) { "#star# #deployer# finished a #application# deploy with `cap #args#` (#compare_url#)" }
    before {
      ENV.should_receive(:[]).with('USER').and_return(deployer)
      Capfire.stub(config: stub(:[] => post_message))
    }
    let(:deployer) { 'RaVbaker' }
    let(:args) {'production deploy'}
    let(:compare_url) { 'https://github.com/RaVbaker/capfire/compare/012345...zdsfs312' }
    let(:application) { 'capfire' }
    subject{ Capfire.post_deploy_message(args, compare_url, application) }
    it "should substitute :post_message" do
      subject.should == "\u{1F31F} RaVbaker finished a capfire deploy with `cap production deploy` (#{compare_url})"
    end
    context "when no application defined" do
      let(:application) {nil}
      it "should leave string #application# as is" do
        subject.should == "\u{1F31F} RaVbaker finished a #application# deploy with `cap production deploy` (#{compare_url})"
      end
    end

    context "when no args defined" do
      let(:args) {nil}
      it "should leave string #args# as is" do
        subject.should == "\u{1F31F} RaVbaker finished a capfire deploy with `cap #args#` (#{compare_url})"
      end
    end

    context "when no compare_url defined" do
      let(:compare_url) {nil}
      it "should leave string #compare_url# as is" do
        subject.should == "\u{1F31F} RaVbaker finished a capfire deploy with `cap production deploy` (#compare_url#)"
      end
    end
  end

  describe "#pre_deploy_message" do
    let(:pre_message) { "#sparkle# #deployer# started a #application# deploy with `cap #args#` (#compare_url#)" }
    before {
      ENV.should_receive(:[]).with('USER').and_return(deployer)
      Capfire.stub(config: stub(:[] => pre_message))
    }
    let(:deployer) { 'RaVbaker' }
    let(:args) {'production deploy'}
    let(:compare_url) { 'https://github.com/RaVbaker/capfire/compare/012345...zdsfs312' }
    let(:application) { 'capfire' }
    subject{ Capfire.pre_deploy_message(args, compare_url, application) }
    it "should substitute :post_message" do
      subject.should == "\u{2728} RaVbaker started a capfire deploy with `cap production deploy` (#{compare_url})"
    end
    context "when no application defined" do
      let(:application) {nil}
      it "should leave string #application# as is" do
        subject.should == "\u{2728} RaVbaker started a #application# deploy with `cap production deploy` (#{compare_url})"
      end
    end

    context "when no args defined" do
      let(:args) {nil}
      it "should leave string #args# as is" do
        subject.should == "\u{2728} RaVbaker started a capfire deploy with `cap #args#` (#{compare_url})"
      end
    end

    context "when no compare_url defined" do
      let(:compare_url) {nil}
      it "should leave string #compare_url# as is" do
        subject.should == "\u{2728} RaVbaker started a capfire deploy with `cap production deploy` (#compare_url#)"
      end
    end
  end

  pending "#pre_deploy_sound", "not documented yet"
  pending "#post_deploy_sound", "not documented yet"

  private
    def config_example(filter=nil)
      file_source = File.read("./spec/fixtures/config_example.yml")
      file_source = file_source.lines.reject{|line| line.include?(filter)}.join if filter
      YAML.load(file_source)
    end

    def stub_config(file=nil)
      YAML.stub(load_file: file || config_file)
    end

    def stub_broach
      stub_config(config_example)
      Broach.stub(:settings= => {'account' => 'acc_ount', 'token' => 't0ken', 'use_ssl' => true})
      Broach.stub(me: me)
    end

end