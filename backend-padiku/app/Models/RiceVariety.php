<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RiceVariety extends Model
{
    use HasFactory;

    protected $fillable = [
        'code',
        'name',
        'image',
        'group',
        'ecosystem',
        'yield_potential',
        'plant_age',
        'texture',
        'pest_resistance',
        'region_recommendation',
    ];
}
