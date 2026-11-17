import '../models/issue_model.dart';

final List<IssueModel> initialIssuesData = [
  const IssueModel(
    idIssue: 'PENY-01',
    kategori: 'Penyakit',
    namaMasalah: 'Virus Gemini (Penyakit Kuning / Bulai)',
    namaLatin: 'Pepper yellow leaf curl virus (PepYLCV)',
    bagianTerdampak: 'Daun',
    gejala:
        'Daun muda mengeriting dan cekung ke atas, tulang daun menebal berwarna kuning kehijauan cerah. Pertumbuhan tanaman terhambat (kerdil), buku batang memendek, dan pembentukan bunga serta buah berkurang drastis bahkan gagal berbuah.',
    solusi:
        '1. Cabut dan musnahkan tanaman yang terinfeksi parah (eradikasi) dengan dibakar atau dikubur.\n2. Kendalikan serangga vektor (Kutu Kebul) sejak fase persemaian menggunakan insektisida berbahan aktif Imidakloprid atau Abamektin.\n3. Pasang perangkap kuning berperekat (yellow sticky trap) 40 unit/hektar di sekitar lahan.',
    pencegahan:
        'Gunakan bibit tahan virus (toleran), aplikasikan mulsa plastik perak untuk memantulkan sinar dan mengusir kutu kebul, rotasi tanaman bukan famili solanaceae (terong, tomat), dan jaga kebersihan gulma di sekitar bedengan.',
    tingkatBahaya: 'Tinggi',
    isPopular: true,
    iconSymbol: '🍂',
  ),
  const IssueModel(
    idIssue: 'PENY-02',
    kategori: 'Penyakit',
    namaMasalah: 'Antraknosa (Patek Cabai)',
    namaLatin: 'Colletotrichum capsici / gloeosporioides',
    bagianTerdampak: 'Buah',
    gejala:
        'Muncul bercak hitam melingkar konsentris melekuk (lesi cekung) pada permukaan buah cabai, baik buah hijau maupun matang. Pada kondisi lembap, terdapat spora jamur berwarna merah muda oranye di bagian tengah bercak. Buah cepat membusuk, layu, mengerut, dan rontok sebelum panen.',
    solusi:
        '1. Petik seluruh buah yang bergejala patek dan musnahkan jauh dari kebun (jangan ditinggal di pematang).\n2. Semprotkan fungisida kontak berbahan aktif Mankozeb, Klorotalonil, atau fungisida sistemik Difenokonazol/Azoksistrobin sesuai dosis anjuran sore hari.\n3. Semprotkan PGPR (Plant Growth Promoting Rhizobacteria) untuk meningkatkan ketahanan alami tanaman.',
    pencegahan:
        'Perlebar jarak tanam (minimal 60x70 cm) agar sirkulasi udara baik, hindari pemupukan Nitrogen berlebih saat musim hujan, gunakan bedengan tinggi (30-40 cm) dengan drainase lancar, dan bersihkan alat pangkas dengan alkohol.',
    tingkatBahaya: 'Tinggi',
    isPopular: true,
    iconSymbol: '🌶️',
  ),
  const IssueModel(
    idIssue: 'PENY-03',
    kategori: 'Penyakit',
    namaMasalah: 'Layu Bakteri Cabai',
    namaLatin: 'Ralstonia solanacearum',
    bagianTerdampak: 'Batang',
    gejala:
        'Tanaman layu mendadak di siang hari saat terik matahari dan tampak segar kembali di malam/pagi hari, namun beberapa hari kemudian mati permanen dengan daun tetap hijau (layu hijau). Jika batang bawah dipotong dan dimasukkan ke air jernih, keluar lendir bakteri (bacterial ooze) seperti asap putih kental.',
    solusi:
        '1. Cabut tanaman yang layu beserta tanah perakarannya, lalu taburi lubang tanam dengan kapur pertanian (dolomit) dan bakterisida.\n2. Kocor tanaman sekitarnya dengan bakterisida tembaga hidroksida atau antibiotik pertanian (Streptomisin sulfat).\n3. Kurangi pengairan agar tanah tidak tergenang.',
    pencegahan:
        'Gunakan varietas tahan, perlakukan benih dengan air hangat (50°C) selama 15 menit, campurkan Trichoderma sp. atau Pseudomonas fluorescens pada lubang tanam sejak awal, dan hindari perlukaan akar saat penyiangan.',
    tingkatBahaya: 'Tinggi',
    isPopular: true,
    iconSymbol: '🥀',
  ),
  const IssueModel(
    idIssue: 'PENY-04',
    kategori: 'Penyakit',
    namaMasalah: 'Layu Fusarium',
    namaLatin: 'Fusarium oxysporum f. sp. capsici',
    bagianTerdampak: 'Akar',
    gejala:
        'Daun bagian bawah menguning perlahan merambat ke atas, tulang daun memucat. Tanaman layu lambat tidak sekaligus seperti layu bakteri. Batang bagian dalam jika dibelah memperlihatkan jaringan pembuluh (xilem) berwarna cokelat tua kehitaman. Akar tanaman membusuk kecokelatan.',
    solusi:
        '1. Bongkar tanaman yang sakit dan bakar.\n2. Aplikasi agens hayati Trichoderma harzianum atau Gliocladium sp. secara berkala pada tanah di sekitar tanaman sehat.\n3. Kocor fungisida sistemik berbahan aktif Karbendazim atau Benomil pada tanaman sekitar pusat serangan.',
    pencegahan:
        'Naikkan pH tanah ke 6.0 - 6.8 dengan kapur dolomit (jamur Fusarium menyukai tanah masam), gunakan pupuk kandang yang telah terfermentasi matang sempurna, dan hindari genangan air.',
    tingkatBahaya: 'Tinggi',
    isPopular: false,
    iconSymbol: '🌱',
  ),
  const IssueModel(
    idIssue: 'PENY-05',
    kategori: 'Penyakit',
    namaMasalah: 'Bercak Daun Cercospora (Mata Katak)',
    namaLatin: 'Cercospora capsici',
    bagianTerdampak: 'Daun',
    gejala:
        'Bercak bulat kecil pada daun dengan pusat berwarna abu-abu/putih pucat dan tepi berbatas tegas cokelat tua kemerahan (menyerupai mata katak). Pada serangan parah, daun menguning di sekitar bercak lalu mengering dan rontok massal (defoliasi), menyebabkan buah terbakar sinar matahari.',
    solusi:
        '1. Pangkas daun tua yang terinfeksi di bagian bawah tanaman.\n2. Semprotkan fungisida kontak bahan aktif Mankozeb atau Propineb bergantian dengan Difenokonazol setiap 5-7 hari sekali pada musim hujan.\n3. Tambahkan perekat perata non-ionik agar semprotan tahan guyuran hujan.',
    pencegahan:
        'Sanitasi sisa tanaman pascapanen, atur jarak tanam ideal, hindari penyiraman dengan menyiram langsung dari atas tajuk daun (siram di pangkal batang).',
    tingkatBahaya: 'Sedang',
    isPopular: false,
    iconSymbol: '🍃',
  ),
  const IssueModel(
    idIssue: 'PENY-06',
    kategori: 'Penyakit',
    namaMasalah: 'Busuk Buah & Batang Phytophthora',
    namaLatin: 'Phytophthora capsici',
    bagianTerdampak: 'Buah',
    gejala:
        'Bercak basah kebasah-basahan berwarna hijau gelap kecokelatan pada buah atau pangkal batang. Buah melunak lembek seperti tersiram air mendidih dan tertutup lapisan miselium putih tipis. Pada batang menyebabkan busuk basah cincin hitam hingga tanaman patah dan layu cepat.',
    solusi:
        '1. Buang buah dan bagian batang yang terinfeksi.\n2. Semprotkan fungisida sistemik Metalaksil, Dimetomorf, atau Fosetil-Aluminium.\n3. Perbaiki saluran drainase agar tidak ada genangan air hujan di lorong bedengan.',
    pencegahan:
        'Rotasi tanaman dengan padi atau jagung, jangan menggunakan sumber air irigasi yang terkontaminasi dari lahan sakit di atasnya, serta gunakan mulsa plastik perak.',
    tingkatBahaya: 'Tinggi',
    isPopular: true,
    iconSymbol: '🌧️',
  ),
  const IssueModel(
    idIssue: 'PENY-07',
    kategori: 'Penyakit',
    namaMasalah: 'Rebah Semai (Damping-Off)',
    namaLatin: 'Pythium sp. / Rhizoctonia solani',
    bagianTerdampak: 'Batang',
    gejala:
        'Menyerang benih pada persemaian. Batang bibit cabai di batas permukaan tanah melunak, mengecil, dan membusuk kecokelatan, sehingga bibit rebah, layu, dan mati serempak seperti tersapu air.',
    solusi:
        '1. Kurangi penyiraman persemaian, buka sungkup plastik di pagi hari agar persemaian mendapat sinar matahari dan sirkulasi udara cukup.\n2. Semprot atau siram media semai dengan Propamokarb hidroklorida atau fungisida Tembaga.',
    pencegahan:
        'Sterilisasi media semai (kukus atau jemur tanah), campur media dengan Trichoderma sp., dan jangan menyemai benih terlalu rapat.',
    tingkatBahaya: 'Sedang',
    isPopular: false,
    iconSymbol: '🪴',
  ),
  const IssueModel(
    idIssue: 'HAMA-01',
    kategori: 'Hama',
    namaMasalah: 'Kutu Daun & Thrips Cabai',
    namaLatin: 'Thrips parvispinus',
    bagianTerdampak: 'Daun',
    gejala:
        'Daun cabai mengeriting dan melengkung ke atas (seperti mangkuk terbalik), permukaan bawah daun mengilap seperti dilapisi perak karena bekas hisapan hama. Pucuk daun kaku kecokelatan, bunga rontok, dan buah berparut kusam.',
    solusi:
        '1. Semprot dengan insektisida/akarisida berbahan aktif Abamektin, Spinotoram, atau Tiametoksam bergantian secara rotasi bahan aktif.\n2. Gunakan pestisida nabati rebusan daun mimba atau ekstrak tembakau dan sabun cuci piring (sebagai perata pelarut lilin serangga).\n3. Pasang perangkap biru/kuning berperekat.',
    pencegahan:
        'Jaga kelembapan dengan mulsa, lakukan tumpangsari dengan tanaman jagung sebagai tanaman perangkap pembatas barrier di batas kebun.',
    tingkatBahaya: 'Tinggi',
    isPopular: true,
    iconSymbol: '🦗',
  ),
  const IssueModel(
    idIssue: 'HAMA-02',
    kategori: 'Hama',
    namaMasalah: 'Lalat Buah Cabai',
    namaLatin: 'Bactrocera dorsalis / carambolae',
    bagianTerdampak: 'Buah',
    gejala:
        'Terdapat titik hitam kecil (lubang oviposisi tempat lalat bertelur) pada kulit buah cabai. Di dalam buah terdapat belatung (larva) yang memakan daging buah dan biji, menyebabkan buah busuk dari dalam, menguning sebelum waktunya, lalu rontok ke tanah.',
    solusi:
        '1. Kumpulkan semua buah cabai yang gugur dan busuk, masukkan ke kantong plastik rapat atau kubur sedalam 50 cm agar larva tidak menjadi pupa di tanah.\n2. Pasang perangkap atraktan metil eugenol (Petrogenol) di dalam botol bekas di luar bedengan untuk menarik lalat jantan.\n3. Umpan semprotan protein beracun di dedaunan pematang.',
    pencegahan:
        'Pasang selubung jaring serangga jika memungkinkan, panen buah cabai sedikit lebih awal ketika warna buah mulai semburat merah, dan bersihkan gulma semak di sekitar kebun.',
    tingkatBahaya: 'Tinggi',
    isPopular: true,
    iconSymbol: '🪰',
  ),
  const IssueModel(
    idIssue: 'HAMA-03',
    kategori: 'Hama',
    namaMasalah: 'Tungau Kuning & Merah',
    namaLatin: 'Polyphagotarsonemus latus / Tetranychus sp.',
    bagianTerdampak: 'Daun',
    gejala:
        'Daun mengeriting dan melengkung ke bawah (seperti sendok telungkup), daun menebal, kaku, dan permukaan bawah daun berwarna kecokelatan mengilap seperti tembaga (bronzing). Tunas pucuk berhenti tumbuh dan gugur.',
    solusi:
        '1. Semprot akarisida khusus berbahan aktif Piridaben, Abamektin, atau Heksitiazoks di permukaan bawah daun tempat tungau berkoloni.\n2. Semprotkan belerang (Sulfur cair) dengan konsentrasi sesuai anjuran saat cuaca cerah (bukan terik siang hari).\n3. Aplikasikan Beauveria bassiana sebagai jamur entomopatogen alami.',
    pencegahan:
        'Pantau kebun pada musim kemarau panjang (tungau berkembang biak sangat cepat pada suhu panas dan kering), hindari penggunaan insektisida piretroid sintetis secara berlebihan yang mematikan musuh alami tungau.',
    tingkatBahaya: 'Sedang',
    isPopular: false,
    iconSymbol: '🕷️',
  ),
  const IssueModel(
    idIssue: 'HAMA-04',
    kategori: 'Hama',
    namaMasalah: 'Kutu Kebul (Kutu Putih Vektor Virus)',
    namaLatin: 'Bemisia tabaci',
    bagianTerdampak: 'Daun',
    gejala:
        'Serangga kecil bersayap putih berterbangan seperti debu halus saat tanaman digoyang. Menghisap cairan daun sehingga daun klorosis, mengeluarkan cairan embun jelaga yang membuat daun menghitam jamuran. Hama ini merupakan vektor utama penular Virus Gemini.',
    solusi:
        '1. Semprot insektisida translaminar berbahan aktif Asetamiprid, Dinotefuran, atau Imidakloprid bergantian.\n2. Semprotkan insektisida nabati minyak mimba (neem oil) yang mengacaukan siklus makan kutu kebul.\n3. Pasang yellow sticky trap (perangkap kuning) setinggi tajuk tanaman.',
    pencegahan:
        'Bersihkan tanaman inang liar seperti babadotan dan ceplukan, gunakan mulsa plastik perak hitam, dan pasang paranet penahan serangga di persemaian bibit.',
    tingkatBahaya: 'Tinggi',
    isPopular: true,
    iconSymbol: '🦟',
  ),
  const IssueModel(
    idIssue: 'HAMA-05',
    kategori: 'Hama',
    namaMasalah: 'Ulat Grayak & Ulat Buah',
    namaLatin: 'Spodoptera litura / Helicoverpa armigera',
    bagianTerdampak: 'Daun',
    gejala:
        'Daun berlubang-lubang tidak beraturan hingga tinggal menyisakan tulang daun (daun transparan/berkerangka). Pada buah, tampak lubang gerek bulat dan kotoran ulat di sekitarnya. Ulat sering bersembunyi di bawah mulsa atau pangkal tanaman pada siang hari dan aktif makan di malam hari.',
    solusi:
        '1. Lakukan pemungutan kelompok telur dan ulat secara mekanis di pagi hari saat masih tampak di daun.\n2. Semprot insektisida hayati Bacillus thuringiensis (Bt) atau Beauveria bassiana.\n3. Gunakan insektisida berbahan aktif Emamektin benzoat atau Klorantraniliprol pada senja hari saat ulat mulai aktif keluar.',
    pencegahan:
        'Pasang perangkap feromon seksual untuk memantau populasi ngengat jantan, lakukan pengolahan tanah sempurna untuk mematikan pupa ulat di dalam tanah.',
    tingkatBahaya: 'Sedang',
    isPopular: false,
    iconSymbol: '🐛',
  ),
];
