<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Admin Padiku')</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-slate-50 text-slate-800">

    <div class="flex h-screen overflow-hidden">
        
        <!-- Sidebar -->
        <aside class="w-64 bg-emerald-700 text-white flex flex-col shadow-xl">
            <div class="h-16 flex items-center justify-center border-b border-emerald-600">
                <h1 class="text-2xl font-bold tracking-wider"><i class="fas fa-leaf mr-2"></i> Padiku Admin</h1>
            </div>
            
            <nav class="flex-1 overflow-y-auto py-4 px-3 space-y-1">
                <a href="/admin/dashboard" class="flex items-center px-4 py-3 rounded-lg text-emerald-100 hover:bg-emerald-600 transition-colors {{ request()->is('admin/dashboard*') ? 'bg-emerald-800 font-medium' : '' }}">
                    <i class="fas fa-home w-5 mr-3"></i> Dashboard
                </a>
                <a href="/admin/users" class="flex items-center px-4 py-3 rounded-lg text-emerald-100 hover:bg-emerald-600 transition-colors {{ request()->is('admin/users*') ? 'bg-emerald-800 font-medium' : '' }}">
                    <i class="fas fa-users w-5 mr-3"></i> Pengguna
                </a>
                <a href="/admin/products" class="flex items-center px-4 py-3 rounded-lg text-emerald-100 hover:bg-emerald-600 transition-colors {{ request()->is('admin/products*') ? 'bg-emerald-800 font-medium' : '' }}">
                    <i class="fas fa-box w-5 mr-3"></i> Produk Toko
                </a>
                <a href="/admin/orders" class="flex items-center px-4 py-3 rounded-lg text-emerald-100 hover:bg-emerald-600 transition-colors {{ request()->is('admin/orders*') ? 'bg-emerald-800 font-medium' : '' }}">
                    <i class="fas fa-shopping-cart w-5 mr-3"></i> Pesanan
                </a>

                <a href="/admin/news" class="flex items-center px-4 py-3 rounded-lg text-emerald-100 hover:bg-emerald-600 transition-colors {{ request()->is('admin/news*') ? 'bg-emerald-800 font-medium' : '' }}">
                    <i class="fas fa-newspaper w-5 mr-3"></i> Berita Pertanian
                </a>
                <a href="/admin/diseases" class="flex items-center px-4 py-3 rounded-lg text-emerald-100 hover:bg-emerald-600 transition-colors {{ request()->is('admin/diseases*') ? 'bg-emerald-800 font-medium' : '' }}">
                    <i class="fas fa-bug w-5 mr-3"></i> Data Penyakit
                </a>
                <a href="/admin/rice-varieties" class="flex items-center px-4 py-3 rounded-lg text-emerald-100 hover:bg-emerald-600 transition-colors {{ request()->is('admin/rice-varieties*') ? 'bg-emerald-800 font-medium' : '' }}">
                    <i class="fas fa-seedling w-5 mr-3"></i> Data Padi
                </a>
                <a href="/admin/map" class="flex items-center px-4 py-3 rounded-lg text-emerald-100 hover:bg-emerald-600 transition-colors {{ request()->is('admin/map*') ? 'bg-emerald-800 font-medium' : '' }}">
                    <i class="fas fa-map-marker-alt w-5 mr-3"></i> Peta Petani
                </a>
            </nav>
            
            <div class="p-4 border-t border-emerald-600">
                <a href="/logout" class="flex items-center px-4 py-3 rounded-lg text-emerald-100 hover:bg-red-500 transition-colors">
                    <i class="fas fa-sign-out-alt w-5 mr-3"></i> Logout
                </a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="flex-1 flex flex-col h-screen overflow-hidden relative">
            
            <!-- Header -->
            <header class="h-16 bg-white shadow-sm flex items-center justify-between px-6 z-10">
                <div class="flex items-center">
                    <button class="text-slate-500 hover:text-emerald-600 focus:outline-none lg:hidden">
                        <i class="fas fa-bars text-xl"></i>
                    </button>
                    <h2 class="text-xl font-semibold text-slate-800 ml-4 lg:ml-0">@yield('header', 'Dashboard')</h2>
                </div>
                
                <div class="flex items-center space-x-4">
                    <button class="text-slate-400 hover:text-emerald-500 transition-colors">
                        <i class="fas fa-bell text-xl"></i>
                    </button>
                    <div class="h-8 w-8 rounded-full bg-emerald-200 border border-emerald-300 flex items-center justify-center text-emerald-700 font-bold">
                        A
                    </div>
                </div>
            </header>

            <!-- Content -->
            <div class="flex-1 overflow-y-auto p-6 bg-slate-50">
                @yield('content')
            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        @if(session('success'))
            Swal.fire({
                icon: 'success',
                title: 'Berhasil!',
                text: '{{ session('success') }}',
                showConfirmButton: false,
                timer: 2000,
                timerProgressBar: true,
                toast: true,
                position: 'top-end',
                customClass: {
                    popup: 'colored-toast'
                }
            });
        @endif

        @if(session('error'))
            Swal.fire({
                icon: 'error',
                title: 'Gagal!',
                text: '{{ session('error') }}',
                confirmButtonColor: '#ef4444',
            });
        @endif
    </script>
</body>
</html>
