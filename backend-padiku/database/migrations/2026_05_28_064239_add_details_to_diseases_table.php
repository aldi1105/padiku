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
        Schema::table('diseases', function (Blueprint $table) {
            $table->string('danger_level')->nullable()->after('solution');
            $table->string('life_cycle')->nullable()->after('danger_level');
            $table->string('spread_rate')->nullable()->after('life_cycle');
            $table->text('main_characteristics')->nullable()->after('spread_rate');
            $table->text('maintenance_advice')->nullable()->after('main_characteristics');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('diseases', function (Blueprint $table) {
            $table->dropColumn([
                'danger_level',
                'life_cycle',
                'spread_rate',
                'main_characteristics',
                'maintenance_advice'
            ]);
        });
    }
};
