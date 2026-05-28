@extends('layouts.admin')

@section('title', 'Panduan Tanam - Admin Padiku')
@section('header', 'Manajemen Panduan Bertani')

@section('content')
<div class="bg-white rounded-xl shadow-sm border border-slate-100">
    <div class="p-6 border-b border-slate-100 flex justify-between items-center">
        <h3 class="text-lg font-bold text-slate-800">Daftar Panduan</h3>
        <button class="bg-emerald-600 hover:bg-emerald-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
            <i class="fas fa-plus mr-2"></i> Tulis Panduan
        </button>
    </div>
    
    <div class="overflow-x-auto p-6">
        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="text-slate-400 text-sm border-b border-slate-100">
                    <th class="pb-3 font-medium">Judul Panduan</th>
                    <th class="pb-3 font-medium">Total Dilihat</th>
                    <th class="pb-3 font-medium">Tanggal Dibuat</th>
                    <th class="pb-3 font-medium text-right">Aksi</th>
                </tr>
            </thead>
            <tbody class="text-sm">
                @forelse($guides as $guide)
                <tr class="border-b border-slate-50 hover:bg-slate-50 transition-colors">
                    <td class="py-4 font-medium text-slate-700">
                        <div class="flex items-center">
                            <img src="{{ $guide->image ?? 'https://via.placeholder.com/50' }}" class="w-10 h-10 rounded-md object-cover mr-3">
                            {{ $guide->title }}
                        </div>
                    </td>
                    <td class="py-4 text-slate-500">{{ number_format($guide->views) }} kali</td>
                    <td class="py-4 text-slate-500">{{ $guide->created_at->format('d M Y') }}</td>
                    <td class="py-4 text-right space-x-2">
                        <button onclick="openEditModal(this)" data-id="{{ $guide->id }}" data-title="{{ $guide->title }}" data-content="{{ $guide->content }}" class="text-blue-500 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 p-2 rounded-md transition-colors"><i class="fas fa-edit"></i></button>
                        <button class="text-red-500 hover:text-red-700 bg-red-50 hover:bg-red-100 p-2 rounded-md transition-colors"><i class="fas fa-trash"></i></button>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="4" class="py-6 text-center text-slate-500">Belum ada artikel panduan.</td>
                </tr>
                @endforelse
            </tbody>
        </table>
        <div class="mt-4">
            {{ $guides->links() }}
        </div>
    </div>
</div>

<!-- Edit Modal -->
<div id="editModal" class="fixed inset-0 bg-slate-900 bg-opacity-50 hidden flex items-center justify-center z-50">
    <div class="bg-white rounded-xl shadow-lg w-full max-w-2xl overflow-hidden">
        <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50">
            <h3 class="text-lg font-bold text-slate-800">Edit Panduan</h3>
            <button onclick="closeEditModal()" class="text-slate-400 hover:text-slate-600"><i class="fas fa-times"></i></button>
        </div>
        <form id="editForm" method="POST" action="">
            @csrf
            @method('PUT')
            <div class="p-6 space-y-4">
                <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Judul Panduan</label>
                    <input type="text" name="title" id="edit_title" class="w-full border border-slate-300 rounded-lg p-2.5 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition-all" required>
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-700 mb-1">Konten Panduan</label>
                    <textarea name="content" id="edit_content" rows="6" class="w-full border border-slate-300 rounded-lg p-2.5 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition-all" required></textarea>
                </div>
            </div>
            <div class="p-6 border-t border-slate-100 flex justify-end space-x-3 bg-slate-50">
                <button type="button" onclick="closeEditModal()" class="px-4 py-2 bg-slate-200 hover:bg-slate-300 text-slate-700 rounded-lg font-medium transition-colors">Batal</button>
                <button type="submit" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-medium transition-colors">Simpan Perubahan</button>
            </div>
        </form>
    </div>
</div>

<script>
function openEditModal(btn) {
    let id = btn.getAttribute('data-id');
    let title = btn.getAttribute('data-title');
    let content = btn.getAttribute('data-content');
    
    document.getElementById('editModal').classList.remove('hidden');
    document.getElementById('editForm').action = '/admin/guides/' + id;
    document.getElementById('edit_title').value = title;
    document.getElementById('edit_content').value = content;
}

function closeEditModal() {
    document.getElementById('editModal').classList.add('hidden');
}
</script>
@endsection
