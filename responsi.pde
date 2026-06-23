import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

Capture capt;
OpenCV cv;

// Koordinat titik-titik pembentuk angka 2
PVector[] dots = {
  new PVector(250, 150),
  new PVector(320, 110),
  new PVector(390, 110),
  new PVector(430, 160),
  new PVector(380, 230),
  new PVector(310, 310),
  new PVector(250, 380),
  new PVector(250, 420),
  new PVector(430, 420)
};

boolean[] connected = new boolean[9];
int nextDotIndex = 0;
boolean isFinished = false;

// Cascade default diganti ke palm.xml karena deteksinya jauh lebih stabil
//String activeCascade = ;

void setup() {
  size(640, 480);
  
  capt = new Capture(this, 640, 480);
  capt.start();
  
  cv = new OpenCV(this, 640, 480);
  cv.loadCascade("palm.xml");
  
  // Inisialisasi status koneksi titik
  for (int i = 0; i < connected.length; i++) {
    connected[i] = false;
  }
}

void draw() {
  if (capt.available()) {
    capt.read();
  }
  
  // 1. Tampilkan feed kamera secara MIRROR (Cermin) agar pergerakan tangan alami
  pushMatrix();
  scale(-1, 1);
  image(capt, -width, 0);
  popMatrix();
  
  // 2. Deteksi tangan/telapak tangan
  cv.loadImage(capt);
  Rectangle[] hands = cv.detect();
  
  float fingerX = -1;
  float fingerY = -1;
  float fingerRad = 0;
  
  if (hands.length > 0) {
    // Ambil tangan pertama yang terdeteksi dan MIRROR koordinat X-nya
    fingerX = width - (hands[0].x + (hands[0].width / 2));
    fingerY = hands[0].y + (hands[0].height / 2);
    fingerRad = hands[0].height / 4; // Jari-jari tabrakan jari/tangan
    
    // Gambar lingkaran penanda merah transparan di pusat tangan
    fill(#FF0D0D, 150);
    noStroke();
    ellipse(fingerX, fingerY, fingerRad * 2, fingerRad * 2);
    
    // Gambar kotak merah sekeliling tangan (di-mirror)
    stroke(#FF0D0D);
    noFill();
    rect(width - hands[0].x - hands[0].width, hands[0].y, hands[0].width, hands[0].height);
  }
  
  // 3. Gambar garis-garis pembentuk angka 2
  stroke(#00AF79);
  strokeWeight(5);
  for (int i = 0; i < nextDotIndex - 1; i++) {
    line(dots[i].x, dots[i].y, dots[i+1].x, dots[i+1].y);
  }
  
  // Gambar garis pemandu yang sedang ditarik oleh jari ke titik berikutnya
  if (nextDotIndex > 0 && nextDotIndex < dots.length && hands.length > 0) {
    stroke(#FFC107);
    line(dots[nextDotIndex - 1].x, dots[nextDotIndex - 1].y, fingerX, fingerY);
  }
  
  // 4. Gambar titik-titik target
  for (int i = 0; i < dots.length; i++) {
    noStroke();
    if (connected[i]) {
      fill(#00AF79); // Hijau = sudah terhubung
    } else if (i == nextDotIndex) {
      fill(#FFC107); // Kuning = titik aktif saat ini
    } else {
      fill(255);     // Putih = titik terkunci
    }
    
    ellipse(dots[i].x, dots[i].y, 25, 25);
    
    // Angka penanda urutan titik
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(i + 1, dots[i].x, dots[i].y);
    
    // 5. Deteksi sentuhan tangan/jari ke titik aktif
    if (hands.length > 0 && i == nextDotIndex) {
      float distance = dist(fingerX, fingerY, dots[i].x, dots[i].y);
      
      // Jika jarak pusat tangan ke titik kurang dari jumlah radius keduanya
      if (distance <= 12.5 + fingerRad) {
        connected[i] = true;
        nextDotIndex++;
        
        if (nextDotIndex >= dots.length) {
          isFinished = true;
        }
      }
    }
  }
  
  // Tampilan Sukses
  if (isFinished) {
    fill(0, 180);
    rect(0, 0, width, height);
    
    fill(#00AF79);
    textSize(36);
    textAlign(CENTER, CENTER);
    text("BERHASIL!", width / 2, height / 2);
    
    textSize(16);
    fill(255);
    text("Tekan tombol 'R' untuk mengulang", width / 2, height / 2 + 50);
  }
}

// Kontrol keyboard
void keyPressed() {
  if (key == 'r' || key == 'R') {
    nextDotIndex = 0;
    isFinished = false;
    for (int i = 0; i < connected.length; i++) {
      connected[i] = false;
    }
}
