@extends('layouts.admin')

@section('title', 'Data Penyakit Padi - Admin Padiku')
@section('header', 'Manajemen Penyakit Padi')

@section('content')
<div class="bg-white rounded-xl shadow-sm border border-slate-100">
    <div class="p-6 border-b border-slate-100 flex justify-between items-center">
        <h3 class="text-lg font-bold text-slate-800">Database Penyakit (Untuk Scan AI)</h3>
        <a href="{{ route('diseases.create') }}" class="bg-emerald-600 hover:bg-emerald-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
            <i class="fas fa-plus mr-2"></i> Tambah Hama/Penyakit
        </a>
    </div>
    
    <div class="overflow-x-auto p-6">
        @if(session('success'))
            <div class="mb-4 bg-emerald-50 text-emerald-600 border border-emerald-200 px-4 py-3 rounded-lg">
                {{ session('success') }}
            </div>
        @endif

        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="text-slate-400 text-sm border-b border-slate-100">
                    <th class="pb-3 font-medium">Gambar</th>
                    <th class="pb-3 font-medium">Nama Penyakit/Hama</th>
                    <th class="pb-3 font-medium">Tingkat Bahaya</th>
                    <th class="pb-3 font-medium">Siklus Hidup</th>
                    <th class="pb-3 font-medium">Penyebaran</th>
                    <th class="pb-3 font-medium text-center">Total Scan</th>
                    <th class="pb-3 font-medium text-right">Aksi</th>
                </tr>
            </thead>
            <tbody class="text-sm">
                @forelse($diseases as $disease)
                <tr class="border-b border-slate-50 hover:bg-slate-50 transition-colors">
                    <td class="py-4">
                        @if($disease->image)
                            <img src="{{ Storage::url($disease->image) }}" class="w-12 h-12 object-cover rounded-md border border-slate-200">
                        @else
                            <div class="w-12 h-12 bg-slate-100 rounded-md border border-slate-200 flex items-center justify-center text-slate-400">
                                <i class="fas fa-image"></i>
                            </div>
                        @endif
                    </td>
                    <td class="py-4 font-medium text-slate-700">{{ $disease->name }}</td>
                    <td class="py-4">
                        @if($disease->danger_level == 'Tinggi')
                            <span class="px-2 py-1 bg-red-100 text-red-700 text-xs rounded-md font-medium">Tinggi</span>
                        @elseif($disease->danger_level == 'Sedang')
                            <span class="px-2 py-1 bg-yellow-100 text-yellow-700 text-xs rounded-md font-medium">Sedang</span>
                        @elseif($disease->danger_level == 'Rendah')
                            <span class="px-2 py-1 bg-green-100 text-green-700 text-xs rounded-md font-medium">Rendah</span>
                        @else
                            <span class="text-slate-400 text-xs">-</span>
                        @endif
                    </td>
                    <td class="py-4 text-slate-600">{{ $disease->life_cycle ?? '-' }}</td>
                    <td class="py-4 text-slate-600">{{ $disease->spread_rate ?? '-' }}</td>
                    <td class="py-4 text-slate-500 text-center">{{ number_format($disease->scan_count) }}</td>
                    <td class="py-4 text-right space-x-2">
                        <a href="{{ route('diseases.edit', $disease->id) }}" class="inline-block text-blue-500 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 p-2 rounded-md transition-colors"><i class="fas fa-edit"></i></a>
                        <form action="{{ route('diseases.destroy', $disease->id) }}" method="POST" class="inline-block form-delete">
                            @csrf
                            @method('DELETE')
                            <button type="button" class="btn-delete text-red-500 hover:text-red-700 bg-red-50 hover:bg-red-100 p-2 rounded-md transition-colors"><i class="fas fa-trash"></i></button>
                        </form>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="7" class="py-6 text-center text-slate-500">Belum ada data penyakit/hama.</td>
                </tr>
                @endforelse
            </tbody>
        </table>
        <div class="mt-4">
            {{ $diseases->links() }}
        </div>
    </div>
</div>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    document.querySelectorAll('.btn-delete').forEach(button => {
        button.addEventListener('click', function() {
            const form = this.closest('form');
            Swal.fire({
                title: 'Hapus Data?',
                text: "Data penyakit ini akan dihapus secara permanen!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ef4444',
                cancelButtonColor: '#94a3b8',
                confirmButtonText: 'Ya, Hapus!',
                cancelButtonText: 'Batal'
            }).then((result) => {
                if (result.isConfirmed) {
                    form.submit();
                }
            });
        });
    });
</script>
</div>
@endsection
