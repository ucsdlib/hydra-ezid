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
  it { should respond_to(:ezid) }
  it "mints an ezid"
  it "stores an ezid in a configurable location"
  it "disallows setting of the ezid manually"
  it "crosswalks metadata"
  it "sends crosswalked metadata to the ezid service"
  it "updates metadata when changed"
  it "supports an overrideable queue"
  it "retrieves the ezid"
  it "allows specification of DOI or ARK"
  it "allows multiple accounts"
  it "allows management of status (public, private, etc.)"
end
