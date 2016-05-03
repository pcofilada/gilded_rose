require 'spec_helper'

describe Item do
  describe '#initialize' do
    it 'initialize new Item' do
      item = Item.new('Item Name', 10, 20)

      expect(item).to be_instance_of(Item)
    end
  end

  describe '#to_s' do
    it 'returns a readable string format' do
      item = Item.new('Item Name', 10, 20)

      expect(item.to_s).to eq('Item Name, 10, 20')
    end
  end
end
