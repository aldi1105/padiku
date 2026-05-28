<?php

require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$diseases = [
    'Wereng Coklat' => [
        'danger_level' => 'Tinggi',
        'life_cycle' => '21-30 hari',
        'spread_rate' => 'Sangat Cepat (Angin & Migrasi)',
        'main_characteristics' => 'Serangga kecil berwarna coklat, menghisap cairan batang padi, menyebabkan hopperburn.',
        'maintenance_advice' => 'Gunakan varietas tahan, atur jarak tanam, hindari penggunaan pestisida berspektrum luas secara berlebihan.'
    ],
    'Penggerek Batang' => [
        'danger_level' => 'Tinggi',
        'life_cycle' => '30-45 hari',
        'spread_rate' => 'Cepat (Melalui Ngengat)',
        'main_characteristics' => 'Ulat yang menggerek ke dalam batang padi, menyebabkan sundep (fase vegetatif) dan beluk (fase generatif).',
        'maintenance_advice' => 'Pengumpulan kelompok telur, pemanfaatan musuh alami, penyemprotan insektisida sistemik jika ambang batas terlampaui.'
    ],
    'Hawar Daun Bakteri' => [
        'danger_level' => 'Sedang',
        'life_cycle' => '10-20 hari',
        'spread_rate' => 'Cepat (Air & Angin)',
        'main_characteristics' => 'Bercak kuning keabu-abuan pada tepi daun yang meluas, sering terjadi pada musim hujan.',
        'maintenance_advice' => 'Gunakan benih sehat, pemupukan berimbang (kurangi Urea), jarak tanam jajar legowo, sanitasi lingkungan.'
    ],
    'Tungro' => [
        'danger_level' => 'Tinggi',
        'life_cycle' => 'Virus ditularkan wereng hijau',
        'spread_rate' => 'Sangat Cepat (Vektor Serangga)',
        'main_characteristics' => 'Tanaman kerdil, daun berwarna kuning oranye mulai dari pucuk ke bawah.',
        'maintenance_advice' => 'Kendalikan vektor (wereng hijau), tanam serempak, cabut dan musnahkan tanaman yang terinfeksi.'
    ]
];

foreach(\App\Models\Disease::all() as $disease) {
    foreach($diseases as $name => $data) {
        if(strpos(strtolower($disease->name), strtolower($name)) !== false) {
            $disease->update($data);
            break;
        }
    }
}
echo "Data berhasil diupdate.\n";
