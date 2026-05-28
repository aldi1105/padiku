<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

use App\Http\Controllers\Auth\LoginController;

Route::get('/', function () {
    return view('welcome');
})->name('login');

Route::post('/login', [LoginController::class, 'authenticate']);
Route::get('/logout', [LoginController::class, 'logout'])->name('logout');

Route::middleware('auth')->prefix('admin')->group(function () {
    Route::get('/dashboard', function () {
        $totalPetani = \App\Models\User::where('email', '!=', 'admin@padiku.com')->count();
        $totalProduk = \App\Models\Product::count();
        $pesananBaru = \App\Models\Order::where('status', 'pending')->count();
        $totalScan = \App\Models\Disease::sum('scan_count');

        $recentOrders = \App\Models\Order::with('user')->orderBy('created_at', 'desc')->take(3)->get();
        $popularGuides = \App\Models\Guide::orderBy('views', 'desc')->take(3)->get();

        return view('admin.dashboard', compact(
            'totalPetani', 'totalProduk', 'pesananBaru', 'totalScan', 'recentOrders', 'popularGuides'
        ));
    });

    Route::get('/users', function () {
        $users = \App\Models\User::where('email', '!=', 'admin@padiku.com')->orderBy('created_at', 'desc')->paginate(10);
        return view('admin.users.index', compact('users'));
    });

    Route::post('/users/{id}/approve', function ($id) {
        $user = \App\Models\User::findOrFail($id);
        $user->update(['status' => 'approved']);
        return back()->with('success', 'Akun ' . $user->name . ' berhasil disetujui!');
    })->name('admin.users.approve');

    Route::delete('/users/{id}', function ($id) {
        $user = \App\Models\User::findOrFail($id);
        
        // Proteksi: jangan sampai admin menghapus dirinya sendiri
        if ($user->email === 'admin@padiku.com') {
            return back()->with('error', 'Tidak dapat menghapus akun admin utama.');
        }
        
        $name = $user->name;
        $user->delete();
        return back()->with('success', 'Akun ' . $name . ' berhasil dihapus!');
    })->name('admin.users.destroy');

    Route::get('/products', function () {
        $products = \App\Models\Product::paginate(10);
        return view('admin.products.index', compact('products'));
    });

    Route::get('/orders', function () {
        $orders = \App\Models\Order::with('user')->orderBy('created_at', 'desc')->paginate(10);
        return view('admin.orders.index', compact('orders'));
    });

    Route::get('/guides', function () {
        $guides = \App\Models\Guide::orderBy('created_at', 'desc')->paginate(10);
        return view('admin.guides.index', compact('guides'));
    })->name('admin.guides.index');

    Route::put('/guides/{id}', function (\Illuminate\Http\Request $request, $id) {
        $guide = \App\Models\Guide::findOrFail($id);
        
        $data = [
            'title' => $request->title,
            'content' => $request->content,
        ];

        // Jika ada image (opsional, untuk kedepannya)
        if ($request->hasFile('image')) {
            // handle image upload
            // $path = $request->file('image')->store('guides', 'public');
            // $data['image'] = '/storage/' . $path;
        }

        $guide->update($data);
        return back()->with('success', 'Panduan berhasil diperbarui!');
    })->name('admin.guides.update');

    Route::get('/news', function () {
        $sources = [
            'https://news.google.com/rss/search?q=pertanian+karawang&hl=id&gl=ID&ceid=ID:id', // Karawang
            'https://www.cnnindonesia.com/ekonomi/rss', // CNN Nasional
            'https://www.antaranews.com/rss/ekonomi.xml', // Antara
            'https://www.cnbcindonesia.com/news/rss', // CNBC
            'https://ekbis.sindonews.com/rss' // Sindonews
        ];
        $keywords = ['padi', 'beras', 'gabah', 'sawah', 'petani', 'panen', 'pupuk', 'bulog', 'pertanian', 'pangan', 'kementan', 'karawang'];
        $items = [];
        
        foreach ($sources as $source) {
            $xml = @file_get_contents($source);
            if ($xml) {
                $rss = @simplexml_load_string($xml);
                if ($rss && $rss->channel && $rss->channel->item) {
                    foreach($rss->channel->item as $item) {
                        $title = strtolower((string) $item->title);
                        $desc = strtolower((string) $item->description);
                        
                        // Cek apakah mengandung kata kunci
                        $isMatch = false;
                        foreach($keywords as $kw) {
                            if (strpos($title, $kw) !== false || strpos($desc, $kw) !== false) {
                                $isMatch = true;
                                break;
                            }
                        }

                        if (!$isMatch) continue;

                        $imageUrl = '';
                        if (isset($item->enclosure) && isset($item->enclosure['url'])) {
                            $imageUrl = (string) $item->enclosure['url'];
                        } else if (preg_match('/<img[^>]+src=["\']([^"\']+)["\']/', (string) $item->description, $matches)) {
                            $imageUrl = $matches[1];
                        } else if (preg_match('/<img[^>]+src=["\']([^"\']+)["\']/', (string) $item->content, $matches)) {
                            $imageUrl = $matches[1];
                        }

                        $sourceName = 'Berita Nasional';
                        if (strpos($source, 'google.com') !== false) {
                            $sourceName = 'Berita Karawang';
                        } else {
                            $host = parse_url($source, PHP_URL_HOST);
                            $sourceName = ucwords(str_replace(['www.', '.com', '.co.id', '.net.id'], '', $host));
                        }
                        
                        $items[] = (object)[
                            'title' => (string) $item->title,
                            'description' => strip_tags((string) $item->description),
                            'link' => (string) $item->link,
                            'pubDate' => date('d M Y H:i', strtotime((string) $item->pubDate)),
                            'image' => $imageUrl,
                            'timestamp' => strtotime((string) $item->pubDate),
                            'source' => $sourceName
                        ];
                    }
                }
            }
        }
        
        // Urutkan berita berdasarkan waktu (terbaru di atas)
        usort($items, function($a, $b) {
            return $b->timestamp - $a->timestamp;
        });

        // Ambil maksimal 20 berita
        $items = array_slice($items, 0, 20);
        
        return view('admin.news.index', ['news' => $items]);
    })->name('admin.news.index');

    Route::resource('diseases', \App\Http\Controllers\DiseaseController::class);
    Route::resource('rice-varieties', \App\Http\Controllers\RiceVarietyController::class);

    Route::get('/map', function () {
        return view('admin.map.index');
    });

    Route::get('/map/data', function () {
        $users = \App\Models\User::whereNotNull('latitude')
            ->whereNotNull('longitude')
            ->where('status', 'approved')
            ->where('updated_at', '>=', now()->subHours(24))
            ->where('email', '!=', 'admin@padiku.com')
            ->get();
        return response()->json($users);
    });
});
