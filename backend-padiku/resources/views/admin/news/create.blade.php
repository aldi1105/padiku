@extends('layouts.admin')

@section('title', 'Tambah Berita - Admin Padiku')
@section('header', 'Tambah Berita')

@section('content')
<div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6 max-w-3xl">
    <form action="{{ route('admin.news.store') }}" method="POST" enctype="multipart/form-data">
        @csrf
        
        <div class="mb-4">
            <label class="block text-sm font-medium text-slate-700 mb-1">Judul Berita</label>
            <input type="text" name="title" required class="w-full rounded-lg border-slate-300 focus:border-emerald-500 focus:ring-emerald-500">
        </div>

        <div class="mb-4">
            <label class="block text-sm font-medium text-slate-700 mb-1">Gambar (Opsional)</label>
            <input type="file" name="image" accept="image/*" class="w-full rounded-lg border-slate-300 focus:border-emerald-500 focus:ring-emerald-500">
        </div>

        <div class="mb-6">
            <label class="block text-sm font-medium text-slate-700 mb-1">Konten Berita</label>
            <textarea name="content" rows="6" required class="w-full rounded-lg border-slate-300 focus:border-emerald-500 focus:ring-emerald-500"></textarea>
        </div>

        <div class="flex justify-end space-x-3">
            <a href="{{ route('admin.news.index') }}" class="px-4 py-2 text-slate-600 hover:text-slate-800 transition-colors">Batal</a>
            <button type="submit" class="bg-emerald-600 hover:bg-emerald-700 text-white px-6 py-2 rounded-lg font-medium transition-colors">Simpan Berita</button>
        </div>
    </form>
</div>
@endsection
