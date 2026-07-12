<?php
namespace App\Channels;

use Illuminate\Notifications\Notification;
use App\Services\FCMService;

class FCMChannel
{
    public function send($notifiable, Notification $notification)
    {
        if (empty($notifiable->fcm_token)) {
            return;
        }

        $data = method_exists($notification, 'toFCM')
                    ? $notification->toFCM($notifiable)
                    : $notification->toArray($notifiable);

        $fcm = new FCMService();
        $fcm->sendNotification(
            $notifiable->fcm_token,
            $data['title'] ?? 'Notifikasi Baru',
            $data['message'] ?? '',
            ['type' => $data['type'] ?? 'system']
        );
    }
}
