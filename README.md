# Slackware installer untuk Termux
Halo, ini merupakan script pemasang Slackware terbaru untuk Termux. Dengan script ini kalian dapat memasang dan menjalankan Slackware Linux pada perangkat Android melalui Termux.

# CARA MENGGUNAKAN
Buka Termux. Jika belum punya, install dari repository https://f-droid.org.

Pada Termux ketik:

```
$ wget https://raw.githubusercontent.com/dhocnet/termux-slackwareinstall/main/setup.sh
$ bash setup.sh
```

Instalasi Slackware menggunakan mode interaksi, jadi masukan input yang diperlukan lalu tunggu hingga proses selesai.

# VERSI YANG DIGUNAKAN
Untuk sementara script ini baru mendukung Slackware aarch64 current. Dukungan untuk versi stabil akan ditambahkan nanti.

Sedangkan jenis instalasi terbagi menjadi dua, yaitu *Minimal* dan *Penuh*. Dimana **Minimal** hanya memasang paket seperlunya saja hanya agar sistem dasar dapat berjalan yang biasanya disebut dengan **miniroot**. Paket yang diunduh pada instalasi minimal hanya kurang dari 100MB.

Sedangkan instalasi *Penuh* akan memasang keseluruhan paket dalam distribusi standard Slackware Linux kecuali dukungan untuk GUI. Jenis instalasi ini perlu mengunduh 1.5GB lebih paket binari dan memakan ruang 7GB lebih setelah instalasi.
