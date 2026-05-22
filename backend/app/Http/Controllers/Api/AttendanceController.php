<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Attendance;
use App\Models\Schedule;
use Illuminate\Http\Request;

class AttendanceController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        if ($user->isTeacher()) {
            return Attendance::where('teacher_id', $user->id)
                ->with('student', 'schedule.course')
                ->orderBy('date', 'desc')
                ->get();
        }
        return Attendance::where('student_id', $user->id)
            ->with('schedule.course', 'teacher')
            ->orderBy('date', 'desc')
            ->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'schedule_id' => 'required|exists:schedules,id',
            'qr_code' => 'required|string',
        ]);

        $user = $request->user();
        $schedule = Schedule::findOrFail($request->schedule_id);

        $attendance = Attendance::updateOrCreate(
            [
                'schedule_id' => $schedule->id,
                'student_id' => $user->id,
                'date' => now()->toDateString(),
            ],
            [
                'teacher_id' => $schedule->teacher_id,
                'status' => 'present',
                'qr_code' => $request->qr_code,
            ]
        );

        return response()->json($attendance->load('schedule.course'), 201);
    }

    public function update(Request $request, Attendance $attendance)
    {
        $request->validate(['status' => 'required|in:present,absent,late,excused']);
        $attendance->update(['status' => $request->status]);
        return response()->json($attendance);
    }
}
