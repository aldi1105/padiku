<?php
require 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$user = App\Models\User::where('email', 'aldimuhamadriskiriski9954@gmail.com')->first();
if (!$user) {
    echo "User not found\n";
    exit;
}

if (!$user->fcm_token) {
    echo "FCM token is NULL for this user\n";
    exit;
}

echo "Found token: " . $user->fcm_token . "\n";
echo "Sending notification...\n";

try {
    $user->notify(new App\Notifications\GeneralNotification('Test dari Server!', 'Jika Anda melihat ini, Push Notification sudah 100% BEKERJA!', 'system'));
    echo "SUCCESS\n";
} catch (\Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
}
