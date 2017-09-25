require "kajian/version"
require "kajian/fungsi_bantu"
require "kajian/makro"
require "kajian/koleksi_sumber"
require "kajian/sumber"
require "kajian/sumber/jadwal_kajian"

module Kajian
  TidakAdaSumber = Class.new(StandardError)

  class << self
    def sumber
      @@sumber ||= Kajian::Makro.sumber
    end

    def lihat *sumber_sumber
      sumber_sumber = [:semua] if sumber_sumber.empty?
      if sumber_sumber.length == 1
        if sumber_sumber.first == :semua
          raise TidakAdaSumber unless Kajian.sumber
          Kajian::KoleksiSumber.new(Kajian.sumber)
        else
          s = sumber_sumber.first
          Kajian::Sumber.new(s)
        end
      else
        Kajian::KoleksiSumber.new(sumber_sumber)
      end
    end
  end
end
