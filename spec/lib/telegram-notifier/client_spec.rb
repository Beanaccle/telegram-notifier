RSpec.describe Telegram::Notifier::Client do
  let(:uri) { 'https://example.com' }
  let(:params) { {} }

  describe '::post(uri, params)' do
    let(:mock_client) { instance_double('Telegram::Notifier::Client') }

    it 'initializes Client with the given uri and params then calls' do
      expect(described_class).to receive(:new).with(uri, params).and_return(mock_client)
      expect(mock_client).to receive(:call)

      described_class.post(uri, params)
    end
  end

  describe '#initialize' do
    subject { described_class.new uri, params }

    it 'sets the given hook_url to the endpoint URI' do
      expect(subject.uri).to eq URI.parse(uri)
    end
  end

  describe '#call' do
    let(:mock_http) { instance_double('Net::HTTP') }

    before do
      allow(Net::HTTP).to receive(:new).and_return(mock_http)
      allow(mock_http).to receive(:use_ssl=)
    end

    subject { described_class.new(uri, params).call }

    context 'raises an error when the response is unsuccessful' do
      let(:res_body) { { ok: false }.to_json }
      let(:res_code) { 400 }
      let(:bad_request) { Net::HTTPBadRequest.new('POST', res_code, 'Bad Request') }

      before do
        allow(bad_request).to receive(:body).and_return(res_body)
        allow(mock_http).to receive(:start) { bad_request }
      end

      # subject { -> { described_class.new(uri, params).call } }

      it { expect { subject }.to raise_error(Telegram::Notifier::APIError, /#{res_body} \(HTTP Code #{res_code}\)/) }
    end

    context 'returns an hash when the response is successful' do
      let(:res_body) { { ok: true }.to_json }
      let(:success) { Net::HTTPSuccess.new('POST', 200, 'OK') }

      before do
        allow(success).to receive(:body).and_return(res_body)
        allow(mock_http).to receive(:start).and_return(success)
      end

      it { is_expected.to be_a(Hash) }
    end
  end
end
