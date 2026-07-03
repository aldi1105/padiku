<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Notifications\GeneralNotification;

// --- PUBLIC ROUTES ---
Route::post('/register', function (Request $request) {
    $validator = Validator::make($request->all(), [
        'name' => 'required|string|max:255',
        'email' => 'required|string|email|max:255|unique:users',
        'phone' => 'required|string|max:20|unique:users',
        'password' => 'required|string|min:8',
    ], [
        'email.unique' => 'Email ini sudah terdaftar.',
        'phone.unique' => 'Nomor HP ini sudah terdaftar.',
        'password.min' => 'Kata sandi minimal 8 karakter.',
    ]);

    if ($validator->fails()) {
        return response()->json([
            'success' => false,
            'message' => $validator->errors()->first()
        ], 422);
    }

    $user = User::create([
        'name' => trim(strip_tags($request->name)),
        'email' => strtolower(trim($request->email)),
        'phone' => trim(strip_tags($request->phone)),
        'password' => Hash::make($request->password),
        'status' => 'pending' // Default menunggu verifikasi
    ]);

    return response()->json([
        'success' => true,
        'message' => 'Registrasi berhasil. Silakan tunggu verifikasi admin (sekitar 5 menit).',
        'data' => $user
    ]);
});

// Actual News API endpoint
Route::get('/news', function (Request $request) {
    if ($request->query('refresh') == '1') {
        Illuminate\Support\Facades\Cache::forget('news_cache');
    }
    
    return Illuminate\Support\Facades\Cache::remember('news_cache', 600, function () { // Cache selama 10 menit
        try {
            $sources = [
                'https://news.google.com/rss/search?q=pertanian+karawang&hl=id&gl=ID&ceid=ID:id', // Karawang
                'https://www.cnnindonesia.com/ekonomi/rss', // CNN Nasional
                'https://www.antaranews.com/rss/ekonomi.xml', // Antara
                'https://www.cnbcindonesia.com/news/rss', // CNBC
                'https://ekbis.sindonews.com/rss' // Sindonews
            ];
            $keywords = ['padi', 'beras', 'gabah', 'sawah', 'petani', 'panen', 'pupuk', 'bulog', 'pertanian', 'pangan', 'kementan', 'karawang'];
            $items = [];
            
            // Ambil semua sumber RSS secara paralel (asinkron) dengan timeout 3 detik
            $responses = Illuminate\Support\Facades\Http::pool(function (Illuminate\Http\Client\Pool $pool) use ($sources) {
                return array_map(function ($source) use ($pool) {
                    return $pool->timeout(3)->connectTimeout(3)->get($source);
                }, $sources);
            });
            
            foreach ($responses as $index => $response) {
                if ($response->successful()) {
                    $xml = $response->body();
                    $rss = @simplexml_load_string($xml);
                    if ($rss && $rss->channel && $rss->channel->item) {
                        $source = $sources[$index];
                        foreach($rss->channel->item as $item) {
                            $timestamp = strtotime((string) $item->pubDate);
                            $title = strtolower((string) $item->title);
                            $desc = strtolower((string) $item->description);
                            
                            // Cek apakah mengandung kata kunci pertanian atau karawang
                            $isMatch = false;
                            foreach($keywords as $kw) {
                                if (strpos($title, $kw) !== false || strpos($desc, $kw) !== false) {
                                    $isMatch = true;
                                    break;
                                }
                            }

                            if (!$isMatch) continue;

                            // Batasi berita 30 hari terakhir
                            if (time() - $timestamp > 30 * 86400) {
                                continue;
                            }

                            $diff = time() - $timestamp;
                            if ($diff < 3600) {
                                $pubDateStr = "Baru saja";
                            } elseif ($diff < 86400) {
                                $pubDateStr = floor($diff / 3600) . " jam lalu";
                            } elseif ($diff < 172800) {
                                $pubDateStr = "Kemarin";
                            } else {
                                $pubDateStr = floor($diff / 86400) . " hari lalu";
                            }

                            $imageUrl = 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800&q=80';
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

                            $items[] = [
                                'title' => (string) $item->title,
                                'description' => trim(html_entity_decode(strip_tags((string) $item->description))),
                                'link' => (string) $item->link,
                                'pubDate' => $pubDateStr,
                                'image' => $imageUrl,
                                'source' => $sourceName,
                                'timestamp' => $timestamp
                            ];
                        }
                    }
                }
            }

            // Urutkan berita berdasarkan waktu (terbaru di atas)
            usort($items, function($a, $b) {
                return $b['timestamp'] - $a['timestamp'];
            });

            // Ambil maksimal 20 berita
            $items = array_slice($items, 0, 20);

            return response()->json([
                'success' => true,
                'data' => $items
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil berita: ' . $e->getMessage()
            ], 500);
        }
    });
});
// Rice varieties endpoint
Route::get('/rice-varieties', [\App\Http\Controllers\RiceVarietyController::class, 'apiIndex']);
Route::get('/diseases', [\App\Http\Controllers\DiseaseController::class, 'apiIndex']);

// Cek Status Verifikasi (Real-time polling)
Route::get('/check-status/{email}', function ($email) {
    $user = User::where('email', strtolower(trim($email)))->first();
    
    if (!$user) {
        return response()->json(['success' => false, 'message' => 'User not found'], 404);
    }

    return response()->json([
        'success' => true,
        'status' => $user->status
    ]);
});

// Tambahkan throttle untuk mencegah brute-force attack (5 percobaan / 1 menit)
Route::middleware('throttle:5,1')->post('/login', function (Request $request) {
    $validator = Validator::make($request->all(), [
        'email' => 'required|email',
        'password' => 'required',
    ]);

    if ($validator->fails()) {
        return response()->json([
            'success' => false,
            'message' => 'Format email atau kata sandi tidak valid.'
        ], 422);
    }

    $user = User::where('email', $request->email)->first();

    if (! $user || ! Hash::check($request->password, $user->password)) {
        return response()->json([
            'success' => false,
            'message' => 'Email atau kata sandi salah.'
        ], 401);
    }

    if ($user->status !== 'approved') {
        return response()->json([
            'success' => false,
            'message' => 'Akun Anda sedang dalam proses verifikasi oleh admin (estimasi 5 menit). Harap tunggu.'
        ], 403);
    }

    $token = $user->createToken('mobile-app')->plainTextToken;

    $userData = $user->toArray();
    if ($user->profile_picture) {
        $userData['profile_picture_url'] = $request->getSchemeAndHttpHost() . '/storage/profiles/' . $user->profile_picture;
    }

    return response()->json([
        'success' => true,
        'message' => 'Login berhasil',
        'data' => $userData,
        'token' => $token
    ]);
});

// Endpoint Cuaca dari OpenWeatherMap
Route::get('/weather', function (Request $request) {
    $city = $request->query('city', 'Karawang');
    $lat = $request->query('lat');
    $lon = $request->query('lon');
    
    $cacheKey = 'weather_' . ($lat && $lon ? "{$lat}_{$lon}" : md5($city));
    
    if ($request->query('refresh') == '1') {
        Illuminate\Support\Facades\Cache::forget($cacheKey);
    }
    
    return Illuminate\Support\Facades\Cache::remember($cacheKey, 600, function () use ($city, $lat, $lon) { // Cache 10 menit
        $apiKey = env('OPENWEATHER_API_KEY', 'bd5e378503939ddaee76f12ad7a97608'); // Menggunakan placeholder key OWM. Sebaiknya ganti dengan key asli di .env
        
        if (empty($apiKey)) {
            return response()->json([
                'success' => false,
                'message' => 'API Key OpenWeatherMap belum dikonfigurasi di .env (OPENWEATHER_API_KEY)'
            ], 500);
        }

        try {
            if ($lat && $lon) {
                $url = "https://api.openweathermap.org/data/2.5/weather?lat={$lat}&lon={$lon}&appid={$apiKey}&units=metric&lang=id";
            } else {
                $url = "https://api.openweathermap.org/data/2.5/weather?q=" . urlencode($city) . "&appid={$apiKey}&units=metric&lang=id";
            }
            
            $response = Illuminate\Support\Facades\Http::timeout(5)->get($url);
            
            if (!$response->successful()) {
                 return response()->json([
                    'success' => false,
                    'message' => 'Gagal menghubungi OpenWeatherMap. Periksa API Key atau nama kota.'
                ], 500);
            }

            $data = $response->json();
            
            return response()->json([
                'success' => true,
                'data' => [
                    'city' => $data['name'] ?? $city,
                    'temperature' => round($data['main']['temp'] ?? 0),
                    'description' => ucwords($data['weather'][0]['description'] ?? ''),
                    'icon' => $data['weather'][0]['icon'] ?? '01d',
                    'humidity' => $data['main']['humidity'] ?? 0,
                    'wind_speed' => $data['wind']['speed'] ?? 0,
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data cuaca.'
            ], 500);
        }
    });
});

// Endpoint untuk melakukan web scraping isi penuh (full content) artikel
Route::post('/news-content', function (Request $request) {
    $url = $request->input('url');
    if (!$url) return response()->json(['success' => false, 'message' => 'URL is required'], 400);

    return Illuminate\Support\Facades\Cache::remember('news_content_' . md5($url), 86400, function () use ($url) { // Cache 1 hari
        try {
            $response = Illuminate\Support\Facades\Http::timeout(8)->get($url);
            if (!$response->successful()) throw new \Exception('Failed to load HTML');
            $html = $response->body();

            $dom = new \DOMDocument();
            @$dom->loadHTML($html);
            $xpath = new \DOMXPath($dom);

            // Daftar XPath selector yang biasa dipakai situs berita untuk meletakkan isi berita utama
            $selectors = [
                '//div[contains(@class, "detail-text")]//p', // CNN, CNBC
                '//div[contains(@class, "post-content")]//p', // Antara
                '//article//p',
                '//div[contains(@class, "content")]//p',
            ];

            $paragraphs = [];
            foreach ($selectors as $selector) {
                $nodes = $xpath->query($selector);
                if ($nodes && $nodes->length > 0) {
                    foreach ($nodes as $node) {
                        $text = trim($node->textContent);
                        // Filter teks sampah atau teks terlalu pendek
                        if (strlen($text) > 50 && !str_contains(strtolower($text), 'baca juga')) {
                            $paragraphs[] = $text;
                        }
                    }
                    if (count($paragraphs) > 0) {
                        break; // Stop jika sudah ketemu isi beritanya
                    }
                }
            }

            if (count($paragraphs) == 0) {
                return response()->json(['success' => false, 'message' => 'Tidak bisa mengekstrak isi artikel']);
            }

            return response()->json([
                'success' => true,
                'content' => implode("\n\n", $paragraphs)
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    });
});

// Endpoint Forecast 5 Hari dari OpenWeatherMap
Route::get('/weather-forecast', function (Request $request) {
    $city = $request->query('city', 'Karawang');
    $lat = $request->query('lat');
    $lon = $request->query('lon');
    
    $cacheKey = 'weather_forecast_' . ($lat && $lon ? "{$lat}_{$lon}" : md5($city));
    
    if ($request->query('refresh') == '1') {
        Illuminate\Support\Facades\Cache::forget($cacheKey);
    }
    
    return Illuminate\Support\Facades\Cache::remember($cacheKey, 600, function () use ($city, $lat, $lon) {
        $apiKey = env('OPENWEATHER_API_KEY', 'bd5e378503939ddaee76f12ad7a97608');
        
        if (empty($apiKey)) {
            return response()->json(['success' => false, 'message' => 'API Key OpenWeatherMap belum dikonfigurasi'], 500);
        }

        try {
            if ($lat && $lon) {
                $url = "https://api.openweathermap.org/data/2.5/forecast?lat={$lat}&lon={$lon}&appid={$apiKey}&units=metric&lang=id";
            } else {
                $url = "https://api.openweathermap.org/data/2.5/forecast?q=" . urlencode($city) . "&appid={$apiKey}&units=metric&lang=id";
            }
            $response = Illuminate\Support\Facades\Http::timeout(5)->get($url);
            
            if (!$response->successful()) {
                 return response()->json(['success' => false, 'message' => 'Gagal menghubungi OpenWeatherMap.'], 500);
            }

            $data = $response->json();
            $dailyForecast = [];
            $addedDates = [];

            foreach ($data['list'] as $item) {
                // Konversi waktu UTC ke WIB (+7)
                $timestamp = $item['dt'] + (7 * 3600);
                $dateStr = gmdate('Y-m-d', $timestamp);
                $hour = (int) gmdate('H', $timestamp);
                
                // Ambil data sekitar siang hari (jam 12-15) sebagai perwakilan cuaca hari itu
                if (!in_array($dateStr, $addedDates) && $hour >= 12 && $hour <= 15) {
                    $addedDates[] = $dateStr;
                    $dailyForecast[] = [
                        'date' => $dateStr,
                        'day_name' => '', // Akan di-format di Flutter
                        'temperature' => round($item['main']['temp']),
                        'description' => ucwords($item['weather'][0]['description']),
                        'icon' => $item['weather'][0]['icon'],
                    ];
                }
            }

            $hourlyForecast = [];
            foreach (array_slice($data['list'], 0, 5) as $item) {
                $timestamp = $item['dt'] + (7 * 3600);
                $hourlyForecast[] = [
                    'time' => gmdate('H:00', $timestamp),
                    'temperature' => round($item['main']['temp']),
                    'icon' => $item['weather'][0]['icon'],
                ];
            }

            return response()->json([
                'success' => true,
                'data' => [
                    'daily' => $dailyForecast,
                    'hourly' => $hourlyForecast
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => 'Gagal mengambil data forecast.'], 500);
        }
    });
});

// Data publik yang bisa diakses tanpa login
Route::get('/products', function () {
    $products = \App\Models\Product::all();
    return response()->json([
        'success' => true,
        'data' => $products
    ]);
});

Route::get('/diseases', function () {
    $diseases = \App\Models\Disease::all();
    return response()->json([
        'success' => true,
        'message' => 'Data penyakit berhasil diambil',
        'data' => $diseases
    ]);
});

// --- PROTECTED ROUTES --- (Harus menyertakan Bearer Token)
Route::middleware('auth:sanctum')->group(function () {
    
    Route::get('/user', function (Request $request) {
        $user = clone $request->user();
        $userData = $user->toArray();
        if ($user->profile_picture) {
            $userData['profile_picture_url'] = $request->getSchemeAndHttpHost() . '/storage/profiles/' . $user->profile_picture;
        }
        return response()->json([
            'success' => true,
            'data' => $userData
        ]);
    });

    Route::post('/user/update', function (Request $request) {
        $user = $request->user();
        
        $validator = Validator::make($request->all(), [
            'name' => 'nullable|string|max:255',
            'location' => 'nullable|string|max:255',
            'latitude' => 'nullable|string',
            'longitude' => 'nullable|string',
            'bio' => 'nullable|string',
            'email' => 'nullable|string|email|max:255|unique:users,email,' . $user->id,
            'phone' => 'nullable|string|max:20|unique:users,phone,' . $user->id,
            'profile_picture' => 'nullable|image|max:2048' // max 2MB
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'message' => $validator->errors()->first()], 422);
        }

        if ($request->exists('email') || $request->exists('phone')) {
            $isVerified = \Illuminate\Support\Facades\Cache::get('verified_' . $user->id);
            if (!$isVerified) {
                $isChangingExistingEmail = $request->exists('email') && !empty($user->email) && $user->email !== strtolower(trim($request->input('email')));
                $isChangingExistingPhone = $request->exists('phone') && !empty($user->phone) && $user->phone !== trim(strip_tags($request->input('phone')));
                
                if ($isChangingExistingEmail || $isChangingExistingPhone) {
                    return response()->json([
                        'success' => false, 
                        'message' => 'Anda harus melakukan verifikasi OTP terlebih dahulu sebelum mengubah kontak.'
                    ], 403);
                }
            } else {
                \Illuminate\Support\Facades\Cache::forget('verified_' . $user->id);
            }
        }

        if ($request->hasFile('profile_picture')) {
            $file = $request->file('profile_picture');
            $filename = time() . '_' . $user->id . '.' . $file->getClientOriginalExtension();
            $file->storeAs('public/profiles', $filename);
            
            // Delete old picture if exists
            if ($user->profile_picture) {
                Illuminate\Support\Facades\Storage::delete('public/profiles/' . $user->profile_picture);
            }
            
            $user->profile_picture = $filename;
        }

        $updateData = [];
        if ($request->exists('name')) $updateData['name'] = $request->input('name');
        if ($request->exists('location')) $updateData['location'] = $request->input('location');
        if ($request->exists('latitude')) $updateData['latitude'] = $request->input('latitude');
        if ($request->exists('longitude')) $updateData['longitude'] = $request->input('longitude');
        if ($request->exists('bio')) $updateData['bio'] = $request->input('bio');
        if ($request->exists('email')) $updateData['email'] = strtolower(trim($request->input('email')));
        if ($request->exists('phone')) $updateData['phone'] = trim(strip_tags($request->input('phone')));
        
        if (!empty($updateData)) {
            $user->update($updateData);
        }

        $user->save();

        $settings = is_string($user->notification_settings) ? json_decode($user->notification_settings, true) : $user->notification_settings;
        if (!is_array($settings)) $settings = [];
        if (!empty($updateData) && !($settings['pause_all'] ?? false) && ($settings['system'] ?? true)) {
            $user->notify(new GeneralNotification('Sistem', 'Data profil Anda berhasil diperbarui.', 'system'));
        }

        $userData = $user->toArray();
        if ($user->profile_picture) {
            $userData['profile_picture_url'] = $request->getSchemeAndHttpHost() . '/storage/profiles/' . $user->profile_picture;
        }

        return response()->json([
            'success' => true,
            'message' => 'Profil berhasil diperbarui',
            'data' => $userData
        ]);
    });

    Route::post('/user/change-password', function (Request $request) {
        $validator = Validator::make($request->all(), [
            'old_password' => 'required',
            'new_password' => 'required|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first()
            ], 422);
        }

        $user = clone $request->user();

        if (!Hash::check($request->old_password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Password lama yang Anda masukkan salah.'
            ], 400);
        }

        $user->password = Hash::make($request->new_password);
        $user->save();

        $settings = is_string($user->notification_settings) ? json_decode($user->notification_settings, true) : $user->notification_settings;
        if (!is_array($settings)) $settings = [];
        if (!($settings['pause_all'] ?? false) && ($settings['system'] ?? true)) {
            $user->notify(new GeneralNotification('Keamanan Akun', 'Kata sandi Anda baru saja diubah. Jika ini bukan Anda, segera hubungi admin.', 'system'));
        }

        return response()->json([
            'success' => true,
            'message' => 'Password berhasil diubah!'
        ]);
    });

    Route::post('/user/notification-settings', function (Request $request) {
        $user = clone $request->user();
        
        $validator = Validator::make($request->all(), [
            'notification_settings' => 'required|array',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first()
            ], 422);
        }

        $user->notification_settings = $request->notification_settings;
        $user->save();

        return response()->json([
            'success' => true,
            'message' => 'Pengaturan notifikasi berhasil disimpan',
            'data' => $user->notification_settings
        ]);
    });

    Route::get('/user/notifications', function (Request $request) {
        $notifications = $request->user()->notifications;
        
        $formatted = $notifications->map(function ($notif) {
            $diff = $notif->created_at->diff(now());
            if ($diff->d > 0) {
                $time = $diff->d . 'd';
            } elseif ($diff->h > 0) {
                $time = $diff->h . 'h';
            } elseif ($diff->i > 0) {
                $time = $diff->i . 'm';
            } else {
                $time = 'now';
            }

            return [
                'id' => $notif->id,
                'title' => $notif->data['title'] ?? '',
                'text' => $notif->data['message'] ?? '',
                'type' => $notif->data['type'] ?? 'system',
                'time' => $time,
                'isNew' => is_null($notif->read_at),
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $formatted
        ]);
    });

    Route::post('/user/notifications/{id}/read', function (Request $request, $id) {
        $notification = $request->user()->notifications()->where('id', $id)->first();
        if ($notification) {
            $notification->markAsRead();
        }
        return response()->json(['success' => true]);
    });

    Route::delete('/user/notifications/{id}', function (Request $request, $id) {
        $notification = $request->user()->notifications()->where('id', $id)->first();
        if ($notification) {
            $notification->delete();
        }
        return response()->json(['success' => true]);
    });

    Route::post('/user/request-otp', function (Request $request) {
        $request->validate([
            'type' => 'required|in:email,phone',
        ]);

        $user = $request->user();
        $target = $request->type === 'email' ? $user->email : $user->phone;

        if (empty($target)) {
            return response()->json([
                'success' => false, 
                'message' => 'Anda belum mengatur ' . $request->type . ' sebelumnya.'
            ], 400);
        }

        $otp = str_pad(rand(0, 9999), 4, '0', STR_PAD_LEFT);
        
        // Store OTP in cache for 10 minutes
        \Illuminate\Support\Facades\Cache::put('security_otp_' . $user->id, [
            'code' => $otp,
            'type' => $request->type,
        ], now()->addMinutes(10));

        if ($request->type === 'email') {
            try {
                \Illuminate\Support\Facades\Mail::to($target)->send(new \App\Mail\SecurityOtpMail($otp, $request->type));
            } catch (\Exception $e) {
                \Illuminate\Support\Facades\Log::error('Gagal mengirim email OTP: ' . $e->getMessage());
            }
        }

        return response()->json([
            'success' => true,
            'message' => 'OTP berhasil dikirim ke ' . $target
        ]);
    });

    Route::post('/user/verify-otp', function (Request $request) {
        $request->validate([
            'otp' => 'required|string',
        ]);

        $user = $request->user();
        $cachedOtp = \Illuminate\Support\Facades\Cache::get('security_otp_' . $user->id);

        if (!$cachedOtp) {
            return response()->json([
                'success' => false,
                'message' => 'Kode OTP kadaluarsa atau tidak ditemukan'
            ], 400);
        }

        if ($cachedOtp['code'] !== $request->otp) {
            return response()->json([
                'success' => false,
                'message' => 'Kode OTP salah'
            ], 400);
        }

        // Beri tanda bahwa user sudah diverifikasi (berlaku 15 menit)
        \Illuminate\Support\Facades\Cache::put('verified_' . $user->id, true, now()->addMinutes(15));
        \Illuminate\Support\Facades\Cache::forget('security_otp_' . $user->id);

        return response()->json([
            'success' => true,
            'message' => 'Verifikasi berhasil'
        ]);
    });

    Route::post('/scan-result', function (Request $request) {
        $validator = Validator::make($request->all(), [
            'disease_id' => 'required|exists:diseases,id',
            'accuracy' => 'nullable|numeric'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Data penyakit tidak ditemukan di sistem.'
            ], 422);
        }

        $disease = \App\Models\Disease::find($request->disease_id);
        $disease->increment('scan_count');

        return response()->json([
            'success' => true,
            'message' => 'Hasil scan berhasil dicatat',
            'data' => $disease
        ]);
    });
    
    // Anda bisa tambahkan fitur tambah pesanan dll di sini yang butuh ID user
});

// Endpoint untuk Request Lupa Password via OTP
Route::post('/forgot-password/request-otp', function (Request $request) {
    $validator = Validator::make($request->all(), [
        'email' => 'required|email|exists:users,email',
    ], [
        'exists' => 'Email ini tidak terdaftar di sistem.'
    ]);

    if ($validator->fails()) {
        return response()->json([
            'success' => false,
            'message' => $validator->errors()->first()
        ], 422);
    }

    $otp = str_pad(rand(0, 999999), 6, '0', STR_PAD_LEFT);
    $email = strtolower(trim($request->email));
    
    // Simpan OTP ke database
    \App\Models\Otp::updateOrCreate(
        ['identifier' => $email],
        [
            'token' => $otp,
            'expires_at' => now()->addMinutes(10)
        ]
    );

    try {
        \Illuminate\Support\Facades\Mail::to($email)->send(new \App\Mail\ForgotPasswordOtpMail($otp));
    } catch (\Exception $e) {
        \Illuminate\Support\Facades\Log::error('Gagal mengirim email OTP: ' . $e->getMessage());
        return response()->json([
            'success' => false,
            'message' => 'Gagal mengirim email, silakan coba lagi.'
        ], 500);
    }

    return response()->json([
        'success' => true,
        'message' => 'Kode OTP pemulihan telah dikirim.'
    ]);
});

Route::post('/forgot-password/verify-otp', function (Request $request) {
    $validator = Validator::make($request->all(), [
        'email' => 'required|email',
        'otp' => 'required|string|size:6',
    ]);

    if ($validator->fails()) {
        return response()->json([
            'success' => false,
            'message' => $validator->errors()->first()
        ], 422);
    }

    $email = strtolower(trim($request->email));
    
    $otpRecord = \App\Models\Otp::where('identifier', $email)
        ->where('token', $request->otp)
        ->first();

    if (!$otpRecord) {
        return response()->json([
            'success' => false,
            'message' => 'Kode OTP tidak valid.'
        ], 400);
    }

    if (now()->greaterThan($otpRecord->expires_at)) {
        return response()->json([
            'success' => false,
            'message' => 'Kode OTP telah kedaluwarsa.'
        ], 400);
    }

    // Jika valid, kita bisa mengembalikan success.
    // Frontend akan mengizinkan masuk ke layar Reset Password dengan membawa email.
    return response()->json([
        'success' => true,
        'message' => 'Kode OTP valid.'
    ]);
});

Route::post('/forgot-password/reset', function (Request $request) {
    $validator = Validator::make($request->all(), [
        'email' => 'required|email|exists:users,email',
        'password' => 'required|string|min:8|confirmed',
        'otp' => 'required|string|size:6',
    ]);

    if ($validator->fails()) {
        return response()->json([
            'success' => false,
            'message' => $validator->errors()->first()
        ], 422);
    }

    $email = strtolower(trim($request->email));

    // Verifikasi OTP sekali lagi sebelum reset
    $otpRecord = \App\Models\Otp::where('identifier', $email)
        ->where('token', $request->otp)
        ->first();

    if (!$otpRecord || now()->greaterThan($otpRecord->expires_at)) {
        return response()->json([
            'success' => false,
            'message' => 'Sesi kedaluwarsa atau OTP tidak valid. Ulangi proses.'
        ], 400);
    }

    $user = User::where('email', $email)->first();
    $user->password = Hash::make($request->password);
    $user->save();

    // Hapus OTP setelah berhasil
    $otpRecord->delete();

    return response()->json([
        'success' => true,
        'message' => 'Kata sandi berhasil diatur ulang.'
    ]);
});
