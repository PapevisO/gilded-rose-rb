require 'rspec'
require File.join(File.dirname(__FILE__), '../gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq 'foo'
    end

    it "does handle item with properties of instant expiry, pre-expiry 2-lev excitation and sustainable uptrending" do
      b_name = 'Backstage passes to a TAFKAL80ETC concert'

      items = [Item.new(b_name, 0, 10)]
      GildedRose.new(items).update_quality
      expect( items[0].to_s ).to eq b_name + ", -1, 0"
      GildedRose.new(items).update_quality
      expect( items[0].to_s ).to eq b_name + ", -2, 0"

      items = [Item.new(b_name, 13, 20),
               Item.new(b_name, 8,  20),
               Item.new(b_name, 5,  20)]
      GildedRose.new(items).update_quality
      expect( items[0..2].map(&:to_s).join("").split(b_name+', ')[1..-1] ).to eq ["12, 21", "7, 22", "4, 23"]
      GildedRose.new(items).update_quality
      expect( items[0..2].map(&:to_s).join("").split(b_name+', ')[1..-1] ).to eq ["11, 22", "6, 24", "3, 26"]
      GildedRose.new(items).update_quality
      expect( items[0..2].map(&:to_s).join("").split(b_name+', ')[1..-1] ).to eq ["10, 23", "5, 26", "2, 29"]
      GildedRose.new(items).update_quality
      expect( items[0..2].map(&:to_s).join("").split(b_name+', ')[1..-1] ).to eq [ "9, 25", "4, 29", "1, 32"]
      GildedRose.new(items).update_quality
      GildedRose.new(items).update_quality
      expect( items[0..2].map(&:to_s).join("").split(b_name+', ')[1..-1] ).to eq [ "7, 29", "2, 35", "-1, 0"]
      GildedRose.new(items).update_quality
      GildedRose.new(items).update_quality
      expect( items[0..2].map(&:to_s).join("").split(b_name+', ')[1..-1] ).to eq [ "5, 33", "0, 41", "-3, 0"]
      GildedRose.new(items).update_quality
      expect( items[0..2].map(&:to_s).join("").split(b_name+', ')[1..-1] ).to eq [ "4, 36", "-1, 0", "-4, 0"]
    end

    it "does handle item with properties of gradual expiry and sustainable downtrending" do
      d_name = 'Helium balloon'
      items = [Item.new(d_name, 0, 52),
               Item.new(d_name, 2, 48)]
      GildedRose.new(items).update_quality
      expect( items[0..1].map(&:to_s).join("").split(d_name+', ')[1..-1] ).to eq [ "-1, 50",  "1, 47"]
      GildedRose.new(items).update_quality
      expect( items[0..1].map(&:to_s).join("").split(d_name+', ')[1..-1] ).to eq [ "-2, 48",  "0, 46"]
      GildedRose.new(items).update_quality
      expect( items[0..1].map(&:to_s).join("").split(d_name+', ')[1..-1] ).to eq [ "-3, 46", "-1, 44"]
      GildedRose.new(items).update_quality
      expect( items[0..1].map(&:to_s).join("").split(d_name+', ')[1..-1] ).to eq [ "-4, 44", "-2, 42"]
      items = [Item.new(d_name, 1, 5),
               Item.new(d_name, 2, 3)]
      GildedRose.new(items).update_quality
      expect( items[0..1].map(&:to_s).join("").split(d_name+', ')[1..-1] ).to eq [  "0, 4",  "1, 2"]
      GildedRose.new(items).update_quality
      expect( items[0..1].map(&:to_s).join("").split(d_name+', ')[1..-1] ).to eq [ "-1, 2",  "0, 1"]
      GildedRose.new(items).update_quality
      expect( items[0..1].map(&:to_s).join("").split(d_name+', ')[1..-1] ).to eq [ "-2, 0", "-1, 0"]
    end

    it "does handle item with properties of sustainable expiry and sustainable uptrending" do
      a_name = 'Aged Brie'
      items = [Item.new(a_name, 0, 52),
               Item.new(a_name, 2, 48)]
      GildedRose.new(items).update_quality
      expect( items[0..1].map(&:to_s).join("").split(a_name+', ')[1..-1] ).to eq [ "-1, 52",  "1, 49"]
      GildedRose.new(items).update_quality
      expect( items[0..1].map(&:to_s).join("").split(a_name+', ')[1..-1] ).to eq [ "-2, 52",  "0, 50"]
      GildedRose.new(items).update_quality
      expect( items[0..1].map(&:to_s).join("").split(a_name+', ')[1..-1] ).to eq [ "-3, 52", "-1, 50"]
    end

    it "does handle item with stable properties" do
      c_name = 'Sulfuras, Hand of Ragnaros'
      items = [Item.new(c_name, 0, 10),
               Item.new(c_name, -1, 51),
               Item.new(c_name, 1, 49)]
      GildedRose.new(items).update_quality
      expect( items[0..2].map(&:to_s).join("").split(c_name+', ')[1..-1] ).to eq ["0, 10", "-1, 51", "1, 49"]
    end
  end
end