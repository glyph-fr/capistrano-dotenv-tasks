require 'capistrano/dotenv/config'

RSpec.describe Capistrano::Dotenv::Config do

  shared_examples_for '#to_s' do
    subject { config.to_s }
    it { is_expected.to eq(contents + "\n") }
  end

  subject(:config) { described_class.new(contents) }

  context 'VAR=foo' do
    let(:contents) { 'VAR=foo' }

    it_behaves_like '#to_s' do
      describe '#add' do
        before { config.add('NAME=value') }
        it { is_expected.to eq("NAME=value\nVAR=foo\n")}
      end

      describe '#remove' do
        before { config.remove('VAR') }
        it { is_expected.to eq("\n") }
      end
    end
  end

  context 'VAR=foo bar' do
    let(:contents) { 'VAR=foo bar' }
    it_behaves_like '#to_s'
  end

  context 'VAR="double#quoted#string"' do
    let(:contents) {'VAR="double#quoted#string"'}

    it_behaves_like '#to_s' do
      describe '#add' do
        before { config.add('NAME=value') }
        it { is_expected.to eq("NAME=value\nVAR=\"double#quoted#string\"\n")}
      end

      describe '#remove' do
        before { config.remove('VAR') }
        it { is_expected.to eq("\n") }
      end
    end
  end

  context "VAR='single#quoted#string'" do
    let(:contents) {"VAR='single#quoted#string'"}

    it_behaves_like '#to_s' do
      describe '#add' do
        before { config.add('NAME=value') }
        it { is_expected.to eq("NAME=value\nVAR='single#quoted#string'\n")}
      end

      describe '#remove' do
        before { config.remove('VAR') }
        it { is_expected.to eq("\n") }
      end
    end
  end
end
