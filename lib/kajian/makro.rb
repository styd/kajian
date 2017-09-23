module Kajian
  module Makro
    require 'open-uri'
    require 'nokogiri'

    KOLOM = %i[tema penceramah tempat tanggal waktu gambar]
    BULAN = {
      "januari"  => "january",
      "februari" => "february",
      "pebruari" => "february",
      "maret"    => "march",
      "mei"      => "may",
      "juni"     => "june",
      "juli"     => "july",
      "agustus"  => "august",
      "oktober"  => "october",
      "desember" => "december",
    }

    @@sumber       = []
    @@waktu_simpan = Time.now - 3600

    class << self
      def extended(sumber)
        @@sumber << sumber
      end

      def sumber
        @@sumber
      end
    end

    attr_accessor *KOLOM.map {|k| "proc_#{k}"}
    attr_reader :url, :direktori_kota, *KOLOM
    attr_writer :proc_blok

    def dokumen
      @@durasi_simpan = 10
      if @dokumen.nil? or perlu_diperbarui?
        @dokumen       = direktori_kota.map do |kota, dir|
                           [kota, @proc_blok.(kota)]
                         end.to_h
        @@waktu_simpan = Time.now
      end
      @dokumen
    end

    def blok(filter_blok)
      @blok = if block_given?
                proc {|laman| yield(laman)}
              elsif filter_blok
                filter_blok
              end

      self.proc_blok = proc do |kota|
        if instance_variable_get("@laman_#{kota}").nil? or perlu_diperbarui?
          laman = Nokogiri::HTML(open(File.join(self.url, self.direktori_kota[kota])))
          instance_variable_set("@laman_#{kota}", laman)
        end

        laman ||= instance_variable_get("@laman_#{kota}")

        if @blok.kind_of? Proc
          @blok.(laman)
        elsif filter_blok
          laman.public_send(*filter_blok.to_a.first)
        end.map do |b|
          kajian = {}
          KOLOM.each do |k|
            konten    = self.public_send("proc_#{k}").(b) rescue nil
            kajian[k] = konten.kind_of?(Array) ? konten.first : konten
          end
          kajian
        end
      end
    end

    KOLOM.each do |k|
      define_method k do |filter = {}, &block|
        nilai_k = if block
                    proc {|blok| block.(blok)}
                  elsif filter[:css]
                    Hash[*filter.assoc(:css)]
                  elsif filter[:xpath]
                    Hash[*filter.assoc(:xpath)]
                  end

        instance_variable_set("@#{k}", nilai_k)

        proc_k = proc do |blok|
                   teks_awal = if instance_variable_get("@#{k}").kind_of? Proc
                                 instance_variable_get("@#{k}").(blok)
                               elsif nilai_k
                                 blok.public_send(*nilai_k.to_a.first)
                                     .map(&:text).first
                               end

                   teks_bersih = bersihkan(teks_awal, filter[:hilangkan], k)
                   teks_sub    = substitusi(teks_bersih, filter[:substitusi])
                   konversi(teks_sub, filter[:parser])
                 end

        self.public_send("proc_#{k}=", proc_k)
      end
    end

    def bersihkan(teks, harus_hilang, nama_kolom)
      if harus_hilang
        teks.gsub(harus_hilang, '')
      elsif nama_kolom == :penceramah
        teks.sub(/^(((A|a)l(\-?|\s+))?(U|u)stadz) /, '')
      elsif nama_kolom == :tanggal
        BULAN.each do |asal_kata, terjemahan|
          teks.sub!(asal_kata, terjemahan)
        end
        teks
      else
        teks
      end
    end

    def substitusi(teks, sub_hash)
      sub_hash ? teks.gsub(*sub_hash.to_a.first) : teks
    end

    def konversi(teks, parser)
      parser ? parser.parse(teks) : teks
    end

    def perlu_diperbarui?
      Time.now > @@waktu_simpan + @@durasi_simpan
    end
  end
end
