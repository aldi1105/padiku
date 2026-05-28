<?php

namespace App\Http\Controllers;

use App\Models\RiceVariety;
use Illuminate\Http\Request;

class RiceVarietyController extends Controller
{
    /**
     * Display a listing of the resource for API.
     */
    public function apiIndex()
    {
        $varieties = \App\Models\RiceVariety::all();
        return response()->json([
            'status' => 'success',
            'data' => $varieties
        ]);
    }

    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $varieties = \App\Models\RiceVariety::all();
        return view('admin.rice_varieties.index', compact('varieties'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('admin.rice_varieties.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'code' => 'required|string|max:50',
            'name' => 'required|string|max:255',
            'group' => 'nullable|string|max:100',
            'ecosystem' => 'nullable|string|max:100',
            'yield_potential' => 'nullable|string|max:50',
            'plant_age' => 'nullable|string|max:50',
            'texture' => 'nullable|string|max:100',
            'pest_resistance' => 'nullable|string',
            'region_recommendation' => 'nullable|string',
            'image' => 'nullable|image|max:2048'
        ]);

        $data = $request->except('image');
        if ($request->hasFile('image')) {
            $data['image'] = $request->file('image')->store('rice_varieties', 'public');
        }

        RiceVariety::create($data);
        return redirect()->route('rice-varieties.index')->with('success', 'Varietas Padi berhasil ditambahkan.');
    }

    /**
     * Display the specified resource.
     */
    public function show(RiceVariety $riceVariety)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(RiceVariety $riceVariety)
    {
        return view('admin.rice_varieties.edit', compact('riceVariety'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, RiceVariety $riceVariety)
    {
        $request->validate([
            'code' => 'required|string|max:50',
            'name' => 'required|string|max:255',
            'group' => 'nullable|string|max:100',
            'ecosystem' => 'nullable|string|max:100',
            'yield_potential' => 'nullable|string|max:50',
            'plant_age' => 'nullable|string|max:50',
            'texture' => 'nullable|string|max:100',
            'pest_resistance' => 'nullable|string',
            'region_recommendation' => 'nullable|string',
            'image' => 'nullable|image|max:2048'
        ]);

        $data = $request->except('image');
        if ($request->hasFile('image')) {
            if ($riceVariety->image) {
                \Illuminate\Support\Facades\Storage::disk('public')->delete($riceVariety->image);
            }
            $data['image'] = $request->file('image')->store('rice_varieties', 'public');
        }

        $riceVariety->update($data);
        return redirect()->route('rice-varieties.index')->with('success', 'Varietas Padi berhasil diperbarui.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(RiceVariety $riceVariety)
    {
        if ($riceVariety->image) {
            \Illuminate\Support\Facades\Storage::disk('public')->delete($riceVariety->image);
        }
        $riceVariety->delete();
        return redirect()->route('rice-varieties.index')->with('success', 'Varietas Padi berhasil dihapus.');
    }
}
