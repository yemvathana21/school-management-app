<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Schedule;
use Illuminate\Http\Request;

class QrController extends Controller
{
    public function generate(Request $request)
    {
        $request->validate([
            'schedule_id' => 'required|exists:schedules,id',
        ]);

        $schedule = Schedule::findOrFail($request->schedule_id);

        if ($schedule->teacher_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $qrData = $schedule->id . '|' . now()->timestamp;

        return response()->json([
            'qr_data' => $qrData,
            'schedule_id' => $schedule->id,
            'course' => $schedule->course->name,
            'class' => $schedule->class->name,
        ]);
    }
}
