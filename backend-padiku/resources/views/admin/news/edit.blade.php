@extends('layouts.admin')

@section('title', 'Edit Berita - Admin Padiku')
@section('header', 'Edit Berita')

@section('content')
<div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6 max-w-3xl">
    <form action="{{ route('admin.news.update', $news->id) }}" method="POST" enctype="multipart/form-data">
        @csrf
        @method('PUT')
        
        <div class="mb-4">
            <label class="block text-sm font-medium text-slate-700 mb-1">Judul Berita</label>
            <input type="text" name="title" value="{{ $news->title }}" required class="w-full rounded-lg border-slate-300 focus:border-emerald-500 focus:ring-emerald-500">
        </div>

        <div class="mb-4">
            <label class="block text-sm font-medium text-slate-700 mb-1">Gambar saat ini</label>
            @if($news->image)
                <img src="{{ asset('storage/news/'.$news->image) }}" class="h-32 object-contain mb-2 rounded border">
            @else
                <p class="text-slate-500 text-sm mb-2">Tidak ada gambar</p>
            @endif
            <label class="block text-sm font-medium text-slate-700 mb-1">Ganti Gambar (Opsional)</label>
            <input type="file" name="image" accept="image/*" class="w-full rounded-lg border-slate-300 focus:border-emerald-500 focus:ring-emerald-500">
        </div>

        <div class="mb-6">
            <label class="block text-sm font-medium text-slate-700 mb-1">Konten Berita</label>
            <textarea name="content" rows="6" required class="w-full rounded-lg border-slate-300 focus:border-emerald-500 focus:ring-emerald-500">{{ $news->content }}</textarea>
        </div>

        <div class="flex justify-end space-x-3">
            <a href="{{ route('admin.news.index') }}" class="px-4 py-2 text-slate-600 hover:text-slate-800 transition-colors">Batal</a>
            <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-lg font-medium transition-colors">Perbarui Berita</button>
        </div>
    </form>
</div>
@endsection
