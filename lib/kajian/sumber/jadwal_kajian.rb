require 'kajian/makro'

module Kajian::Sumber
  class JadwalKajian
    extend Kajian::Makro

    @url = 'http://jadwalkajian.com'

    @direktori_kota = {
      jakarta: '/jakarta',
      bekasi: '/bekasi',
      bogor: '/bogor',
    }

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
        "#{blok.css('span.evcal_cblock').first.attributes["data-smon"].value}"
    end

    waktu(css: 'div.evo_time p', hilangkan: /^\(.*\)\s+/)

    gambar do |blok|
      blok.css('div.evo_metarow_locImg').map do |img|
        img.attributes.values[1].value[/(?<=url\().*(?=\))/]
      end
    end
  end
end
