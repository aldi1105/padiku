<?php

namespace App\Http\Controllers;

use App\Models\Disease;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class DiseaseController extends Controller
{
    public function apiIndex()
    {
        $diseases = Disease::all();
        return response()->json([
            'status' => 'success',
            'data' => $diseases
        ]);
    }

    public function index()
    {
        $diseases = Disease::orderBy('id', 'desc')->paginate(10);
        return view('admin.diseases.index', compact('diseases'));
    }

    public function create()
    {
        return view('admin.diseases.create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'solution' => 'nullable|string',
            'image' => 'nullable|image|max:2048',
            'danger_level' => 'nullable|string',
            'life_cycle' => 'nullable|string',
            'spread_rate' => 'nullable|string',
            'main_characteristics' => 'nullable|string',
            'maintenance_advice' => 'nullable|string',
        ]);

        $data = $request->except('image');

        if ($request->hasFile('image')) {
            $data['image'] = $request->file('image')->store('diseases', 'public');
        }

        Disease::create($data);

        return redirect()->route('diseases.index')->with('success', 'Data hama/penyakit berhasil ditambahkan.');
    }

    public function edit(Disease $disease)
    {
        return view('admin.diseases.edit', compact('disease'));
    }

    public function update(Request $request, Disease $disease)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'solution' => 'nullable|string',
            'image' => 'nullable|image|max:2048',
            'danger_level' => 'nullable|string',
            'life_cycle' => 'nullable|string',
            'spread_rate' => 'nullable|string',
            'main_characteristics' => 'nullable|string',
            'maintenance_advice' => 'nullable|string',
        ]);

        $data = $request->except('image');

        if ($request->hasFile('image')) {
            if ($disease->image) {
                Storage::disk('public')->delete($disease->image);
            }
            $data['image'] = $request->file('image')->store('diseases', 'public');
        }

        $disease->update($data);

        return redirect()->route('diseases.index')->with('success', 'Data hama/penyakit berhasil diperbarui.');
    }

    public function destroy(Disease $disease)
    {
        if ($disease->image) {
            Storage::disk('public')->delete($disease->image);
        }
        $disease->delete();

        return redirect()->route('diseases.index')->with('success', 'Data hama/penyakit berhasil dihapus.');
    }
}
