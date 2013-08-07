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

  subject { FedoraModel.new }
  it { should respond_to(:mint_ezid) }

  describe "#mint_ezid" do
    it "mints an ezid"
    it "raises an error when minting against an unsaved object" do
      expect { subject.mint_ezid }.to raise_error(Hydra::Ezid::Error)
    end
    it "stores an id in a configurable location by schema"
  end

  it "uses a configurator for account details"
  it "disallows repeat settings of a schema"
  it "disallows setting of the ezid manually"
  it "updates/saves when when changed"
  it "crosswalks metadata"
  it "sends crosswalked metadata to the ezid service"
  it "allows specification of DOI or ARK"
  it "allows multiple accounts"
  it "allows management of status (public, private, etc.)"
end
