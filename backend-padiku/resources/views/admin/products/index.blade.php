@extends('layouts.admin')

@section('title', 'Produk Toko - Admin Padiku')
@section('header', 'Manajemen Produk Toko')

@section('content')
<div class="bg-white rounded-xl shadow-sm border border-slate-100">
    <div class="p-6 border-b border-slate-100 flex justify-between items-center">
        <h3 class="text-lg font-bold text-slate-800">Daftar Produk</h3>
        <button onclick="openAddModal()" class="bg-emerald-600 hover:bg-emerald-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
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
                        @if($product->image)
                            <img src="{{ asset('storage/products/' . $product->image) }}" alt="{{ $product->name }}" class="w-12 h-12 object-cover rounded-lg shadow-sm">
                        @else
                            <div class="w-12 h-12 rounded-lg shadow-sm bg-emerald-100 text-emerald-600 flex items-center justify-center font-bold text-xl">
                                {{ strtoupper(substr($product->name, 0, 1)) }}
                            </div>
                        @endif
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

<!-- Modal Tambah Produk -->
<div id="add-modal" class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black bg-opacity-50 transition-opacity">
    <div class="bg-white rounded-xl shadow-lg w-full max-w-lg mx-4 overflow-hidden">
        <form action="{{ route('admin.products.store') }}" method="POST" enctype="multipart/form-data">
            @csrf
            <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-emerald-50">
                <h3 class="text-lg font-bold text-slate-800">Tambah Produk Baru</h3>
                <button type="button" onclick="closeAddModal()" class="text-slate-400 hover:text-slate-600">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            <div class="p-6 space-y-4">
                <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Nama Produk</label>
                    <input type="text" name="name" required class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500">
                </div>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Harga (Rp)</label>
                        <input type="number" name="price" required min="0" class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Stok</label>
                        <input type="number" name="stock" required min="0" class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500">
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Deskripsi</label>
                    <textarea name="description" rows="3" class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"></textarea>
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Gambar Produk</label>
                    <input type="file" name="image" accept="image/*" class="w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-emerald-50 file:text-emerald-700 hover:file:bg-emerald-100">
                </div>
            </div>
            <div class="p-4 border-t border-slate-100 bg-slate-50 flex justify-end space-x-2">
                <button type="button" onclick="closeAddModal()" class="px-4 py-2 bg-white border border-slate-300 text-slate-700 rounded-lg hover:bg-slate-50 font-medium transition-colors">Batal</button>
                <button type="submit" class="px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 font-medium transition-colors">Simpan Produk</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddModal() {
        document.getElementById('add-modal').classList.remove('hidden');
    }
    function closeAddModal() {
        document.getElementById('add-modal').classList.add('hidden');
    }
</script>
@endsection
