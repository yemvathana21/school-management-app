<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Schedule;
use Illuminate\Http\Request;

class ScheduleController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        if ($user->isTeacher()) {
            return Schedule::where('teacher_id', $user->id)
                ->with('class', 'course')
                ->orderBy('day')
                ->orderBy('start_time')
                ->get();
        }
        $classIds = $user->studentClasses()->pluck('classes.id');
        return Schedule::whereIn('class_id', $classIds)
            ->with('class', 'course', 'teacher')
            ->orderBy('day')
            ->orderBy('start_time')
            ->get();
    }
}
