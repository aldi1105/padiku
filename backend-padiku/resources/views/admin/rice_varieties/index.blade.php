@extends('layouts.admin')

@section('header', 'Data Varietas Padi')

@section('content')
<div class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
    <div class="p-6 border-b border-slate-200 flex justify-between items-center">
        <div>
            <h3 class="text-lg font-semibold text-slate-800">Daftar Varietas Padi</h3>
            <p class="text-sm text-slate-500 mt-1">Data master jenis-jenis padi untuk panduan tanam mobile.</p>
        </div>
        <a href="{{ route('rice-varieties.create') }}" class="bg-emerald-600 hover:bg-emerald-700 text-white px-4 py-2 rounded-lg font-medium transition-colors flex items-center">
            <i class="fas fa-plus mr-2"></i> Tambah Varietas
        </a>
    </div>
    
    <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="bg-slate-50 text-slate-500 text-sm border-b border-slate-200">
                    <th class="py-3 px-6 font-medium">KODE</th>
                    <th class="py-3 px-6 font-medium">FOTO</th>
                    <th class="py-3 px-6 font-medium">NAMA VARIETAS</th>
                    <th class="py-3 px-6 font-medium">KELOMPOK</th>
                    <th class="py-3 px-6 font-medium">EKOSISTEM</th>
                    <th class="py-3 px-6 font-medium">HASIL (Ton/Ha)</th>
                    <th class="py-3 px-6 font-medium">UMUR (Hari)</th>
                    <th class="py-3 px-6 font-medium">TEKSTUR</th>
                    <th class="py-3 px-6 font-medium text-right">AKSI</th>
                </tr>
            </thead>
            <tbody class="text-sm text-slate-700 divide-y divide-slate-100">
                @forelse($varieties as $item)
                <tr class="hover:bg-slate-50/50 transition-colors">
                    <td class="py-3 px-6">
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-100 text-emerald-800">
                            {{ $item->code }}
                        </span>
                    </td>
                    <td class="py-3 px-6">
                        @if($item->image)
                            <img src="{{ asset('storage/' . $item->image) }}" alt="Foto" class="w-12 h-12 rounded object-cover">
                        @else
                            <span class="text-xs text-slate-400">Tidak ada</span>
                        @endif
                    </td>
                    <td class="py-3 px-6 font-medium text-slate-800">{{ $item->name }}</td>
                    <td class="py-3 px-6">{{ $item->group }}</td>
                    <td class="py-3 px-6">{{ $item->ecosystem }}</td>
                    <td class="py-3 px-6">{{ $item->yield_potential }}</td>
                    <td class="py-3 px-6">{{ $item->plant_age }}</td>
                    <td class="py-3 px-6">{{ $item->texture }}</td>
                    <td class="py-3 px-6 text-right space-x-2">
                        <a href="{{ route('rice-varieties.edit', $item->id) }}" class="text-blue-500 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 p-2 rounded-md transition-colors" title="Edit">
                            <i class="fas fa-edit"></i>
                        </a>
                        <form action="{{ route('rice-varieties.destroy', $item->id) }}" method="POST" class="inline" onsubmit="return confirm('Yakin ingin menghapus data ini?');">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="text-red-500 hover:text-red-700 bg-red-50 hover:bg-red-100 p-2 rounded-md transition-colors" title="Hapus">
                                <i class="fas fa-trash"></i>
                            </button>
                        </form>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="9" class="py-8 text-center text-slate-500">
                        Belum ada data varietas padi.
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>
@endsection
