<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Classes;
use Illuminate\Http\Request;

class ClassController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        if ($user->isTeacher()) {
            return Classes::where('teacher_id', $user->id)->with('students')->get();
        }
        return $user->studentClasses()->with('teacher', 'schedules.course')->get();
    }

    public function show(Classes $class)
    {
        return $class->load('teacher', 'students', 'schedules.course');
    }
}
