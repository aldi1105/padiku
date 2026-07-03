<!DOCTYPE html>
<html>
<head>
    <title>Kode OTP Pemulihan Kata Sandi</title>
</head>
<body style="font-family: Arial, sans-serif; color: #333; line-height: 1.6;">
    <div style="max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
        <h2 style="color: #15682A; text-align: center;">Pemulihan Kata Sandi Padiku</h2>
        <p>Halo,</p>
        <p>Anda menerima email ini karena ada permintaan untuk mengatur ulang kata sandi akun Padiku Anda. Berikut adalah kode OTP Anda:</p>
        
        <div style="text-align: center; margin: 30px 0;">
            <span style="display: inline-block; padding: 15px 30px; font-size: 24px; font-weight: bold; background-color: #E8F5E9; color: #15682A; border-radius: 4px; letter-spacing: 5px;">
                {{ $otp }}
            </span>
        </div>

        <p>Kode ini hanya berlaku selama <strong>10 menit</strong>. Jangan berikan kode ini kepada siapapun termasuk pihak Padiku demi keamanan akun Anda.</p>
        <p>Jika Anda tidak merasa melakukan permintaan ini, Anda dapat mengabaikan email ini.</p>

        <hr style="border: 0; border-top: 1px solid #eee; margin: 30px 0;">
        <p style="font-size: 12px; color: #888; text-align: center;">
            &copy; {{ date('Y') }} Padiku. Hak cipta dilindungi.
        </p>
    </div>
</body>
</html>
