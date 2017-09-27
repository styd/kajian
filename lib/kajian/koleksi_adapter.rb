require 'kajian/adapter'

module Kajian
  class KoleksiAdapter
    def initialize(sumber_sumber)
      @adapter_adapter = sumber_sumber
    end

    def semua
      @adapter_adapter.map do |adapter|
        Kajian::Adapter.new(adapter).semua
      end
    end

    def [](daerah)
      @adapter_adapter.map do |adapter|
        Kajian::Adapter.new(adapter).public_send(daerah)
      end
    end

    def method_missing(m)
      self[m]
    end
  end
end
