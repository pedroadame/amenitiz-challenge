require './lib/store'
require './lib/store/cashier'

RSpec.describe Store::Cashier do
  describe '#initalize' do
    context 'when passing rules' do
      it 'assigns an empty array' do
        cashier = described_class.new
        expect(cashier.rules).to be_empty
      end
    end

    context 'without passing rules' do
      it 'assigns passed rules' do
        cashier = described_class.new([:rule1, :rule2])
        expect(cashier.rules.size).to eq(2)
      end
    end
  end
end