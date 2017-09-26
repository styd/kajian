require 'kajian/makro'

module Kajian
  class Sumber
    class JadwalKajian
      extend Kajian::Makro

      @url = 'http://jadwalkajian.com'

      # buang_direktori(
      #   :aceh, :bali, :balikpapan, :barabai, :bandung, :banten, :batam, :bojonegoro,
      #   :boyolali, :cilacap, :cilegon, :denpasar, :garut, :gorontalo, :indramayu,
      #   :jayapura, :kampar, :karawang, :kebumen, :kediri, :kutai_kartanegara,
      #   :madiun, :magelang, :makassar, :malang, :medan, :manokwari, :palangkaraya,
      #   :pamulang, :pasuruan, :pekalongan, :pemalang, :ponorogo, :salatiga,
      #   :samarinda, :sangatta, :semarang, :sidoarjo, :solo, :sukoharjo, :sumedang,
      #   :surabaya, :surakarta, :tarakan, :yogyakarta
      # )

      # pakai_direktori(:bekasi, :jakarta)

      blok(css: 'div.eventon_list_event.event')

      tema(css: 'span.evcal_event_title')

      penceramah(css: 'span.evcal_event_subtitle', substitusi: {/dr\.?/ => 'Dr.'})

      tempat do |blok|
        blok.css('div.evo_location').map do |lokasi|
          lokasi.css('p').map(&:text).join("\n")
        end
      end

      tanggal parser: Date do |blok|
        "#{blok.css('span.evcal_cblock .evo_date span.start').first.text.to_i} " +
          "#{blok.css('span.evcal_cblock').first["data-smon"]}"
      end

      waktu(css: 'div.evo_time p', hilangkan: /^\(.*\)\s+/)

      gambar do |blok|
        blok.css('div.evo_metarow_locImg').map do |img|
          img.attributes.values[1].value[/(?<=url\().*(?=\))/]
        end
      end
    end
  end
end
