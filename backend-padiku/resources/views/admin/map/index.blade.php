@extends('layouts.admin')

@section('title', 'Peta Petani - Admin Padiku')
@section('header', 'Peta Sebaran Petani Aktif')

@section('content')
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" crossorigin=""/>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" crossorigin=""></script>

<div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6 flex flex-col" style="height: calc(100vh - 140px);">
    <div class="mb-4">
        <h3 class="text-lg font-bold text-slate-800">Peta Sebaran Petani</h3>
        <p class="text-slate-500 text-sm">Menampilkan lokasi petani yang aktif membuka aplikasi dalam 24 jam terakhir.</p>
    </div>
    
    <div id="map" class="w-full flex-1 rounded-xl border border-slate-200 z-0 relative"></div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Koordinat default (Karawang)
        var map = L.map('map').setView([-6.3013, 107.3013], 11);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '© OpenStreetMap'
        }).addTo(map);

        var markers = [];
        var firstLoad = true;

        function loadMarkers() {
            fetch('/admin/map/data')
                .then(res => res.json())
                .then(users => {
                    // Hapus marker lama
                    markers.forEach(m => map.removeLayer(m));
                    markers = [];
                    
                    users.forEach(function(user) {
                        if (user.latitude && user.longitude) {
                            var lat = parseFloat(user.latitude);
                            var lng = parseFloat(user.longitude);
                            
                            // Tambahkan marker jika valid
                            if(!isNaN(lat) && !isNaN(lng)) {
                                var marker = L.marker([lat, lng]).addTo(map);
                                
                                var popupContent = `
                                    <div class="text-center p-2">
                                        <h4 class="font-bold text-emerald-700">${user.name}</h4>
                                        <p class="text-xs text-slate-600 mb-1">${user.email}</p>
                                        <p class="text-xs text-slate-500">${user.location ?? 'Lokasi tidak diketahui'}</p>
                                        <p class="text-xs text-slate-400 mt-1">${user.phone ?? 'No HP belum diisi'}</p>
                                    </div>
                                `;
                                marker.bindPopup(popupContent);
                                markers.push(marker);
                            }
                        }
                    });

                    // Sesuaikan tampilan agar semua marker terlihat pada awal load saja
                    if(firstLoad && markers.length > 0) {
                        var group = new L.featureGroup(markers);
                        map.fitBounds(group.getBounds().pad(0.1));
                        firstLoad = false;
                    }
                })
                .catch(err => console.error("Error fetching map data: ", err));
        }

        loadMarkers();
        setInterval(loadMarkers, 20000); // 20 detik
    });
</script>
@endsection
