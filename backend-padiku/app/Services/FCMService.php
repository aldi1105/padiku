<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class FCMService
{
    protected $credentialsFilePath;
    protected $projectId;

    public function __construct()
    {
        $this->credentialsFilePath = storage_path('app/firebase-auth.json');
        
        // Try to get project ID from the JSON file
        if (file_exists($this->credentialsFilePath)) {
            $json = json_decode(file_get_contents($this->credentialsFilePath), true);
            $this->projectId = $json['project_id'] ?? null;
        }
    }

    protected function getAccessToken()
    {
        if (!file_exists($this->credentialsFilePath)) {
            Log::error('FCM credentials file not found at ' . $this->credentialsFilePath);
            return null;
        }

        try {
            $jsonKey = json_decode(file_get_contents($this->credentialsFilePath), true);
            $creds = new \Google\Auth\Credentials\ServiceAccountCredentials(
                'https://www.googleapis.com/auth/firebase.messaging',
                $jsonKey
            );
            
            $token = $creds->fetchAuthToken();
            return $token['access_token'] ?? null;
        } catch (\Exception $e) {
            Log::error('Failed to get FCM Access Token: ' . $e->getMessage());
            return null;
        }
    }

    public function sendNotification($deviceToken, $title, $body, $data = [])
    {
        if (!$this->projectId) {
            Log::error('FCM Project ID not found. Ensure firebase-auth.json is valid.');
            return false;
        }

        $accessToken = $this->getAccessToken();
        if (!$accessToken) {
            return false;
        }

        $url = 'https://fcm.googleapis.com/v1/projects/' . $this->projectId . '/messages:send';

        $payload = [
            'message' => [
                'token' => $deviceToken,
                'notification' => [
                    'title' => $title,
                    'body' => $body,
                ],
                'data' => array_merge([
                    'click_action' => 'FLUTTER_NOTIFICATION_CLICK',
                ], $data),
                'android' => [
                    'priority' => 'high',
                    'notification' => [
                        'channel_id' => 'high_importance_channel',
                    ],
                ]
            ],
        ];

        try {
            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $accessToken,
                'Content-Type' => 'application/json',
            ])->post($url, $payload);

            if ($response->successful()) {
                Log::info("FCM Notification sent successfully to $deviceToken");
                return true;
            } else {
                Log::error('FCM Notification failed: ' . $response->body());
                return false;
            }
        } catch (\Exception $e) {
            Log::error('FCM HTTP Request failed: ' . $e->getMessage());
            return false;
        }
    }
}
