require 'kajian/fungsi_bantu'

module Kajian
  class Adapter
    include FungsiBantu

    def initialize(sumber)
      if sumber.kind_of?(Class)
        @kelas_sumber = sumber
        @simbol_sumber = adapter_ke_simbol(sumber)
      elsif sumber.kind_of?(String) or sumber.kind_of?(Symbol)
        @kelas_sumber = simbol_ke_adapter(sumber)
        @simbol_sumber = sumber.to_sym
      end
    end

    def semua
      {@simbol_sumber => @kelas_sumber.dokumen}
    end

    def [](*daerah_daerah)
      {@simbol_sumber => @kelas_sumber.dokumen(*daerah_daerah)}
    end

    def method_missing(m)
      self[m]
    end
  end
end
