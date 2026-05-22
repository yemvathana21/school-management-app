<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Assignment extends Model
{
    protected $fillable = [
        'class_id',
        'course_id',
        'teacher_id',
        'title',
        'description',
        'due_date',
        'file_url',
    ];

    protected function casts(): array
    {
        return ['due_date' => 'date'];
    }

    public function class()
    {
        return $this->belongsTo(Classes::class);
    }

    public function course()
    {
        return $this->belongsTo(Course::class);
    }

    public function teacher()
    {
        return $this->belongsTo(User::class, 'teacher_id');
    }
}
