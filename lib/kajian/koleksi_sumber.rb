require 'kajian/sumber'

module Kajian
  class KoleksiSumber
    def initialize(sumber_sumber)
      @kelas_kelas = sumber_sumber
    end

    def semua
      @kelas_kelas.map do |kelas|
        Kajian::Sumber.new(kelas).semua
      end
    end

    def [](daerah)
      @kelas_kelas.map do |kelas|
        Kajian::Sumber.new(kelas).public_send(daerah)
      end
    end

    def method_missing(m)
      self[m]
    end
  end
end
