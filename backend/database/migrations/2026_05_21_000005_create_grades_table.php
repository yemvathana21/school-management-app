<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('grades', function (Blueprint $table) {
            $table->id();
            $table->foreignId('student_id')->constrained('users')->cascadeOnDelete();
            $table->foreignId('course_id')->constrained('courses')->cascadeOnDelete();
            $table->foreignId('teacher_id')->constrained('users')->cascadeOnDelete();
            $table->string('type');
            $table->string('name');
            $table->decimal('score', 5, 2);
            $table->decimal('max_score', 5, 2)->default(100);
            $table->text('note')->nullable();
            $table->timestamps();
        });
    }
    public function down(): void {
        Schema::dropIfExists('grades');
    }
};
