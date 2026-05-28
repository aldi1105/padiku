@extends('layouts.admin')

@section('title', 'Tambah Data Hama & Penyakit - Admin Padiku')
@section('header', 'Tambah Data Hama & Penyakit')

@section('content')
<div class="bg-white rounded-xl shadow-sm border border-slate-100 max-w-4xl">
    <div class="p-6 border-b border-slate-100 flex justify-between items-center">
        <h3 class="text-lg font-bold text-slate-800">Form Tambah Data Hama/Penyakit</h3>
        <a href="{{ route('diseases.index') }}" class="text-slate-500 hover:text-slate-700 transition-colors">
            <i class="fas fa-arrow-left mr-1"></i> Kembali
        </a>
    </div>

    @if ($errors->any())
        <div class="p-4 mx-6 mt-6 bg-red-50 text-red-600 rounded-lg border border-red-200">
            <ul class="list-disc list-inside">
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <form action="{{ route('diseases.store') }}" method="POST" enctype="multipart/form-data" class="p-6 space-y-6">
        @csrf
        
        <div>
            <label class="block text-sm font-medium text-slate-700 mb-2">Nama Hama/Penyakit <span class="text-red-500">*</span></label>
            <input type="text" name="name" required value="{{ old('name') }}" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500" placeholder="Contoh: Wereng Coklat, Hawar Daun Bakteri">
        </div>

        <div>
            <label class="block text-sm font-medium text-slate-700 mb-2">Gambar Referensi (Opsional)</label>
            <div class="relative flex items-center justify-center w-full">
                <label for="dropzone-file" id="dropzone-label" class="flex flex-col items-center justify-center w-full h-40 border-2 border-slate-300 border-dashed rounded-lg cursor-pointer bg-slate-50 hover:bg-slate-100 transition-colors">
                    <div class="flex flex-col items-center justify-center pt-5 pb-6">
                        <i class="fas fa-cloud-upload-alt text-3xl text-slate-400 mb-3"></i>
                        <p class="mb-2 text-sm text-slate-500"><span class="font-semibold">Klik untuk upload</span> atau drag and drop</p>
                        <p class="text-xs text-slate-500">Gunakan gambar jelas agar mudah dikenali. Format JPG, PNG (Maks 2MB).</p>
                        <p id="file-name" class="text-emerald-600 font-medium mt-2 text-sm hidden"></p>
                    </div>
                    <input id="dropzone-file" type="file" name="image" accept="image/*" class="hidden" onchange="showFileName(this)" />
                </label>
            </div>
        </div>

        <div>
            <label class="block text-sm font-medium text-slate-700 mb-2">Deskripsi & Gejala Serangan</label>
            <textarea name="description" rows="4" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500" placeholder="Tuliskan deskripsi hama dan bagaimana gejalanya pada tanaman padi...">{{ old('description') }}</textarea>
        </div>

        <div>
            <label class="block text-sm font-medium text-slate-700 mb-2">Cara Penanganan / Solusi</label>
            <textarea name="solution" rows="4" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500" placeholder="Tuliskan langkah-langkah penanganan atau pestisida yang disarankan...">{{ old('solution') }}</textarea>
        </div>

        <div>
            <label class="block text-sm font-medium text-slate-700 mb-2">Tingkat Bahaya</label>
            <select name="danger_level" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500">
                <option value="">-- Pilih Tingkat Bahaya --</option>
                <option value="Rendah" {{ old('danger_level') == 'Rendah' ? 'selected' : '' }}>Rendah</option>
                <option value="Sedang" {{ old('danger_level') == 'Sedang' ? 'selected' : '' }}>Sedang</option>
                <option value="Tinggi" {{ old('danger_level') == 'Tinggi' ? 'selected' : '' }}>Tinggi</option>
            </select>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">Siklus Hidup</label>
                <input type="text" name="life_cycle" value="{{ old('life_cycle') }}" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500" placeholder="Contoh: 30-40 hari">
            </div>
            <div>
                <label class="block text-sm font-medium text-slate-700 mb-2">Tingkat Penyebaran</label>
                <input type="text" name="spread_rate" value="{{ old('spread_rate') }}" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500" placeholder="Contoh: Sangat Cepat (Melalui Angin)">
            </div>
        </div>

        <div>
            <label class="block text-sm font-medium text-slate-700 mb-2">Karakteristik Utama</label>
            <textarea name="main_characteristics" rows="3" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500" placeholder="Sebutkan ciri-ciri fisik utama hama atau gejala khas penyakit...">{{ old('main_characteristics') }}</textarea>
        </div>

        <div>
            <label class="block text-sm font-medium text-slate-700 mb-2">Saran Perawatan Pencegahan</label>
            <textarea name="maintenance_advice" rows="3" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500" placeholder="Contoh: Lakukan pembersihan gulma secara rutin, atur jarak tanam jajar legowo...">{{ old('maintenance_advice') }}</textarea>
        </div>

        <div class="flex justify-end pt-4 border-t border-slate-100">
            <button type="submit" class="bg-emerald-600 hover:bg-emerald-700 text-white px-6 py-2 rounded-lg font-medium transition-colors">
                <i class="fas fa-save mr-2"></i> Simpan Data
            </button>
        </div>
    </form>
</div>

<script>
    const dropzone = document.getElementById('dropzone-label');
    const fileInput = document.getElementById('dropzone-file');
    const fileNameDisplay = document.getElementById('file-name');

    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        dropzone.addEventListener(eventName, preventDefaults, false);
    });

    function preventDefaults(e) {
        e.preventDefault();
        e.stopPropagation();
    }

    ['dragenter', 'dragover'].forEach(eventName => {
        dropzone.addEventListener(eventName, highlight, false);
    });

    ['dragleave', 'drop'].forEach(eventName => {
        dropzone.addEventListener(eventName, unhighlight, false);
    });

    function highlight(e) {
        dropzone.classList.add('border-emerald-500', 'bg-emerald-50');
    }

    function unhighlight(e) {
        dropzone.classList.remove('border-emerald-500', 'bg-emerald-50');
    }

    dropzone.addEventListener('drop', handleDrop, false);

    function handleDrop(e) {
        const dt = e.dataTransfer;
        const files = dt.files;

        if (files.length) {
            fileInput.files = files;
            showFileName(fileInput);
        }
    }

    function showFileName(input) {
        if (input.files && input.files.length > 0) {
            fileNameDisplay.textContent = "File terpilih: " + input.files[0].name;
            fileNameDisplay.classList.remove('hidden');
        } else {
            fileNameDisplay.classList.add('hidden');
        }
    }
</script>
@endsection
