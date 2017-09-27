require "kajian/version"
require "kajian/fungsi_bantu"
require "kajian/makro"
require "kajian/koleksi_adapter"
require "kajian/adapter"
require "kajian/adapter/jadwal_kajian"

module Kajian
  TidakAdaAdapter = Class.new(StandardError)

  class << self
    def adapter
      @@adapter ||= Kajian::Makro.adapter
    end

    def lihat *sumber_sumber
      sumber_sumber = [:semua] if sumber_sumber.empty?
      if sumber_sumber.length == 1
        if sumber_sumber.first == :semua
          raise TidakAdaAdapter unless Kajian.adapter
          Kajian::KoleksiAdapter.new(Kajian.adapter)
        else
          s = sumber_sumber.first
          Kajian::Adapter.new(s)
        end
      else
        Kajian::KoleksiAdapter.new(sumber_sumber)
      end
    end
  end
end
