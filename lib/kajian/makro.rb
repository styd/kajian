module Kajian
  KesalahanDaerah = Class.new(StandardError)

  module Makro
    require 'kajian/fungsi_bantu'
    require 'open-uri'
    require 'nokogiri'
    require 'json'
    require 'thread'

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

    extend FungsiBantu

    @@adapter = []

    class << self
      def extended(adapter)
        @@adapter << adapter
        adapter.simbol = adapter_ke_simbol(adapter)
      end

      def adapter
        @@adapter
      end
    end

    attr_accessor :simbol, *KOLOM.map {|k| "proc_#{k}"}
    attr_reader   :url, :direktori_master, :direktori_salinan, *KOLOM
    attr_writer   :proc_blok,

    def dokumen *daerah_daerah
      set_direktori!
      @buang_direktori ||= []
      @buang_direktori.each {|daerah| direktori_salinan.delete(daerah)}
      unless daerah_daerah.empty?
        daerah_daerah = daerah_daerah.map(&:to_sym)
        daerah_daerah.each do |daerah|
          raise Kajian::KesalahanDaerah, "daerah '#{daerah}' tidak ditemukan" \
            unless direktori_salinan.has_key?(daerah)
        end
        direktori_salinan.keep_if{|k,_| daerah_daerah.include?(k)}
      end

      jadwal  = []
      direktori_salinan.to_a.each_slice(10) do |slice|
        slice.map do |daerah, dir|
          Thread.new do
            jadwal << [daerah, @proc_blok.(daerah, dir)] rescue [daerah, []]
          end
        end.map(&:join)
      end
      jadwal.to_h
    end

    def json_ke_hash(file_name = "#{simbol}.json")
      JSON(
        File.read(File.join(File.dirname(caller[0][/^.*\.rb/]), file_name)),
        symbolize_names: true
      )
    end

    def set_direktori!
      @direktori_salinan = direktori_master.dup
    end

    def buang_direktori(*args)
      set_direktori!
      @pakai_direktori = direktori_master.keys - args.map(&:to_sym)
      @buang_direktori = args
    end

    def pakai_direktori(*args)
      set_direktori!
      @buang_direktori = direktori_master.keys - args.map(&:to_sym)
      @pakai_direktori = args.map(&:to_sym)
    end

    def blok(filter_blok)
      @blok = if block_given?
                proc {|laman| yield(laman)}
              elsif filter_blok
                filter_blok
              end

      @proc_blok = proc do |daerah, dir|
        if instance_variable_get("@laman_#{daerah}").nil?
          laman = Nokogiri::HTML(open(File.join(self.url, dir)))
          instance_variable_set("@laman_#{daerah}", laman)
        end

        laman ||= instance_variable_get("@laman_#{daerah}")

        if @blok.kind_of? Proc
          @blok.(laman)
        elsif filter_blok
          laman.public_send(*filter_blok.to_a.first)
        end.map do |b|
          kajian = {}
          KOLOM.each do |k|
            konten    = self.public_send("proc_#{k}").(b) rescue nil
            kajian[k] = konten.kind_of?(Array) ? (k == :penceramah ? konten : konten.first) : konten
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
                                 konten = blok.public_send(*nilai_k.to_a.first)
                                 konten = if k == :gambar
                                            konten.map {|img| img["src"]}
                                          else
                                            konten.map(&:text)
                                          end
                                 k == :penceramah ? konten : konten.first
                               end

                   if k == :penceramah
                     teks_awal.map do |teks|
                       teks_bersih = bersihkan(teks, filter[:hilangkan], k)
                       teks_sub    = substitusi(teks_bersih, filter[:substitusi])
                       konversi(teks_sub, filter[:parser])
                     end
                   else
                     teks_bersih = bersihkan(teks_awal, filter[:hilangkan], k)
                     teks_sub    = substitusi(teks_bersih, filter[:substitusi])
                     filter[:parser] ||= Date if k == :tanggal
                     konversi(teks_sub, filter[:parser])
                   end
                 end

        self.public_send("proc_#{k}=", proc_k)
      end
    end

    private
      def bersihkan(teks, harus_hilang, nama_kolom)
        teks.gsub!(harus_hilang, '') if harus_hilang
        if nama_kolom == :tema
          teks.sub(/\s+((B|b)ersama (Usta(d)?(z)?(ah)?)? .*)?$/, '')
        elsif nama_kolom == :penceramah
          teks.sub(/^(((A|a)l(\-?|\s+))?(U|u)stad?z?(ah)?)\s+/, '')
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
  end
end
