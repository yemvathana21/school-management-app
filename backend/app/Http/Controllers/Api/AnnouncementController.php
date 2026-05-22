<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Announcement;
use Illuminate\Http\Request;

class AnnouncementController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        return Announcement::whereIn('target_role', ['all', $user->role])
            ->with('author')
            ->orderBy('created_at', 'desc')
            ->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string',
            'content' => 'required|string',
            'target_role' => 'required|in:all,student,teacher',
        ]);

        $announcement = Announcement::create([
            'title' => $request->title,
            'content' => $request->content,
            'author_id' => $request->user()->id,
            'target_role' => $request->target_role,
        ]);

        return response()->json($announcement->load('author'), 201);
    }
}
