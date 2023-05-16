# 🌱 AUTOMATED GREENHOUSE 🌱

## LATAR BELAKANG 
Greenhouse atau rumah kaca merupakan solusi yang sangat populer dan efektif dalam pertanian modern. Dengan menggunakan greenhouse, pertumbuhan tanaman dapat dikendalikan secara optimal sepanjang tahun. Salah satu faktor yang berperan penting dalam pertumbuhan tanaman di dalam greenhouse adalah temperatur. Tanaman memerlukan kondisi suhu yang tepat agar dapat tumbuh dengan baik dan mencapai potensi pertumbuhan yang maksimal. Jika temperatur di dalam greenhouse terlalu rendah atau terlalu tinggi, hal ini dapat menghambat aktivitas enzim serta mempengaruhi proses metabolik tanaman. Akibatnya, pertumbuhan dan perkembangan tanaman dapat terganggu. Oleh karena itu, pengendalian temperatur dengan seksama dalam greenhouse menjadi hal yang sangat penting.

Pada greenhouse tradisional, pengendalian temperatur seringkali menjadi tantangan yang harus dihadapi. Faktor-faktor lingkungan eksternal seperti suhu udara, paparan sinar matahari, tingkat kelembaban, dan kecepatan angin dapat secara langsung mempengaruhi suhu di dalam greenhouse. Selain itu, fluktuasi temperatur yang signifikan sering terjadi antara siang dan malam hari, serta antara musim panas dan musim dingin. Ketidakstabilan suhu yang tidak terkendali ini dapat mengganggu pertumbuhan tanaman dan menghasilkan hasil panen yang kurang optimal.

Oleh karena itu, upaya pengendalian temperatur yang hati-hati dan teliti sangatlah penting dalam mengelola greenhouse. Petani harus menggunakan berbagai metode dan teknologi untuk mengatur suhu di dalam greenhouse, seperti penggunaan sistem ventilasi, penggunaan pengatur suhu otomatis, penutup yang dapat mengisolasi panas, dan penggunaan perangkat pendingin. Dengan mengoptimalkan pengendalian temperatur di dalam greenhouse, petani dapat menciptakan lingkungan yang stabil dan ideal bagi pertumbuhan tanaman, sehingga dapat meningkatkan hasil panen dengan kualitas yang baik.

## SOLUSI 
Dalam upaya mengatasi tantangan pengendalian temperatur di dalam rumah kaca, kelompok kami telah mengembangkan solusi yang dikenal sebagai Automated Greenhouse. Sistem ini menggunakan teknologi sensor dan pengendalian otomatis untuk menjaga suhu yang ideal di dalam rumah kaca. Automated Greenhouse bekerja dengan memanfaatkan sensor temperatur yang terus-menerus memantau suhu di dalam rumah kaca secara real-time. Data suhu yang terkumpul kemudian dibandingkan dengan suhu yang telah ditentukan sebelumnya sebagai suhu yang diinginkan.

Ketika suhu di dalam rumah kaca melebihi batas yang diinginkan, Automated Greenhouse akan mengambil tindakan dengan mengaktifkan kipas untuk mengurangi suhu di dalam ruangan. Sebaliknya, jika suhu terlalu rendah, alat ini akan memberikan peringatan melalui lampu indikator untuk mengingatkan petani atau pengelola rumah kaca bahwa suhu sudah terlalu rendah. Dalam situasi seperti itu, petani dapat mengambil tindakan pemanasan yang sesuai, seperti mengaktifkan sistem pemanas yang ada atau menambahkan pemanas tambahan di dalam rumah kaca. Dengan adanya Automated Greenhouse, petani atau pengelola rumah kaca dapat lebih mudah dan efektif mengontrol suhu di dalam rumah kaca, menciptakan lingkungan yang optimal untuk pertumbuhan tanaman, dan meningkatkan hasil panen secara keseluruhan.

## FITUR-FITUR DAN HARDWARE DESIGN

### 1.) TEMPERATURE READER DHT11
![](https://hackmd.io/_uploads/HyYpGTer2.png)
Automated greenhouse berfungsi untuk menyesuaikan suhu di dalam green house sehingga sesuai dengan yang kita inginkan. Pertama-tama, alat ini akan membaca suhu sekitar menggunakan sensor dht11. Dht11 merupakan sensor yang bisa membaca temperatur dari 0 hingga 50 derajat celcius, dan kelembapan dari 20 hingga 90%. Untuk alat ini, kami hanya menggunakan data temperature. Data tersebut kemudian akan diubah menjadi decimal agar bisa di display pada LCD MAX7219. 
 
### 2.) Servo SG90 
![](https://hackmd.io/_uploads/ByN5RCgHh.png)
Ketika temperature sekitar lebih tinggi daripada temperature yang kita tentukan, maka servo sg90 yang ada akan menyala. Servo pada alat ini berperan sebagai kipas yang berfungsi untuk mendinginkan suhu agar suhu sekitar bisa turun kembali sesuai dengan yang diinginkan. 

### 3.) LED
![](https://hackmd.io/_uploads/HyaXQaxBh.png)
Ketika temperature sekitar lebih rendah daripada temperature yang kita tentukan, maka LED yang ada akan menyala. LED pada alat ini berperan sebagai pengingat yang berfungsi untuk memperingatkan pengguna bahwa suhu sekitar terlalu rendah. 

### 4.) BUZZER 
![](https://hackmd.io/_uploads/SJvwQaxHn.png)
Ketika temperature sekitar jauh lebih tinggi daripada temperature yang kita tentukan (pada alat ini yaitu diatas 40 derajat celcius), maka buzzer yang ada akan menyala. Buzzer berperan sebagai pengingat bahwa suhu sudah terlalu tinggi. 

### 5.) ARDUINO UNO R3
![](https://hackmd.io/_uploads/HyynNmWSh.png)
Arduino Uno R3 digunakan sebagai microcontroller yang akan mengeksekusi program yang dibuat dalam bahasa assembly. Arduino akan menentukan PORT mana saja yang akan digunakan dan dapat dijadikan output untuk menandakan program telah berjalan sesuai rencana.

### 6.) RESISTOR
![](https://hackmd.io/_uploads/ByY4BQ-Bh.png)
Resistor digunakan untuk memberi hambatan yang langsung dihubungkan dengan LED. Dengan memberikan resistor maka dapat mengurangi masalah keelektrikan yang dimana arus yang diberikan untuk LED dapat lebih kecil dibanding arus aslinya.

### 7.) MAX7219
![](https://hackmd.io/_uploads/Sk80rQbr2.png)
Module MAX7219 merupakan gabungan antara 8 matrix seven segment display dengan IC MAX7219 yang digunakan untuk memberikan output dalam bentuk LED. Nilai suhu dan kelembaban akan ditampilkan pada layar MAX7219 tersebut.

## TEST RESULT 
Berdasarkan hasil test yang dilakukan, alat yang telah kami buat telah memenuhi kriteria yang kami inginkan, yaitu menyalakan servo ketika suhu diatas 30 derajat, menyalakan buzzer ketika suhu diatas 40 derajat, dan menyalakan LED ketika suhu dibawah 20 derajat. Rangkaian yang kami buat dapat dilihat pada gambar berikut : 

Selain itu, kami juga membuat Automated Greenhouse pada proteus untuk mensimulasikan suhu-suhu yang rendah dan tinggi untuk mengetes cara kerja alatnya. Berikut hasil dari percobaan yang kami lakukan pada proteus : 
### Suhu < 20 Derajat: 
![](https://hackmd.io/_uploads/SygIJJbHh.png)
Ketika suhu berada dibawah 20 derajat celcius, maka LED akan menyala yang menandakan bahwa pemanas atau heater akan aktif. 

### Suhu 20 - 30 derajat :
![](https://hackmd.io/_uploads/rkxdUyybSn.png)
Ketika suhu berada diantara 20 hingga 30 derajat celcius, maka akan berada di kondisi IDLE atau suhu ideal ruangan. Sehingga tidak terdapat komponen yang aktif.

### Suhu > 30 - 40 derajat:
![](https://hackmd.io/_uploads/rkrD1JWr2.png) 
Ketika suhu berada diantara 30 hingga 40 derajat celcius, maka menandakan suhu ruangan yang cukup panas sehingga akan menyalakan kipas yang ditandakan oleh servo yang menyala.

### Suhu > 40 derajat : 
![](https://hackmd.io/_uploads/B1l_yyZB2.png)
Ketika suhu berada diatas 40 derajat celcius, maka sensor akan mendeteksi suhu ruangan yang tidak normal. Dengan mengasumsikan suhu yang sangat panas atau terjadi kebakaran, maka buzzer akan menyala untuk menandakan SOS untuk gedung tersebut.

## EVALUATION PERFORMANCE 
Evaluasi terhadap performa peralatan proyek menunjukkan bahwa pekerjaan yang dilakukan sesuai dengan kriteria dan harapan yang telah ditetapkan. Namun, terdapat beberapa kendala yang perlu diperhatikan. Salah satunya adalah Sensor DHT11 yang tidak selalu memberikan pembacaan data suhu yang akurat. Hal ini dapat menimbulkan kesalahpahaman jika dibandingkan dengan kondisi suhu yang sebenarnya. Meskipun demikian, Sensor DHT11 tetap memiliki nilai sebagai contoh simulasi untuk memonitor suhu dalam proyek ini.

Selain itu, penggunaan Servo juga menunjukkan beberapa keterbatasan. Pergerakan Servo yang terbatas menjadikannya kurang ideal untuk menggerakkan kipas dengan efisiensi. Disarankan untuk menggunakan Servo bersama dengan alat lain agar dapat mencapai tujuan pengendalian yang lebih efektif. Meski demikian, penggunaan Servo dalam proyek ini masih memberikan manfaat sebagai bukti nyata simulasi penggerak kipas dalam situasi tertentu.

## CONCLUSION
Automated Greenhouse yang telah kami buat memenuhi kriteria dan harapan yang kami tetapkan. Alat ini berhasil memberikan bantuan dalam menjaga stabilitas suhu di dalam rumah kaca. Dengan menggunakan sensor yang dapat membaca suhu secara real-time, data temperatur dan kelembaban ditampilkan melalui layar MAX7219. Selain itu, servo digunakan untuk menggerakkan kipas saat suhu mencapai di atas 30 derajat Celsius. Jika suhu melebihi 40 derajat Celsius, buzzer akan memberikan peringatan, dan jika suhu turun di bawah 20 derajat Celsius, LED penghangat akan menyala. Kami berharap kesuksesan alat ini dapat diimplementasikan dalam skala yang lebih besar dengan peralatan yang lebih sesuai, sehingga dapat membantu menjaga suhu secara efektif dalam rumah kaca sesungguhnya.

Kesimpulan dari pengembangan Automated Greenhouse ini adalah bahwa alat tersebut telah memberikan hasil yang sesuai dengan harapan kami. Dengan kemampuannya dalam mengontrol suhu dan memberikan indikator serta peringatan yang tepat, alat ini dapat menjadi solusi yang efektif untuk menjaga suhu di dalam rumah kaca. Kami berharap agar alat ini dapat diadopsi dan diimplementasikan dalam dunia nyata dengan peralatan yang lebih besar dan lebih sesuai, sehingga dapat memberikan kontribusi nyata dalam menjaga stabilitas suhu di dalam rumah kaca.

## FUTURE WORK
Berikut adalah beberapa poin per poin untuk pengembangan masa depan proyek Automated Greenhouse:

### 1. Fitur Penyiraman Air Otomatis:
   - Menambahkan mekanisme penyiraman air secara otomatis ketika suhu mencapai ambang batas tertentu.
   - Pengaktifan penyiraman air dapat diprogram berdasarkan interval waktu yang telah ditentukan.
   - Tujuannya adalah menjaga kelembaban tanaman dan memberikan kondisi optimal bagi pertumbuhan.

### 2. Integrasi Sistem Monitoring dan Kendali Jarak Jauh (IoT):
   - Mengintegrasikan teknologi yang memungkinkan pemantauan dan kendali jarak jauh terhadap Automated Greenhouse.
   - Pengguna dapat memantau suhu, kelembaban, dan fungsi-fungsi lain melalui perangkat mobile atau komputer.
   - Kemampuan ini memberikan fleksibilitas dan kemudahan dalam pengoperasian serta pemantauan, terutama jika pemilik tidak berada di dekat rumah kaca secara fisik.

### 3. Penerapan Sistem Pencahayaan Otomatis:
   - Menyertakan sistem pencahayaan otomatis yang mengatur intensitas cahaya di dalam rumah kaca.
   - Sensor cahaya akan mendeteksi tingkat pencahayaan dan menyesuaikan pengaturan pencahayaan secara otomatis.
   - Hal ini membantu tanaman mendapatkan jumlah cahaya yang diperlukan untuk fotosintesis yang optimal.

### 4. Integrasi Data dan Analisis:
   - Mengumpulkan data suhu, kelembaban, penyiraman, dan pencahayaan untuk analisis lebih lanjut.
   - Menerapkan teknik analisis data untuk memperoleh wawasan tentang pola pertumbuhan tanaman dan meningkatkan efisiensi pengelolaan rumah kaca.
   - Data ini dapat digunakan untuk pengambilan keputusan yang lebih baik dalam hal pengendalian lingkungan dan perawatan tanaman.

Pengembangan proyek Automated Greenhouse dengan fitur-fitur tambahan ini akan meningkatkan kemampuan pengendalian dan pemeliharaan lingkungan dalam rumah kaca. Hal ini dapat membantu petani atau pengelola rumah kaca untuk mencapai hasil panen yang lebih baik dan efisien.

## CONTRIBUTORS
Alat ini dibuat oleh Kelompok B2 SSF 02: 
- [Handaneswari Pramudhyta Imanda](https://github.com/handaneswari) (2106731346)
- [Luthfi Misbachul Munir](https://github.com/Luthfii1) (2106631961)
- [Prima Shalih](https://github.com/Prima-Shalih) (2106636862)
- [Zefanya Christira Deardo](https://github.com/Zechrs) (2106637214)
