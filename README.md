# AR Number 2 Tracer (Minimal & Mirrored Edition) 🚀

Aplikasi AR minimalis ini mendeteksi pergerakan tangan/kepalan Anda menggunakan OpenCV untuk menyentuh dan menghubungkan titik-titik pembentuk angka **2** dengan layar kamera yang telah di-mirror.

---

## 📸 Fitur Cermin (Mirror) & Cascade Stabil

1. **Mirroring Kamera**:
   - Tampilan kamera kini di-mirror secara horizontal (`scale(-1, 1)`) agar seperti cermin. Pergerakan tangan Anda ke kanan akan ikut menggerakkan kursor ke kanan di layar.
   - Posisi deteksi tangan (`fingerX`) dan kotak pembatas merah juga otomatis di-mirror agar pas dengan gambar kamera.

2. **Pergantian Model Cascade**:
   - Model default diganti dari `hand.xml` menjadi **`palm.xml`** (telapak tangan terbuka) karena memiliki deteksi yang jauh lebih stabil dan responsif.
   - Anda juga dapat menggantinya ke **`fist.xml`** (kepalan tangan) secara langsung dari keyboard saat program sedang berjalan.

---

## ⌨️ Kontrol Keyboard

* **`P` atau `p`**: Menggunakan model deteksi telapak tangan terbuka (**`palm.xml`**).
* **`F` atau `f`**: Menggunakan model deteksi kepalan tangan tertutup (**`fist.xml`**).
* **`R` atau `r`**: Meriset ulang progres dari titik awal.

---

## 📂 Berkas Utama

* **[responsi.pde](file:///C:/Users/azzam/OneDrive/Documents/Processing/responsi/responsi.pde)**: Kode program cermin minimalis.
* **`data/palm.xml`**: Berkas cascade telapak tangan.
* **`data/fist.xml`**: Berkas cascade kepalan tangan (juga disalin otomatis).
