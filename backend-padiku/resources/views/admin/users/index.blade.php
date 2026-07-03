@extends('layouts.admin')

@section('title', 'Data Pengguna - Admin Padiku')
@section('header', 'Manajemen Pengguna')

@section('content')
<div class="bg-white rounded-xl shadow-sm border border-slate-100">
    <div class="p-6 border-b border-slate-100 flex justify-between items-center">
        <h3 class="text-lg font-bold text-slate-800">Daftar Pengguna (Petani)</h3>
    </div>
    
    <div class="overflow-x-auto p-6">
        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="text-slate-400 text-sm border-b border-slate-100">
                    <th class="pb-3 font-medium">Nama</th>
                    <th class="pb-3 font-medium">Email</th>
                    <th class="pb-3 font-medium">No. HP</th>
                    <th class="pb-3 font-medium">Status</th>
                    <th class="pb-3 font-medium">Bergabung Pada</th>
                    <th class="pb-3 font-medium text-right">Aksi</th>
                </tr>
            </thead>
            <tbody class="text-sm">
                @forelse($users as $user)
                <tr class="border-b border-slate-50 hover:bg-slate-50 transition-colors">
                    <td class="py-4 font-medium text-slate-700">
                        <div class="flex items-center">
                            @if($user->profile_picture)
                                <img src="{{ asset('storage/profiles/' . $user->profile_picture) }}" class="h-8 w-8 rounded-full object-cover border border-slate-200 mr-3">
                            @else
                                <div class="h-8 w-8 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center font-bold mr-3">
                                    {{ substr($user->name, 0, 1) }}
                                </div>
                            @endif
                            {{ $user->name }}
                        </div>
                    </td>
                    <td class="py-4 text-slate-500">{{ $user->email }}</td>
                    <td class="py-4 text-slate-500">{{ $user->phone ?? '-' }}</td>
                    <td class="py-4">
                        @if($user->status == 'approved')
                            <span class="px-2 py-1 bg-emerald-100 text-emerald-700 rounded-md text-xs font-semibold">Aktif</span>
                        @else
                            <span class="px-2 py-1 bg-yellow-100 text-yellow-700 rounded-md text-xs font-semibold">Menunggu Verifikasi</span>
                        @endif
                    </td>
                    <td class="py-4 text-slate-500">{{ $user->created_at->format('d M Y') }}</td>
                    <td class="py-4 text-right space-x-2 flex justify-end items-center">
                        @if($user->status == 'pending')
                            <form action="{{ route('admin.users.approve', $user->id) }}" method="POST" class="inline">
                                @csrf
                                <button type="submit" class="text-emerald-500 hover:text-emerald-700 bg-emerald-50 hover:bg-emerald-100 p-2 rounded-md transition-colors" title="Setujui">
                                    <i class="fas fa-check"></i>
                                </button>
                            </form>
                        @endif
                        <button type="button" onclick="openModal('{{ $user->id }}')" class="text-blue-500 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 p-2 rounded-md transition-colors ml-2" title="Lihat Detail">
                            <i class="fas fa-eye"></i>
                        </button>
                        <form id="delete-form-{{ $user->id }}" action="{{ route('admin.users.destroy', $user->id) }}" method="POST" class="inline">
                            @csrf
                            @method('DELETE')
                            <button type="button" onclick="confirmDelete('{{ $user->id }}', '{{ $user->name }}')" class="text-red-500 hover:text-red-700 bg-red-50 hover:bg-red-100 p-2 rounded-md transition-colors ml-2" title="Hapus">
                                <i class="fas fa-trash"></i>
                            </button>
                        </form>
                    </td>
                </tr>

                <!-- Modal Detail User -->
                <div id="modal-detail-{{ $user->id }}" class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black bg-opacity-50 transition-opacity">
                    <div class="bg-white rounded-xl shadow-lg w-full max-w-lg mx-4 overflow-hidden">
                        <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-emerald-50">
                            <h3 class="text-lg font-bold text-slate-800">Detail Pengguna</h3>
                            <button onclick="closeModal('{{ $user->id }}')" class="text-slate-400 hover:text-slate-600">
                                <i class="fas fa-times text-xl"></i>
                            </button>
                        </div>
                        <div class="p-6 space-y-4">
                            <div class="flex items-center space-x-4 mb-4">
                                @if($user->profile_picture)
                                    <img src="{{ asset('storage/profiles/' . $user->profile_picture) }}" class="w-16 h-16 rounded-full object-cover border-2 border-emerald-200">
                                @else
                                    <div class="h-16 w-16 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center text-2xl font-bold">
                                        {{ substr($user->name, 0, 1) }}
                                    </div>
                                @endif
                                <div>
                                    <h4 class="text-xl font-bold text-slate-800">{{ $user->name }}</h4>
                                    <p class="text-sm text-slate-500">{{ $user->email }}</p>
                                </div>
                            </div>
                            
                            <div class="grid grid-cols-2 gap-4 text-sm">
                                <div>
                                    <span class="block text-slate-400 mb-1">No. HP</span>
                                    <span class="font-medium text-slate-700">{{ $user->phone ?? '-' }}</span>
                                </div>
                                <div>
                                    <span class="block text-slate-400 mb-1">Status</span>
                                    <span class="font-medium text-slate-700">
                                        @if($user->status == 'approved')
                                            <span class="text-emerald-600"><i class="fas fa-check-circle mr-1"></i> Aktif</span>
                                        @else
                                            <span class="text-yellow-600"><i class="fas fa-clock mr-1"></i> Pending</span>
                                        @endif
                                    </span>
                                </div>
                                <div class="col-span-2">
                                    <span class="block text-slate-400 mb-1">Lokasi</span>
                                    <span class="font-medium text-slate-700">{{ $user->location ?? '-' }}</span>
                                </div>
                                <div>
                                    <span class="block text-slate-400 mb-1">Latitude</span>
                                    <span class="font-medium text-slate-700">{{ $user->latitude ?? '-' }}</span>
                                </div>
                                <div>
                                    <span class="block text-slate-400 mb-1">Longitude</span>
                                    <span class="font-medium text-slate-700">{{ $user->longitude ?? '-' }}</span>
                                </div>
                                <div class="col-span-2">
                                    <span class="block text-slate-400 mb-1">Bio</span>
                                    <p class="font-medium text-slate-700 bg-slate-50 p-3 rounded-lg">{{ $user->bio ?? 'Belum ada bio.' }}</p>
                                </div>
                                <div class="col-span-2">
                                    <span class="block text-slate-400 mb-1">Pengaturan Notifikasi</span>
                                    <div class="bg-slate-50 p-3 rounded-lg flex flex-wrap gap-2">
                                        @php
                                            $ns = is_string($user->notification_settings) ? json_decode($user->notification_settings, true) : $user->notification_settings;
                                            $settings = [
                                                'Jeda Semua' => $ns['pause_all'] ?? false,
                                                'Berita' => $ns['news'] ?? true,
                                                'Cuaca' => $ns['weather'] ?? true,
                                                'Promo' => $ns['shop'] ?? true,
                                                'Sistem' => $ns['system'] ?? true,
                                            ];
                                        @endphp
                                        @foreach($settings as $label => $isActive)
                                            <span class="px-2 py-1 text-xs font-semibold rounded-full {{ $isActive ? 'bg-emerald-100 text-emerald-700' : 'bg-slate-200 text-slate-600' }}">
                                                {{ $label }}: {{ $isActive ? 'On' : 'Off' }}
                                            </span>
                                        @endforeach
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="p-4 border-t border-slate-100 bg-slate-50 flex justify-end">
                            <button onclick="closeModal('{{ $user->id }}')" class="px-4 py-2 bg-slate-200 text-slate-700 rounded-lg hover:bg-slate-300 font-medium transition-colors">Tutup</button>
                        </div>
                    </div>
                </div>
                @empty
                <tr>
                    <td colspan="6" class="py-6 text-center text-slate-500">Data pengguna belum tersedia.</td>
                </tr>
                @endforelse
            </tbody>
        </table>
        
        <!-- Pagination (Opsional jika datanya banyak) -->
        <div class="mt-6">
            {{ $users->links() }}
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function confirmDelete(id, name) {
        Swal.fire({
            title: 'Hapus Akun?',
            text: "Apakah Anda yakin ingin menghapus akun '" + name + "' secara permanen? Data yang dihapus tidak bisa dikembalikan!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ef4444', // red-500
            cancelButtonColor: '#94a3b8', // slate-400
            confirmButtonText: 'Ya, Hapus!',
            cancelButtonText: 'Batal',
            reverseButtons: true
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('delete-form-' + id).submit();
            }
        });
    }

    function openModal(id) {
        document.getElementById('modal-detail-' + id).classList.remove('hidden');
    }

    function closeModal(id) {
        document.getElementById('modal-detail-' + id).classList.add('hidden');
    }
</script>
@endsection
