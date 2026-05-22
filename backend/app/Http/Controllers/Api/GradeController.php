<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Grade;
use Illuminate\Http\Request;

class GradeController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        if ($user->isTeacher()) {
            return Grade::where('teacher_id', $user->id)
                ->with('student', 'course')
                ->orderBy('created_at', 'desc')
                ->get();
        }
        return Grade::where('student_id', $user->id)
            ->with('course', 'teacher')
            ->orderBy('created_at', 'desc')
            ->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'student_id' => 'required|exists:users,id',
            'course_id' => 'required|exists:courses,id',
            'type' => 'required|in:assignment,quiz,midterm,final',
            'name' => 'required|string',
            'score' => 'required|numeric|min:0',
            'max_score' => 'required|numeric|min:0',
        ]);

        $grade = Grade::create([
            'student_id' => $request->student_id,
            'course_id' => $request->course_id,
            'teacher_id' => $request->user()->id,
            'type' => $request->type,
            'name' => $request->name,
            'score' => $request->score,
            'max_score' => $request->max_score,
            'note' => $request->note,
        ]);

        return response()->json($grade->load('student', 'course'), 201);
    }
}
