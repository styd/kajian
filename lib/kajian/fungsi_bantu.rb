module Kajian
  module FungsiBantu
    def underscore(string)
      string.sub(/(\w+::)+/, '')
            .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .tr("-", "_")
            .downcase
    end
  end
end
