require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'test/unit'

class TestUntitled < Test::Unit::TestCase
  def test_foo
    items = [Item.new('foo', 0, 0)]
    GildedRose.new(items).update_quality
    assert_equal items[0].name, 'foo'
  end
  # test expirable avalance  excitable sustain  upgradable
  def test_expava_excsus_upgradable
    b_name = 'Backstage passes to a TAFKAL80ETC concert'
    items = [Item.new(b_name, 0, 10)]
    GildedRose.new(items).update_quality
    assert_equal items[0].to_s, b_name + ", -1, 0"
    GildedRose.new(items).update_quality
    assert_equal items[0].to_s, b_name + ", -2, 0"

    items = [Item.new(b_name, 13, 20),
             Item.new(b_name, 8,  20),
             Item.new(b_name, 5,  20)]
    GildedRose.new(items).update_quality
    assert_equal items[0].to_s, b_name + ", 12, 21"
    assert_equal items[1].to_s, b_name +  ", 7, 22"
    assert_equal items[2].to_s, b_name +  ", 4, 23"
    GildedRose.new(items).update_quality
    assert_equal items[0].to_s, b_name + ", 11, 22"
    assert_equal items[1].to_s, b_name +  ", 6, 24"
    assert_equal items[2].to_s, b_name +  ", 3, 26"
    GildedRose.new(items).update_quality
    assert_equal items[0].to_s, b_name + ", 10, 23"
    assert_equal items[1].to_s, b_name +  ", 5, 26"
    assert_equal items[2].to_s, b_name +  ", 2, 29"
    GildedRose.new(items).update_quality
    assert_equal items[0].to_s, b_name +  ", 9, 25"
    assert_equal items[1].to_s, b_name +  ", 4, 29"
    assert_equal items[2].to_s, b_name +  ", 1, 32"
    GildedRose.new(items).update_quality
    GildedRose.new(items).update_quality
    assert_equal items[0].to_s, b_name +  ", 7, 29"
    assert_equal items[1].to_s, b_name +  ", 2, 35"
    assert_equal items[2].to_s, b_name + ", -1, 0"
    GildedRose.new(items).update_quality
    GildedRose.new(items).update_quality
    assert_equal items[0].to_s, b_name +  ", 5, 33"
    assert_equal items[1].to_s, b_name +  ", 0, 41"
    assert_equal items[2].to_s, b_name + ", -3, 0"
    GildedRose.new(items).update_quality
    assert_equal items[0].to_s, b_name +  ", 4, 36"
    assert_equal items[1].to_s, b_name + ", -1, 0"
    assert_equal items[2].to_s, b_name + ", -4, 0"
  end
  # test  expirable gradual  degradable
  def test_expgrad_degrad
    items = [Item.new('Helium balloon', 0, 52),
             Item.new('Helium balloon', 2, 48)]
             Item.new('Helium balloon', 2, 48)]
    GildedRose.new(items).update_quality
    assert_equal items[0].quality, 50
    assert_equal items[0].sell_in, -1
    assert_equal items[1].quality, 47
    assert_equal items[1].sell_in, 1
    GildedRose.new(items).update_quality
    assert_equal items[0].quality, 48
    assert_equal items[0].sell_in, -2
    assert_equal items[1].quality, 46
    assert_equal items[1].sell_in, 0
    GildedRose.new(items).update_quality
    assert_equal items[0].quality, 46
    assert_equal items[0].sell_in, -3
    assert_equal items[1].quality, 44
    assert_equal items[1].sell_in, -1
    GildedRose.new(items).update_quality
    assert_equal items[0].quality, 44
    assert_equal items[0].sell_in, -4
    assert_equal items[1].quality, 42
    assert_equal items[1].sell_in, -2
  end
  # test  expirable sustain  upgradable sustain
  def test_expsus_upgrsus
    items = [Item.new('Aged Brie', 0, 52),
             Item.new('Aged Brie', 2, 48)]
    GildedRose.new(items).update_quality
    assert_equal items[0].quality, 52
    assert_equal items[0].sell_in, -1
    assert_equal items[1].quality, 49
    assert_equal items[1].sell_in, 1
    GildedRose.new(items).update_quality
    assert_equal items[0].quality, 52
    assert_equal items[0].sell_in, -2
    assert_equal items[1].quality, 50
    assert_equal items[1].sell_in, 0
    GildedRose.new(items).update_quality
    assert_equal items[1].quality, 50
    assert_equal items[1].sell_in, -1
  end
  def test_stable
    c_name = 'Sulfuras, Hand of Ragnaros'
    items = [Item.new(c_name, 0, 10),
             Item.new(c_name, -1, 51),
             Item.new(c_name, 1, 49)]
    GildedRose.new(items).update_quality
    assert_equal items[0].to_s, c_name + ", 0, 10"
    assert_equal items[1].to_s, c_name +  ", -1, 51"
    assert_equal items[2].to_s, c_name +  ", 1, 49"
  end

end
