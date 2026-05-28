<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Disease extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'image',
        'description',
        'solution',
        'scan_count',
        'danger_level',
        'life_cycle',
        'spread_rate',
        'main_characteristics',
        'maintenance_advice'
    ];
}
