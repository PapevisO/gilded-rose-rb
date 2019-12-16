class GildedRose
  PARAM_TYPES = { sustain: 100, avalance: 200, gradual: 300, default: 400 }.freeze

  def item_process_by_cat(item, category)
    Array(category[:upgradeable]).each do |upgradeable|
      if upgradeable[:type] === :sustain
        if upgradeable.fetch(:rate, 1) < 0
          if item.quality > upgradeable.fetch(:setpoint, 50)
            item.quality += upgradeable.fetch(:rate, 1)
          end
        else
          if item.quality < upgradeable.fetch(:setpoint, 50)
            item.quality += upgradeable.fetch(:rate, 1)
          end
        end
      else
        item.quality += upgradeable.fetch(:rate, 1)
      end
    end
    Array(category[:excitable]).each do |excitable|
      next if (
        (!excitable[:sell_in_is_greater_than].nil?) &&
        (item.sell_in <= excitable[:sell_in_is_greater_than])
      )
      next if (
        (!excitable[:sell_in_is_less_than].nil?) &&
        (item.sell_in >= excitable[:sell_in_is_less_than])
      )

      if excitable[:type] === :sustain
        if item.quality < excitable.fetch(:setpoint, 50)
          item.quality += excitable.fetch(:rate, 1)
        end
      else
        item.quality += excitable.fetch(:rate, 1)
      end
    end
    item.sell_in -= 1 unless Array(category[:expirable]).count.zero?
    Array(category[:expirable]).each do |expirable|
      if item.sell_in < 0
        if expirable[:type] === :sustain
          if item.quality < expirable.fetch(:setpoint, 50)
            item.quality -= expirable.fetch(:rate, 1)
          end
        elsif expirable[:type] === :avalance
          if item.quality > expirable.fetch(:setpoint, 0)
            item.quality = 0
            return
          end
        elsif expirable[:type] === :gradual
          if item.quality > expirable.fetch(:setpoint, 0)
            item.quality -= expirable.fetch(:rate, 1)
          end
        else
          item.quality -= expirable.fetch(:rate, 1)
        end
      end
    end
  end

  def initialize(items)
    @kinds = {
      expirable_avalance_excitable_sustain_upgradable: {
        upgradeable: [
            {type: :sustain, setpoint: 50}],
        excitable: [
            {type: :sustain, sell_in_is_less_than: 11, setpoint: 50},
            {type: :sustain, sell_in_is_less_than: 6, setpoint: 50}],
        expirable: [
            {type: :avalance}
        ]},
      expirable_sustain_upgradable_sustain: {
        upgradeable: [
            {type: :sustain, setpoint: 50}],
        expirable: [
            {type: :sustain, setpoint: 50},
        ]},
      stable: {},
      default: {
        upgradeable: [
            {type: :sustain, setpoint: 0, rate: -1}
        ],
        expirable: [
            {type: :gradual, setpoint: 0}
        ]}
    }

    @item_categories = {
        'Aged Brie' => @kinds[:expirable_sustain_upgradable_sustain],
        'Backstage passes to a TAFKAL80ETC concert' => @kinds[:expirable_avalance_excitable_sustain_upgradable],
        'Sulfuras, Hand of Ragnaros' => @kinds[:stable],
        '' => @kinds[:default],
        :default => @kinds[:default]
    }

    @items = items
  end

  def update_quality
    @items.each do |item|
      if item.name != 'Aged Brie' and item.name != 'Backstage passes to a TAFKAL80ETC concert'
        if item.quality > 0
          if item.name != 'Sulfuras, Hand of Ragnaros'
            item.quality = item.quality - 1
          end
        end
      else
        if item.quality < 50
          item.quality = item.quality + 1
          if item.name == 'Backstage passes to a TAFKAL80ETC concert'
            if item.sell_in < 11
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
          end
        end
      end
      if item.name != 'Sulfuras, Hand of Ragnaros'
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if item.name != 'Aged Brie'
          if item.name != 'Backstage passes to a TAFKAL80ETC concert'
            if item.quality > 0
              if item.name != 'Sulfuras, Hand of Ragnaros'
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      end
    end
  end

  def update_quality_draft
    @items.each do |item|
      item_process_by_cat(item, @item_categories.fetch(item.name, @kinds[:default]))
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

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
