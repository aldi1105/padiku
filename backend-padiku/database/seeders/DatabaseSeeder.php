<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Product;
use App\Models\Order;
use App\Models\Guide;
use App\Models\Disease;
use App\Models\News;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Create dummy users
        $admin = User::create([
            'name' => 'Admin Padiku',
            'email' => 'admin@padiku.com',
            'password' => Hash::make('password123'),
        ]);

        $petani1 = User::create([
            'name' => 'Budi Santoso',
            'email' => 'budi@gmail.com',
            'password' => Hash::make('password'),
        ]);

        $petani2 = User::create([
            'name' => 'Ahmad Petani',
            'email' => 'ahmad@gmail.com',
            'password' => Hash::make('password'),
        ]);

        $petani3 = User::create([
            'name' => 'Siti Aminah',
            'email' => 'siti@gmail.com',
            'password' => Hash::make('password'),
        ]);

        // 2. Create products
        Product::create([
            'name' => 'Pupuk Urea 50kg',
            'description' => 'Pupuk Urea berkualitas tinggi untuk tanaman padi, mempercepat pertumbuhan dan menghijaukan daun.',
            'price' => 120000,
            'stock' => 50,
            'image' => 'https://via.placeholder.com/150',
        ]);

        Product::create([
            'name' => 'Benih Padi Ciherang 5kg',
            'description' => 'Benih padi varietas Ciherang yang tahan wereng dan hasil panen melimpah.',
            'price' => 85000,
            'stock' => 100,
            'image' => 'https://via.placeholder.com/150',
        ]);
        
        Product::create([
            'name' => 'Pestisida Pembasmi Wereng 500ml',
            'description' => 'Ampuh membasmi hama wereng coklat dan hijau dalam 24 jam.',
            'price' => 45000,
            'stock' => 30,
            'image' => 'https://via.placeholder.com/150',
        ]);

        // 3. Create orders
        Order::create([
            'user_id' => $petani1->id,
            'order_number' => 'ORD-092',
            'total_amount' => 450000,
            'status' => 'processing',
        ]);

        Order::create([
            'user_id' => $petani2->id,
            'order_number' => 'ORD-091',
            'total_amount' => 120000,
            'status' => 'shipped',
        ]);

        Order::create([
            'user_id' => $petani3->id,
            'order_number' => 'ORD-090',
            'total_amount' => 85000,
            'status' => 'shipped',
        ]);

        // 4. Create guides
        Guide::create([
            'title' => 'Cara Mengatasi Hama Wereng Secara Alami',
            'content' => 'Gunakan daun sirsak dan tembakau untuk mencegah wereng...',
            'views' => 2431,
            'image' => 'https://via.placeholder.com/60',
        ]);

        Guide::create([
            'title' => 'Pemupukan Padi yang Benar di Musim Hujan',
            'content' => 'Pada musim hujan, pemupukan harus dikurangi kadar nitrogennya...',
            'views' => 1890,
            'image' => 'https://via.placeholder.com/60',
        ]);

        // 5. Create diseases
        Disease::create([
            'name' => 'Penyakit Tungro',
            'description' => 'Disebabkan oleh virus yang dibawa wereng hijau, daun menguning.',
            'solution' => 'Gunakan varietas tahan virus, semprot wereng hijau.',
            'scan_count' => 1250,
        ]);

        Disease::create([
            'name' => 'Hawar Daun Bakteri (Kresek)',
            'description' => 'Pinggir daun mengering dan berwarna keabu-abuan.',
            'solution' => 'Kurangi pupuk urea, pastikan jarak tanam tidak terlalu rapat.',
            'scan_count' => 850,
        ]);

    }
}
