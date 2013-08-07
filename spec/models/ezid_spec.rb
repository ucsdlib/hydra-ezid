require 'spec_helper'

describe Hydra::Ezid do
  before(:all) do
    class FedoraModel < ActiveFedora::Base
      include Hydra::Ezid::ModelMethods
    end
  end

  after(:all) do
    Object.send(:remove_const, :FedoraModel)
  end

  subject(:item) { FedoraModel.new }

  it { should respond_to(:mint_ezid) }

  describe "#mint_ezid" do
    it "mints an ezid" do
      item.save
      item.mint_ezid.should be_a(String)
    end
    it "uses a configurator for account details" do
      item.ezid_configurator.doi.user.should eq(CONSTANTINOPLE.ezid.doi.user)
    end
    it "raises an error when minting against an unsaved object" do
      expect { item.mint_ezid }.to raise_error(Hydra::Ezid::MintError)
    end
    it "stores an id in a configurable location by schema"
  end

  it "disallows repeat settings of a schema"
  it "disallows setting of the ezid manually"
  it "updates/saves when changed"
  it "crosswalks metadata"
  it "sends crosswalked metadata to the ezid service"
  it "allows specification of DOI or ARK"
  it "allows multiple accounts"
  it "allows management of status (public, private, etc.)"
end
