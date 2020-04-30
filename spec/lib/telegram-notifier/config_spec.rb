RSpec.describe Telegram::Notifier::Config do
  %i[token chat_id].each do |attr|
    describe "##{attr}" do
      it 'default value is nil' do
        expect(described_class.new.send(attr)).to eq(nil)
      end
    end

    describe "##{attr}=" do
      let(:value) { 'string' }

      it 'can set value' do
        config = described_class.new
        config.send("#{attr}=", value)
        expect(config.send(attr)).to eq(value)
      end
    end
  end
end
