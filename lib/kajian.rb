require "kajian/version"
require "kajian/fungsi_bantu"
require "kajian/makro"
require "kajian/sumber/jadwal_kajian"

module Kajian
  extend FungsiBantu

  class << self
    def sumber
      @@sumber ||= Kajian::Makro.sumber
    end

    def jadwal
      @@jadwal ||= Kajian.sumber.map do |s|
                     [underscore(s.name).to_sym, s.dokumen]
                   end.to_h
    end

    private :underscore
  end
end
