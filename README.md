# Responsi Mixed Reality: AR Number 2 Tracer 🚀

Aplikasi **Augmented Reality (AR) Number 2 Tracer** adalah proyek interaktif berbasis **Processing** yang memanfaatkan kamera laptop/webcam untuk mendeteksi pergerakan telapak tangan (*hand tracking*) secara real-time. Pengguna berinteraksi dengan layar virtual untuk menghubungkan titik-titik panduan secara berurutan hingga membentuk angka **2**.

Proyek ini dibuat dengan kode yang minimalis dan terstruktur, menggunakan logika dasar OpenCV yang disesuaikan dengan materi praktikum Mixed Reality.

Demo: 
https://github.com/user-attachments/assets/f1dbbed3-4826-47b7-87f4-996f5078035a
<img width="1920" height="1080" alt="demo_mixedreality" src="https://github.com/user-attachments/assets/7a39ac57-ff45-4929-b288-a0f0c8c4e944" />

>マンゴー・マンボー No.2で行こう甘い甘いフルーツのリズムリップクリームなんて捨てて本気のルージュ引きたい背伸びをしてAH- CHA CHA CHA
---

## 📸 Fitur Utama

1. **Mirrored Camera Feed (Menggunakan Matrix Push/Pop)**: 
   Tampilan kamera di-mirror secara horizontal agar pergerakan tangan terasa intuitif seperti bercermin (gerakan tangan kanan akan bergeser ke kanan layar). Transformasi sumbu ini diisolasi menggunakan `pushMatrix()` dan `popMatrix()` agar tidak mengganggu orientasi objek gambar lainnya di layar.
2. **OpenCV Palm Tracking**: 
   Pelacakan menggunakan model klasifikasi Haar Cascade (`palm.xml`) untuk mendeteksi telapak tangan secara stabil dan responsif.
3. **Collision Detection**: 
   Penghitungan jarak interaktif antara titik tengah tangan yang terdeteksi dengan titik target menggunakan fungsi matematika `dist()`.
4. **Neon Tracer Line**: 
   Menggambar jalur garis penunjuk dinamis dari titik terakhir ke posisi kursor tangan Anda saat ini.

---

## 🛠️ Persyaratan Sistem & Dependensi

Untuk menjalankan proyek ini, Anda perlu menginstal beberapa pustaka (*libraries*) berikut melalui **Contribution Manager** di Processing IDE (**Sketch** -> **Import Library...** -> **Add Library...**):

1. **Video** (oleh *The Processing Foundation*): Untuk mengakses kamera/webcam.
2. **OpenCV for Processing** (oleh *Greg Borenstein*): Untuk pemrosesan gambar dan deteksi objek.

### 📂 Struktur Folder Proyek
Pastikan file cascade diletakkan di dalam folder `data` agar dapat dimuat oleh program:
```text
responsi/
├── responsi.pde         # File kode utama Processing
└── data/
    └── palm.xml         # File model Haar Cascade untuk telapak tangan
```

---

## 🎮 Cara Menjalankan & Kontrol

1. Hubungkan webcam atau aktifkan kamera laptop Anda.
2. Buka berkas **`responsi.pde`** menggunakan Processing IDE.
3. Klik tombol **Run (Play)**.
4. Hadapkan telapak tangan Anda ke kamera. Sebuah lingkaran merah akan muncul melacak telapak tangan Anda.
5. Dekatkan telapak tangan Anda pada titik berkedip warna **Kuning** (mulai dari nomor 1) secara berurutan hingga nomor 9.
6. Setelah semua titik terhubung, layar keberhasilan **"BERHASIL!"** akan muncul.

### ⌨️ Tombol Kontrol
* **`R` / `r`**: Meriset ulang seluruh progres koneksi titik dan mengulang permainan dari awal.

---

## 🔍 Penjelasan Singkat Logika Kode

### 1. Mirroring Kamera dengan Push/Pop Matrix
Untuk membuat cermin pada gambar kamera tanpa membalik teks dan koordinat objek gambar lainnya di luar kamera, kita mengisolasi efek transformasinya menggunakan `pushMatrix()` dan `popMatrix()`:
```java
pushMatrix();           // Menyimpan kondisi sistem koordinat normal
scale(-1, 1);           // Membalik koordinat sumbu X
image(capt, -width, 0); // Menggambar kamera secara terbalik di area negatif
popMatrix();            // Mengembalikan koordinat ke kondisi normal semula
```

### 2. Sinkronisasi Deteksi Tangan Terhadap Cermin
Karena kamera digambar secara mirrored (cermin), hasil koordinat X deteksi tangan dari OpenCV (yang mentah/unmirrored) disinkronkan ke layar cermin dengan rumus:
```java
fingerX = width - (hands[0].x + (hands[0].width / 2));
fingerY = hands[0].y + (hands[0].height / 2);
```

### 3. Logika Tabrakan (Collision)
Menghitung jarak euclidean antara titik target aktif ke-`i` dengan titik tengah tangan `(fingerX, fingerY)`. Jika berada di dalam radius tabrakan, status titik diubah menjadi terhubung:
```java
float distance = dist(fingerX, fingerY, dots[i].x, dots[i].y);
if (distance <= 12.5 + fingerRad) {
  connected[i] = true;
  nextDotIndex++;
}
```
