<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('rice_varieties', function (Blueprint $table) {
            $table->id();
            $table->string('code')->unique();
            $table->string('name');
            $table->string('group');
            $table->string('ecosystem');
            $table->decimal('yield_potential', 4, 1);
            $table->integer('plant_age');
            $table->string('texture');
            $table->string('pest_resistance');
            $table->string('region_recommendation');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rice_varieties');
    }
};
