@extends('layouts.admin')

@section('title', 'Produk Toko - Admin Padiku')
@section('header', 'Manajemen Produk Toko')

@section('content')
<div class="bg-white rounded-xl shadow-sm border border-slate-100">
    <div class="p-6 border-b border-slate-100 flex justify-between items-center">
        <h3 class="text-lg font-bold text-slate-800">Daftar Produk</h3>
        <button class="bg-emerald-600 hover:bg-emerald-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
            <i class="fas fa-plus mr-2"></i> Tambah Produk
        </button>
    </div>
    
    <div class="overflow-x-auto p-6">
        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="text-slate-400 text-sm border-b border-slate-100">
                    <th class="pb-3 font-medium">Gambar</th>
                    <th class="pb-3 font-medium">Nama Produk</th>
                    <th class="pb-3 font-medium">Harga</th>
                    <th class="pb-3 font-medium">Stok</th>
                    <th class="pb-3 font-medium text-right">Aksi</th>
                </tr>
            </thead>
            <tbody class="text-sm">
                @forelse($products as $product)
                <tr class="border-b border-slate-50 hover:bg-slate-50 transition-colors">
                    <td class="py-4">
                        <img src="{{ $product->image ?? 'https://via.placeholder.com/50' }}" alt="{{ $product->name }}" class="w-12 h-12 object-cover rounded-lg shadow-sm">
                    </td>
                    <td class="py-4 font-medium text-slate-700">{{ $product->name }}</td>
                    <td class="py-4 text-emerald-600 font-semibold">Rp {{ number_format($product->price, 0, ',', '.') }}</td>
                    <td class="py-4">
                        @if($product->stock > 10)
                            <span class="px-2 py-1 bg-blue-100 text-blue-700 rounded-md text-xs font-semibold">{{ $product->stock }}</span>
                        @else
                            <span class="px-2 py-1 bg-red-100 text-red-700 rounded-md text-xs font-semibold">{{ $product->stock }}</span>
                        @endif
                    </td>
                    <td class="py-4 text-right space-x-2">
                        <button class="text-blue-500 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 p-2 rounded-md transition-colors"><i class="fas fa-edit"></i></button>
                        <button class="text-red-500 hover:text-red-700 bg-red-50 hover:bg-red-100 p-2 rounded-md transition-colors"><i class="fas fa-trash"></i></button>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="5" class="py-6 text-center text-slate-500">Data produk belum tersedia.</td>
                </tr>
                @endforelse
            </tbody>
        </table>
        <div class="mt-4">
            {{ $products->links() }}
        </div>
    </div>
</div>
@endsection
