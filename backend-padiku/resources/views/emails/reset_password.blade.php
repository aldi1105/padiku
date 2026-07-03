<!DOCTYPE html>
<html>
<head>
    <title>Atur Ulang Kata Sandi</title>
</head>
<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <h2>Halo!</h2>
    <p>Anda menerima email ini karena kami menerima permintaan untuk mengatur ulang kata sandi pada akun Anda.</p>
    <p>Silakan gunakan token berikut untuk mereset kata sandi Anda di aplikasi:</p>
    <div style="font-size: 24px; font-weight: bold; letter-spacing: 2px; color: #15682A; margin: 20px 0; font-family: monospace;">
        {{ $token }}
    </div>
    <p>Token ini berlaku selama 60 menit. Jika Anda tidak merasa melakukan permintaan ini, abaikan email ini.</p>
    <br>
    <p>Terima kasih,<br>Tim Padiku</p>
</body>
</html>
