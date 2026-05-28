<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Admin - Padiku</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        
        /* Subtle background animation */
        .bg-pattern {
            background-color: #f8fafc;
            background-image: radial-gradient(#10b981 0.5px, transparent 0.5px), radial-gradient(#10b981 0.5px, #f8fafc 0.5px);
            background-size: 20px 20px;
            background-position: 0 0, 10px 10px;
            opacity: 0.8;
        }
    </style>
</head>
<body class="bg-pattern min-h-screen flex items-center justify-center p-4">

    <!-- Container Utama -->
    <div class="max-w-4xl w-full bg-white rounded-2xl shadow-2xl overflow-hidden flex flex-col md:flex-row transform transition-all hover:scale-[1.01] duration-300">
        
        <!-- Bagian Ilustrasi/Branding (Kiri) -->
        <div class="md:w-1/2 bg-gradient-to-br from-emerald-600 to-emerald-800 p-12 text-white flex flex-col justify-between relative overflow-hidden">
            <!-- Decorative circle -->
            <div class="absolute top-0 right-0 -mr-16 -mt-16 w-64 h-64 rounded-full bg-white opacity-10"></div>
            <div class="absolute bottom-0 left-0 -ml-16 -mb-16 w-48 h-48 rounded-full bg-emerald-400 opacity-20"></div>

            <div class="relative z-10">
                <div class="flex items-center mb-8">
                    <div class="bg-white p-3 rounded-lg shadow-lg">
                        <i class="fas fa-leaf text-3xl text-emerald-600"></i>
                    </div>
                    <h1 class="text-3xl font-bold ml-4 tracking-wider">Padiku</h1>
                </div>
                <h2 class="text-4xl font-bold mb-4 leading-tight">Sistem <br>Manajemen <br>Pertanian</h2>
                <p class="text-emerald-100 mt-4 text-lg">Kelola produk, pantau pesanan, dan edukasi petani dalam satu platform cerdas.</p>
            </div>
            
            <div class="relative z-10 mt-12 md:mt-0 text-sm text-emerald-200">
                &copy; {{ date('Y') }} Padiku Admin Portal. All rights reserved.
            </div>
        </div>

        <!-- Bagian Form Login (Kanan) -->
        <div class="md:w-1/2 p-10 md:p-12 flex flex-col justify-center bg-white">
            <div class="mb-8">
                <h3 class="text-2xl font-bold text-slate-800 mb-2">Selamat Datang! 👋</h3>
                <p class="text-slate-500">Silakan masuk ke akun administrator Anda.</p>
            </div>

            <!-- Form Login -->
            <form action="/login" method="POST" class="space-y-6">
                @csrf
                
                @if($errors->any())
                    <div class="bg-red-50 text-red-600 p-4 rounded-xl text-sm mb-4 border border-red-100 flex items-center">
                        <i class="fas fa-exclamation-circle mr-2"></i>
                        {{ $errors->first() }}
                    </div>
                @endif

                <!-- Email Input -->
                <div>
                    <label for="email" class="block text-sm font-medium text-slate-700 mb-2">Email Address</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-envelope text-slate-400"></i>
                        </div>
                        <input type="email" id="email" name="email" class="block w-full pl-10 pr-3 py-3 border border-slate-200 rounded-xl text-slate-700 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition-shadow @error('email') border-red-500 @enderror" placeholder="admin@padiku.com" value="{{ old('email', 'admin@padiku.com') }}" required>
                    </div>
                </div>

                <!-- Password Input -->
                <div>
                    <div class="flex justify-between mb-2">
                        <label for="password" class="block text-sm font-medium text-slate-700">Password</label>
                        <a href="#" class="text-sm font-medium text-emerald-600 hover:text-emerald-500 transition-colors">Lupa sandi?</a>
                    </div>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-lock text-slate-400"></i>
                        </div>
                        <input type="password" id="password" name="password" class="block w-full pl-10 pr-10 py-3 border border-slate-200 rounded-xl text-slate-700 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition-shadow" placeholder="••••••••" required>
                        <div id="togglePassword" class="absolute inset-y-0 right-0 pr-3 flex items-center cursor-pointer text-slate-400 hover:text-emerald-500 transition-colors">
                            <i id="eyeIcon" class="fas fa-eye"></i>
                        </div>
                    </div>
                </div>

                <!-- Remember Me -->
                <div class="flex items-center">
                    <input id="remember" name="remember" type="checkbox" class="h-4 w-4 text-emerald-600 focus:ring-emerald-500 border-slate-300 rounded cursor-pointer" checked>
                    <label for="remember" class="ml-2 block text-sm text-slate-700 cursor-pointer">
                        Ingat saya di perangkat ini
                    </label>
                </div>

                <!-- Submit Button -->
                <div>
                    <button type="submit" class="w-full flex justify-center items-center py-3 px-4 border border-transparent rounded-xl shadow-md text-sm font-bold text-white bg-emerald-600 hover:bg-emerald-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-emerald-500 transition-all transform hover:-translate-y-0.5">
                        Login ke Dashboard <i class="fas fa-arrow-right ml-2"></i>
                    </button>
                </div>
            </form>

            <div class="mt-8 text-center">
                <!-- <p class="text-sm text-slate-500">
                    Bukan admin? <a href="#" class="font-medium text-emerald-600 hover:text-emerald-500 transition-colors">Kembali ke Beranda</a>
                </p> -->
            </div>
        </div>
    </div>

    <script>
        const togglePassword = document.querySelector('#togglePassword');
        const password = document.querySelector('#password');
        const eyeIcon = document.querySelector('#eyeIcon');

        togglePassword.addEventListener('click', function (e) {
            // toggle the type attribute
            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
            password.setAttribute('type', type);
            
            // toggle the eye icon
            if (type === 'password') {
                eyeIcon.classList.remove('fa-eye-slash');
                eyeIcon.classList.add('fa-eye');
            } else {
                eyeIcon.classList.remove('fa-eye');
                eyeIcon.classList.add('fa-eye-slash');
            }
        });
    </script>
</body>
</html>
