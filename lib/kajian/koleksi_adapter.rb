require 'kajian/adapter'

module Kajian
  class KoleksiAdapter
    def initialize(sumber_sumber)
      @adapter_adapter = sumber_sumber
    end

    def semua
      koleksi = {}
      @adapter_adapter.map do |adapter|
        koleksi = koleksi.merge(Kajian::Adapter.new(adapter).semua)
      end
      koleksi
    end

    def [](daerah)
      koleksi = {}
      @adapter_adapter.map do |adapter|
        koleksi = koleksi.merge(Kajian::Adapter.new(adapter).public_send(daerah))
      end
      koleksi
    end

    def method_missing(m)
      self[m]
    end
  end
end
