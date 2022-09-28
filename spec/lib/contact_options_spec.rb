require_relative '../../lib/contact_options'

describe ContactOptions do
  describe '#call' do
    let(:response) do
      [
        {
          name: 'John Doe',
          email: 'john@brdg.app',
          introsOffered: { free: 3, vip: 0 },
        },
        {
          name: 'Jane Black',
          email: 'billy.jenkins@gmail.com',
          introsOffered: { free: 5, vip: 0 },
        },
      ].to_json
    end

    let!(:result_expected) do
      [
        {
          name: 'Jane Black',
          email: 'billy.jenkins@gmail.com',
          introsOffered: { free: 5, vip: 0 },
          ranking: 8,
          contact_option: 'Vip',
        },
        {
          name: 'John Doe',
          email: 'john@brdg.app',
          introsOffered: { free: 3, vip: 0 },
          ranking: 8,
          contact_option: 'free',
        },
      ].to_json
    end

    it 'return assembled document' do
      result = described_class.call(response:)

      expect(result).to eq result_expected
    end
  end
end
