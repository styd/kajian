# Kajian

Pustaka ruby untuk mengekstrak data acara kajian Islam dari berbagai situs di
Indonesia. Dengan menggunakan DSL (Domain Specific Language), mudah untuk
membuat adapter untuk situs-situs lain yang akan diekstrak data acara kajiannya.

Gem ini mengikutsertakan sebuah adapter untuk situs
[jadwal kajian](http://jadwalkajian.com) dengan simbol adapter `:jadwal_kajian`.


## Pemasangan

Tambahkan baris berikut ini pada Gemfile Anda:

```ruby
gem 'kajian'
```

Lalu jalankan:

    $ bundle

Atau Anda pasang sendiri seperti ini:

    $ gem install kajian


## Penggunaan

Jangan lupa `require` sebelum melihat kajian.

```ruby
require 'kajian'
```


Lihat semua kajian

```ruby
Kajian.lihat(:semua).semua
```


Lihat semua kajian untuk daerah/kota "Bekasi"

```ruby
Kajian.lihat(:semua).bekasi
```


Lihat semua kajian yang dipublikasikan melalui situs jadwal kajian

```ruby
Kajian.lihat(:jadwal_kajian).semua
```


Lihat semua kajian yang dipublikasikan melalui situs jadwal kajian
daerah/kota "Tangerang"

```ruby
Kajian.lihat(:jadwal_kajian).tangerang
```


Tambah adapter lain, contoh [Kajian Muslim](https://kajianmuslim.com)

```ruby
require 'kajian/adapter/kajian_muslim'

Kajian.lihat(:kajian_muslim).malang

Kajian.lihat(:jadwal_kajian, :kajian_muslim).jakarta

Kajian.lihat(:semua).bandung
```


## TODO

  * Dokumentasi cara membuat adapter kajian dengan menggunakan DSL Kajian
  * Pencarian isi kolom yang efisien.
  * Sortir berdasarkan kolom.
  * Pengecualian adapter.


## Kontribusi

Laporan _bug_ dan _pull request_ dapat diajukan melalui Github https://github.com/styd/kajian.


## Lisensi

Gem ini tersedia sebagai _open source_ sesuai ketentuan [MIT License](http://opensource.org/licenses/MIT).
