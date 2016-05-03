class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      case item.name
      when 'Aged Brie'
        if item.quality < 50
          item.quality += 1
        end
      when 'Sulfuras, Hand of Ragnaros'
      when 'Backstage passes to a TAFKAL80ETC concert'
        item.quality += 1 if item.quality < 50 && item.sell_in <= 10
        item.quality += 1 if item.quality < 50 && item.sell_in <= 5
        item.quality += 1 if item.quality < 50
        item.quality = 0 if item.sell_in <= 0
      when 'Conjured'
        if item.quality > 1
          item.quality -= 2
          item.quality -= 2 if item.sell_in < 0
        elsif item.quality == 1
          item.quality -= 1
        end
      else
        if item.sell_in > 0
          item.quality -= 1
        elsif item.sell_in < 0 && item.quality > 0
          item.quality -= 1
          item.quality -= 1 if item.quality > 0
        end
      end

      item.sell_in -= 1 unless item.name == 'Sulfuras, Hand of Ragnaros'
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
