<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\User;
use App\Notifications\GeneralNotification;
use Illuminate\Support\Facades\Http;

class SendDailyNotifications extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'notif:harian';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Kirim notifikasi harian (cuaca dan berita) ke semua user';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Memulai pengiriman notifikasi harian...');
        
        // 1. Ambil Data Cuaca Karawang
        $weatherMsg = $this->getWeatherMessage();
        
        // 2. Ambil Data Berita Pertanian
        $newsMsg = $this->getNewsMessage();
        
        $users = User::all();
        $count = 0;

        foreach ($users as $user) {
            $settings = is_string($user->notification_settings) 
                ? json_decode($user->notification_settings, true) 
                : $user->notification_settings;
                
            if (!is_array($settings)) {
                $settings = [];
            }
                
            $pauseAll = $settings['pause_all'] ?? false;
            
            if ($pauseAll) {
                // Jangan kirim notif jika user menjeda semua notifikasi
                continue;
            }

            $wantsNews = $settings['news'] ?? true;
            $wantsWeather = $settings['weather'] ?? true;
            
            // Kirim notif cuaca
            if ($wantsWeather && $weatherMsg) {
                $user->notify(new GeneralNotification(
                    'Prakiraan Cuaca Hari Ini',
                    $weatherMsg,
                    'weather'
                ));
            }
            
            // Kirim notif berita
            if ($wantsNews && $newsMsg) {
                $user->notify(new GeneralNotification(
                    'Berita Pertanian',
                    $newsMsg,
                    'news'
                ));
            }
            
            $count++;
        }

        $this->info("Berhasil mengirim notifikasi ke {$count} user.");
    }
    
    private function getWeatherMessage()
    {
        try {
            $city = 'Karawang';
            $apiKey = env('OPENWEATHER_API_KEY', 'bd5e378503939ddaee76f12ad7a97608');
            $url = "https://api.openweathermap.org/data/2.5/weather?q=" . urlencode($city) . "&appid={$apiKey}&units=metric&lang=id";
            
            $response = Http::timeout(10)->get($url);
            
            if ($response->successful()) {
                $data = $response->json();
                $temp = round($data['main']['temp'] ?? 0);
                $desc = ucwords($data['weather'][0]['description'] ?? '');
                
                return "Cuaca di {$city} hari ini diperkirakan {$desc} dengan suhu {$temp}°C.";
            }
        } catch (\Exception $e) {
            $this->error('Gagal mengambil cuaca: ' . $e->getMessage());
        }
        
        return null;
    }
    
    private function getNewsMessage()
    {
        try {
            $source = 'https://news.google.com/rss/search?q=pertanian+karawang&hl=id&gl=ID&ceid=ID:id';
            $xml = @file_get_contents($source);
            if ($xml) {
                $rss = @simplexml_load_string($xml);
                if ($rss && $rss->channel && $rss->channel->item) {
                    // Ambil berita pertama
                    $item = $rss->channel->item[0];
                    $title = (string) $item->title;
                    
                    // Bersihkan judul dari nama sumber (biasanya ada di akhir judul setelah dash)
                    $titleArr = explode(' - ', $title);
                    if(count($titleArr) > 1) {
                        array_pop($titleArr);
                        $title = implode(' - ', $titleArr);
                    }
                    
                    return $title;
                }
            }
        } catch (\Exception $e) {
            $this->error('Gagal mengambil berita: ' . $e->getMessage());
        }
        
        return null;
    }
}
