@extends('layouts.admin')

@section('title', 'Manajemen Pesanan - Admin Padiku')
@section('header', 'Daftar Pesanan (Order)')

@section('content')
<div class="bg-white rounded-xl shadow-sm border border-slate-100">
    <div class="p-6 border-b border-slate-100 flex justify-between items-center">
        <h3 class="text-lg font-bold text-slate-800">Semua Pesanan</h3>
    </div>
    
    <div class="overflow-x-auto p-6">
        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="text-slate-400 text-sm border-b border-slate-100">
                    <th class="pb-3 font-medium">Nomor Pesanan</th>
                    <th class="pb-3 font-medium">Pelanggan</th>
                    <th class="pb-3 font-medium">Total Harga</th>
                    <th class="pb-3 font-medium">Status</th>
                    <th class="pb-3 font-medium">Tanggal</th>
                    <th class="pb-3 font-medium text-right">Aksi</th>
                </tr>
            </thead>
            <tbody class="text-sm">
                @forelse($orders as $order)
                <tr class="border-b border-slate-50 hover:bg-slate-50 transition-colors">
                    <td class="py-4 font-bold text-slate-700">#{{ $order->order_number }}</td>
                    <td class="py-4 font-medium">{{ $order->user->name ?? 'User Tidak Dikenal' }}</td>
                    <td class="py-4 font-semibold text-emerald-600">Rp {{ number_format($order->total_amount, 0, ',', '.') }}</td>
                    <td class="py-4">
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
                    <td class="py-4 text-slate-500">{{ $order->created_at->format('d M Y') }}</td>
                    <td class="py-4 text-right space-x-2">
                        <button class="text-indigo-500 hover:text-indigo-700 bg-indigo-50 hover:bg-indigo-100 p-2 rounded-md transition-colors"><i class="fas fa-eye"></i></button>
                        <button class="text-blue-500 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 p-2 rounded-md transition-colors"><i class="fas fa-edit"></i></button>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="6" class="py-6 text-center text-slate-500">Data pesanan belum tersedia.</td>
                </tr>
                @endforelse
            </tbody>
        </table>
        <div class="mt-4">
            {{ $orders->links() }}
        </div>
    </div>
</div>
@endsection
