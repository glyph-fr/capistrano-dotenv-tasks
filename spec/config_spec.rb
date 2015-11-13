require 'capistrano/dotenv/config'

RSpec.describe Capistrano::Dotenv::Config do

  shared_examples_for '#to_s' do
    subject { config.to_s }
    it { is_expected.to eq(contents) }
  end

  subject(:config) { described_class.new(contents) }

  context 'VAR=foo' do
    let(:contents) { 'VAR=foo' }

    it_behaves_like '#to_s' do
      describe '#add' do
        before { config.add('NAME=value') }
        it { is_expected.to eq("VAR=foo\nNAME=value")}
      end

      describe '#remove' do
        before { config.remove('VAR') }
        it { is_expected.to eq('') }
      end
    end
  end

  context 'VAR=foo bar' do
    let(:contents) { 'VAR=foo bar' }
    it_behaves_like '#to_s'
  end
end
