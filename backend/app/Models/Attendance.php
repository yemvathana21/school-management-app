<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Attendance extends Model
{
    protected $fillable = [
        'schedule_id',
        'student_id',
        'teacher_id',
        'date',
        'status',
        'note',
        'qr_code',
    ];

    protected function casts(): array
    {
        return [
            'date' => 'date',
        ];
    }

    public function schedule()
    {
        return $this->belongsTo(Schedule::class);
    }

    public function student()
    {
        return $this->belongsTo(User::class, 'student_id');
    }

    public function teacher()
    {
        return $this->belongsTo(User::class, 'teacher_id');
    }
}
