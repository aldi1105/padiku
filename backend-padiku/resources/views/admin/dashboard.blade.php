@extends('layouts.admin')

@section('title', 'Dashboard - Admin Padiku')
@section('header', 'Overview Dashboard')

@section('content')
<div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6 mb-8">
    <!-- Stat Card 1 -->
    <div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6 flex items-center hover:shadow-md transition-shadow">
        <div class="rounded-full bg-blue-100 p-4 mr-4">
            <i class="fas fa-users text-blue-600 text-xl"></i>
        </div>
        <div>
            <p class="text-sm text-slate-500 font-medium mb-1">Total Petani</p>
            <h3 class="text-2xl font-bold text-slate-800">{{ number_format($totalPetani) }}</h3>
        </div>
    </div>
    
    <!-- Stat Card 2 -->
    <div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6 flex items-center hover:shadow-md transition-shadow">
        <div class="rounded-full bg-emerald-100 p-4 mr-4">
            <i class="fas fa-box text-emerald-600 text-xl"></i>
        </div>
        <div>
            <p class="text-sm text-slate-500 font-medium mb-1">Total Produk</p>
            <h3 class="text-2xl font-bold text-slate-800">{{ number_format($totalProduk) }}</h3>
        </div>
    </div>
    
    <!-- Stat Card 3 -->
    <div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6 flex items-center hover:shadow-md transition-shadow">
        <div class="rounded-full bg-orange-100 p-4 mr-4">
            <i class="fas fa-shopping-cart text-orange-600 text-xl"></i>
        </div>
        <div>
            <p class="text-sm text-slate-500 font-medium mb-1">Pesanan Baru (Pending)</p>
            <h3 class="text-2xl font-bold text-slate-800">{{ number_format($pesananBaru) }}</h3>
        </div>
    </div>
    
    <!-- Stat Card 4 -->
    <div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6 flex items-center hover:shadow-md transition-shadow">
        <div class="rounded-full bg-purple-100 p-4 mr-4">
            <i class="fas fa-bug text-purple-600 text-xl"></i>
        </div>
        <div>
            <p class="text-sm text-slate-500 font-medium mb-1">Total Scan Penyakit</p>
            <h3 class="text-2xl font-bold text-slate-800">{{ number_format($totalScan) }}</h3>
        </div>
    </div>
</div>

<div class="grid grid-cols-1 gap-6">
    <!-- Pesanan Terakhir -->
    <div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6">
        <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-bold text-slate-800">Pesanan Terakhir</h3>
            <a href="/admin/orders" class="text-emerald-600 hover:text-emerald-700 text-sm font-medium">Lihat Semua</a>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="text-slate-400 text-sm border-b border-slate-100">
                        <th class="pb-3 font-medium">ID</th>
                        <th class="pb-3 font-medium">Pembeli</th>
                        <th class="pb-3 font-medium">Total</th>
                        <th class="pb-3 font-medium">Status</th>
                    </tr>
                </thead>
                <tbody class="text-sm">
                    @forelse($recentOrders as $order)
                    <tr class="border-b border-slate-50 hover:bg-slate-50 transition-colors">
                        <td class="py-3 font-medium text-slate-700">#{{ $order->order_number }}</td>
                        <td class="py-3">{{ $order->user->name ?? 'User Tidak Diketahui' }}</td>
                        <td class="py-3">Rp {{ number_format($order->total_amount, 0, ',', '.') }}</td>
                        <td class="py-3">
                            @if($order->status == 'pending')
                                <span class="px-2 py-1 bg-yellow-100 text-yellow-700 rounded-md text-xs font-semibold">Menunggu</span>
                            @elseif($order->status == 'processing')
                                <span class="px-2 py-1 bg-blue-100 text-blue-700 rounded-md text-xs font-semibold">Diproses</span>
                            @elseif($order->status == 'shipped')
                                <span class="px-2 py-1 bg-emerald-100 text-emerald-700 rounded-md text-xs font-semibold">Dikirim</span>
                            @else
                                <span class="px-2 py-1 bg-gray-100 text-gray-700 rounded-md text-xs font-semibold">{{ ucfirst($order->status) }}</span>
                            @endif
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="4" class="py-4 text-center text-slate-500">Belum ada pesanan</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
</div>
@endsection
