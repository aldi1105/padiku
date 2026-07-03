<!DOCTYPE html>
<html>
<head>
    <title>Kode Verifikasi (OTP)</title>
</head>
<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <h2>Halo!</h2>
    <p>Anda menerima email ini karena ada permintaan untuk mengubah {{ $type == 'email' ? 'alamat email' : 'nomor telepon' }} pada akun Anda.</p>
    <p>Berikut adalah kode verifikasi (OTP) keamanan Anda:</p>
    <div style="font-size: 24px; font-weight: bold; letter-spacing: 5px; color: #15682A; margin: 20px 0;">
        {{ $otp }}
    </div>
    <p>Kode ini berlaku selama 10 menit. <strong>Jangan berikan kode ini kepada siapapun!</strong></p>
    <p>Jika Anda tidak merasa melakukan permintaan ini, abaikan email ini dan segera ubah kata sandi Anda.</p>
    <br>
    <p>Terima kasih,<br>Tim Padiku</p>
</body>
</html>
