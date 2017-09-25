module Kajian
  module FungsiBantu
    # Konversi dari kelas sumber ke simbol.
    # Misal:
    #   Kajian::Sumber::JadwalKajian ke :jadwal_kajian
    def sumber_ke_simbol(kelas)
      kelas.name
           .sub(/(\w+::)+/, '')
           .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
           .gsub(/([a-z\d])([A-Z])/, '\1_\2')
           .tr("-", "_")
           .downcase
           .to_sym
    end

    # Konversi dari simbol ke kelas sumber.
    # Misal:
    #   :jadwal_kajian ke Kajian::Sumber::JadwalKajian
    def simbol_ke_sumber(simbol)
      nama_sumber = simbol.to_s
                          .sub(/^[a-z\d]*/) { |match| match.capitalize }
                          .gsub!(/(?:_)([a-z\d]*)/i) { "#{$1.capitalize}" }
      Kernel.const_get("Kajian::Sumber::#{nama_sumber}")
    end
  end
end
