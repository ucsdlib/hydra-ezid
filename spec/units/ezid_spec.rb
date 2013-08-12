require 'spec_helper'

describe Hydra::Ezid do
  before(:all) do
    class FedoraModel < ActiveFedora::Base
      include Hydra::Ezid::Identifiable
      has_metadata :name => 'properties', :type => ActiveFedora::SimpleDatastream do |m|
        m.field 'some_ark',  :string
      end
      has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream do |m|
        m.field 'doi',  :string
      end
      delegate_to :properties, [:some_ark], unique: true
      delegate_to :descMetadata, [:doi], unique: true
      ezid_config do
        store_doi at: :descMetadata
        store_ark at: :properties, in: :some_ark
        find_creator at: :descMetadata, in: :author
        find_title at: :properties
        find_publisher at: :properties
        find_publication_year at: :descMetadata, in: :pubYear
      end
    end
  end

  after(:all) do
    Object.send(:remove_const, :FedoraModel)
  end

  subject(:item) { FedoraModel.new }

  describe "#mint_ezid" do
    before(:each) do
      item.stub(:persisted?).and_return(true)
    end

    it { should respond_to(:mint_ezid) }

    it "raises an error when minting against an unsaved object" do
      item.stub(:persisted?).and_return(false)
      expect { item.mint_ezid }.to raise_error(Hydra::Ezid::MintError)
    end

    it 'returns nil' do
      item.mint_ezid.should be_nil
    end

    it "provides a convenience method for minting only ARKs" do
      item.mint_ark
      item.some_ark.should == "ark:/98765/sldr2sufia:xz67gt83a"
      item.doi.should be_nil
    end

    it "provides a convenience method for minting only DOIs" do
      item.mint_doi
      item.some_ark.should be_nil
      item.doi.should == "doi:10.1000/sldr1sufia:xz67gt83a"
    end

    it "stores an id in a configurable location by scheme" do
      item.mint_ezid
      item.some_ark.should == "ark:/98765/sldr2sufia:xz67gt83a"
      item.doi.should == "doi:10.1000/sldr1sufia:xz67gt83a"
    end

    describe "the configurator" do
      it "uses the yaml file by default" do
        Hydra::Ezid.config['doi']['user'].should == 'apitest'
      end

      it "allows a file to be passed in" do
        f = File.open(File.join('config', 'ezid_override.yml'))
        item.mint_ezid(Hydra::Ezid.config(f))
        item.some_ark.should be_nil
        item.doi.should == "doi:10.2000/sldr3sufia:xz67gt83a"
      end

      it "allows a symbol to be passed in" do
        item.mint_ezid(Hydra::Ezid.config(:ark))
        item.some_ark.should == "ark:/98765/sldr2sufia:xz67gt83a"
        item.doi.should be_nil
      end

      it "allows a string to be passed in" do
        item.mint_ezid(Hydra::Ezid.config('ark'))
        item.some_ark.should == "ark:/98765/sldr2sufia:xz67gt83a"
        item.doi.should be_nil
      end

      it "allows an array of symbols to be passed in" do
        item.mint_ezid(Hydra::Ezid.config([:doi]))
        item.doi.should == "doi:10.1000/sldr1sufia:xz67gt83a"
        item.some_ark.should be_nil
      end

      it "allows an array of strings to be passed in" do
        item.mint_ezid(Hydra::Ezid.config(['doi']))
        item.doi.should == "doi:10.1000/sldr1sufia:xz67gt83a"
        item.some_ark.should be_nil
      end

      it "treats multiple args as an array" do
        item.mint_ezid(Hydra::Ezid.config('doi', :ark))
        item.doi.should == "doi:10.1000/sldr1sufia:xz67gt83a"
        item.some_ark.should == "ark:/98765/sldr2sufia:xz67gt83a"
      end

      it "allows a hash to be passed in" do
        item.mint_ezid(Hydra::Ezid.config({doi: {shoulder: 'sldr4', naa: '20.2000'}}))
        item.doi.should == "doi:20.2000/sldr4sufia:xz67gt83a"
        item.some_ark.should be_nil
      end
    end
  end

  it "disallows repeat settings of a scheme"
  it "disallows setting of the ezid manually"
  it "updates/saves when changed"
  it "crosswalks metadata"
  it "sends crosswalked metadata to the ezid service"
  it "allows specification of DOI or ARK"
  it "allows multiple accounts"
  it "allows management of status (public, private, etc.)"
end
