require_relative '../../../lib/hydra/ezid'

module Hydra
  describe Ezid do
    subject { Hydra::Ezid }
    its(:config) { should be_kind_of Hash }

    it 'should allow key retrieval from .config' do
      expect(subject.config(:doi)).to be_kind_of Hash
    end
  end
end