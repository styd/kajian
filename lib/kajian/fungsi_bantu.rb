module Kajian
  module FungsiBantu
    # Konversi dari kelas adapter ke simbol.
    # Misal:
    #   Kajian::Adapter::JadwalKajian ke :jadwal_kajian
    def adapter_ke_simbol(kelas_adapter)
      kelas_adapter.name
                   .sub(/(\w+::)+/, '')
                   .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                   .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                   .tr("-", "_")
                   .downcase
                   .to_sym
    end

    # Konversi dari simbol ke kelas adapter.
    # Misal:
    #   :jadwal_kajian ke Kajian::Adapter::JadwalKajian
    def simbol_ke_adapter(simbol)
      nama_adapter = simbol.to_s
                           .sub(/^[a-z\d]*/) { |match| match.capitalize }
                           .gsub!(/(?:_)([a-z\d]*)/i) {"#{$1.capitalize}"}
      Kernel.const_get("Kajian::Adapter::#{nama_adapter}")
    end
  end
end
