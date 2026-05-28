@extends('layouts.admin')

@section('title', 'Berita Pertanian (Live CNN) - Admin Padiku')
@section('header', 'Manajemen Berita (Live CNN)')

@section('content')
<div class="bg-white rounded-xl shadow-sm border border-slate-100">
    <div class="p-6 border-b border-slate-100 flex justify-between items-center">
        <div>
            <h3 class="text-lg font-bold text-slate-800">Daftar Berita Terkini</h3>
            <p class="text-sm text-slate-500 mt-1">Berita di bawah ini diambil secara langsung (Live) dari RSS Feed CNN Indonesia Ekonomi.</p>
        </div>
        <a href="{{ route('admin.news.index') }}" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
            <i class="fas fa-sync-alt mr-2"></i> Segarkan Data
        </a>
    </div>
    
    <div class="overflow-x-auto p-6">
        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="text-slate-400 text-sm border-b border-slate-100">
                    <th class="pb-3 font-medium">Gambar</th>
                    <th class="pb-3 font-medium w-1/2">Judul Berita</th>
                    <th class="pb-3 font-medium">Tanggal Diterbitkan</th>
                    <th class="pb-3 font-medium text-right">Sumber Asli</th>
                </tr>
            </thead>
            <tbody class="text-sm">
                @forelse($news as $item)
                <tr class="border-b border-slate-50 hover:bg-slate-50 transition-colors">
                    <td class="py-4">
                        @if($item->image)
                            <img src="{{ $item->image }}" class="h-16 w-16 object-cover rounded shadow-sm">
                        @else
                            <div class="h-16 w-16 bg-slate-100 rounded flex items-center justify-center text-slate-400">
                                <i class="fas fa-image"></i>
                            </div>
                        @endif
                    </td>
                    <td class="py-4 pr-4">
                        <div class="font-bold text-slate-700 text-base mb-1">{{ $item->title }}</div>
                        <div class="text-slate-500 text-xs line-clamp-2">{{ $item->description }}</div>
                    </td>
                    <td class="py-4 text-slate-600 font-medium whitespace-nowrap">{{ $item->pubDate }}</td>
                    <td class="py-4 text-right">
                        <a href="{{ $item->link }}" target="_blank" class="inline-flex items-center text-blue-500 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 px-3 py-1.5 rounded-md transition-colors font-medium">
                            Baca di {{ $item->source ?? 'Sumber Asli' }} <i class="fas fa-external-link-alt ml-2 text-xs"></i>
                        </a>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="4" class="py-8 text-center text-slate-500">
                        <i class="fas fa-rss text-3xl mb-3 text-slate-300"></i>
                        <p>Gagal mengambil berita dari CNN atau tidak ada berita terbaru bulan ini.</p>
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>
@endsection
