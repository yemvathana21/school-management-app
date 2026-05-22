<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Assignment;
use Illuminate\Http\Request;

class AssignmentController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        if ($user->isTeacher()) {
            return Assignment::where('teacher_id', $user->id)
                ->with('class', 'course')
                ->orderBy('due_date', 'desc')
                ->get();
        }
        $classIds = $user->studentClasses()->pluck('classes.id');
        return Assignment::whereIn('class_id', $classIds)
            ->with('class', 'course', 'teacher')
            ->orderBy('due_date', 'desc')
            ->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'class_id' => 'required|exists:classes,id',
            'course_id' => 'required|exists:courses,id',
            'title' => 'required|string',
            'description' => 'nullable|string',
            'due_date' => 'required|date',
            'file_url' => 'nullable|url',
        ]);

        $assignment = Assignment::create([
            'class_id' => $request->class_id,
            'course_id' => $request->course_id,
            'teacher_id' => $request->user()->id,
            'title' => $request->title,
            'description' => $request->description,
            'due_date' => $request->due_date,
            'file_url' => $request->file_url,
        ]);

        return response()->json($assignment->load('class', 'course'), 201);
    }

    public function show(Assignment $assignment)
    {
        return $assignment->load('class', 'course', 'teacher');
    }
}
