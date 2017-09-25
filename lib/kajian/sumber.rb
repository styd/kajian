require 'kajian/fungsi_bantu'

module Kajian
  class Sumber
    include FungsiBantu

    def initialize(sumber)
      if sumber.kind_of?(Class)
        @kelas_sumber = sumber
        @simbol_sumber = sumber_ke_simbol(sumber)
      elsif sumber.kind_of? String or sumber.kind_of? Symbol
        @kelas_sumber = simbol_ke_sumber(sumber)
        @simbol_sumber = sumber.to_sym
      end
    end

    def semua
      {@simbol_sumber => @kelas_sumber.dokumen}
    end

    def [](daerah)
      {@simbol_sumber => @kelas_sumber.dokumen(daerah)}
    end

    def method_missing(m)
      self[m]
    end
  end
end
