<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$user = \App\Models\User::find(6);
echo json_encode($user->toArray());
if ($user->profile_picture) {
    echo "\nHas picture: " . $user->profile_picture;
} else {
    echo "\nNo picture";
}
