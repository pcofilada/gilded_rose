require 'spec_helper'
require 'pry'

describe GildedRose do
  describe '#initialize' do
    it 'initialize @items variable' do
      items = []
      items << Item.new('Regular Item', 10, 30)
      items << Item.new('Aged Brie', 5, 40)
      items << Item.new('Sulfuras, Hand of Ragnaros', 50, 50)
      items << Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 20)
      items << Item.new('Conjured', 25, 15)
      gilded_rose = GildedRose.new(items)

      expect(gilded_rose.instance_variable_get('@items')).to eq(items)
    end
  end

  describe '#update_quality' do
    context 'regular item' do
      before(:each) do
        @items = []
        @items << Item.new('Regular Item', 10, 30)
        @gilded_rose = GildedRose.new(@items)
      end

      it 'decreases sell_in' do
        expect{@gilded_rose.update_quality}.to change{@items.first.sell_in}.from(10).to(9)
      end

      it 'degrades quality' do
        expect{@gilded_rose.update_quality}.to change{@items.first.quality}.from(30).to(29)
      end

      it 'degrades quality twice as fast if sell date has passed' do
        @items << Item.new('Regular Item 2', 0, 30)
        @gilded_rose = GildedRose.new(@items)
        expect{@gilded_rose.update_quality}.to change{@items.last.quality}.from(30).to(28)
      end

      it 'never sets quality to less than 0' do
        40.times{@gilded_rose.update_quality}
        expect(@items.first.quality).to eq(0) 
      end
    end

    context 'Aged Brie' do
      before(:each) do
        @items = []
        @items << Item.new('Aged Brie', 5, 40)
        @gilded_rose = GildedRose.new(@items)
      end

      it 'decreases sell_in' do
        expect{@gilded_rose.update_quality}.to change{@items.first.sell_in}.from(5).to(4)
      end

      it 'increases quality' do
        expect{@gilded_rose.update_quality}.to change{@items.first.quality}.from(40).to(41)
      end

      it 'never exceeds quality by 50' do
        20.times{@gilded_rose.update_quality}
        expect(@items.first.quality).to eq(50)
      end
    end

    context 'Sulfuras, Hand of Ragnaros' do
      before(:each) do
        @items = []
        @items << Item.new('Sulfuras, Hand of Ragnaros', 50, 50)
        @gilded_rose = GildedRose.new(@items)
      end

      it 'does not decrease sell_in' do
        expect{@gilded_rose.update_quality}.to_not change{@items.first.sell_in}
      end

      it 'does not degrade quality' do
        expect{@gilded_rose.update_quality}.to_not change{@items.first.quality}
      end
    end

    context 'Backstage passes' do
      before(:each) do
        @items = []
        @items << Item.new('Backstage passes to a TAFKAL80ETC concert', 15, 20)
        @gilded_rose = GildedRose.new(@items)
      end

      it 'decreases sell_in' do
        expect{@gilded_rose.update_quality}.to change{@items.first.sell_in}.from(15).to(14)
      end

      it 'sets quality to 0 after the concert' do
        @items << Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 20)
        @gilded_rose = GildedRose.new(@items)
        @gilded_rose.update_quality
        expect(@items.last.quality).to eq(0)
      end

      context 'sell_in more than 10 days' do
        it 'increases quality by 1' do
          expect{@gilded_rose.update_quality}.to change{@items.first.quality}.from(20).to(21)
        end
      end

      context 'sell_in 10 days or less' do
        it 'increases quality by 2' do
          @items << Item.new('Backstage passes to a TAFKAL80ETC concert', 9, 20)
          @gilded_rose = GildedRose.new(@items)
          expect{@gilded_rose.update_quality}.to change{@items.last.quality}.from(20).to(22)
        end
      end

      context 'sell_in 5 days or less' do
        it 'increases quality by 3' do
          @items << Item.new('Backstage passes to a TAFKAL80ETC concert', 3, 20)
          @gilded_rose = GildedRose.new(@items)
          expect{@gilded_rose.update_quality}.to change{@items.last.quality}.from(20).to(23)
        end
      end
    end

    context 'Conjured' do
      before(:each) do
        @items = []
        @items << Item.new('Conjured', 25, 15)
        @gilded_rose = GildedRose.new(@items)
      end

      it 'decreases sell_in' do
        expect{@gilded_rose.update_quality}.to change{@items.first.sell_in}.from(25).to(24)
      end

      it 'degrades quality' do
        expect{@gilded_rose.update_quality}.to change{@items.first.quality}.from(15).to(13)
      end

      it 'degrades quality twice as fast if sell date has passed' do
        @items << Item.new('Conjured', 0, 15)
        @gilded_rose = GildedRose.new(@items)
        expect{@gilded_rose.update_quality}.to change{@items.last.quality}.from(15).to(11)
      end

      it 'never sets quality to less than 0' do
        30.times{@gilded_rose.update_quality}
        expect(@items.first.quality).to eq(0) 
      end
    end
  end
end
