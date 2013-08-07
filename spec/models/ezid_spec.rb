require 'spec_helper'

describe Hydra::Ezid do
  before(:all) do
    class FedoraModel < ActiveFedora::Base
      include Hydra::Ezid::ModelMethods
      has_metadata :name => 'properties', :type => ActiveFedora::SimpleDatastream do |m|
        m.field 'some_ark',  :string
      end
      has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream do |m|
        m.field 'doi',  :string
      end
      delegate_to :properties, [:some_ark], unique: true
      delegate_to :descMetadata, [:doi], unique: true
      ezid_config do
        doi(at: :descMetadata)
        ark(at: :properties, in: :some_ark)
      end
    end
  end

  after(:all) do
    Object.send(:remove_const, :FedoraModel)
  end

  subject(:item) { FedoraModel.new }

  describe "#mint_ezid!" do
    before(:each) do
      item.stub(:persisted? => true)
      item.stub(:pid => 'sufia:xz67gt83a')
    end

    it { should respond_to(:mint_ezid!) }

    it "mints a valid ezid" do
      item.mint_ezid!.should be_nil
    end

    it "uses a configurator for account details" do
      Hydra::Ezid.configurator.doi.user.should eq(CONSTANTINOPLE.ezid.doi.user)
    end

    it "calls Ezid.generate_ezid" do
      pending "*** WE NEED TO IMPLEMENT THIS ***"
      Ezid::ApiSession.any_instance.should_receive(:generate_ezid).once
      item.mint_ezid!
    end

    it "raises an error when minting against an unsaved object" do
      item.stub(:persisted? => false)
      expect { item.mint_ezid! }.to raise_error(Hydra::Ezid::MintError)
    end
    it "stores an id in a configurable location by schema" do
      item.stub(:persisted? => true)
      item.mint_ezid!
      item.some_ark.should == "ark:/98765/sldr2sufia:xz67gt83a"
      item.doi.should == "doi:/10.1000/sldr1sufia:xz67gt83a"
    end
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
