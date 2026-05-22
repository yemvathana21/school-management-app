<?php

namespace Database\Seeders;

use App\Models\Announcement;
use App\Models\Attendance;
use App\Models\Classes;
use App\Models\Course;
use App\Models\Grade;
use App\Models\Schedule;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $password = Hash::make('password');

        // --- Users ---
        $admin = User::create([
            'name' => 'Admin PSBU',
            'email' => 'admin@psbu.ac.id',
            'password' => $password,
            'role' => 'admin',
            'phone' => '081234567890',
        ]);

        $teacher1 = User::create([
            'name' => 'Budi Santoso',
            'email' => 'budi@psbu.ac.id',
            'password' => $password,
            'role' => 'teacher',
            'nip' => '198501012010011001',
            'phone' => '081234567891',
        ]);

        $teacher2 = User::create([
            'name' => 'Siti Rahmawati',
            'email' => 'siti@psbu.ac.id',
            'password' => $password,
            'role' => 'teacher',
            'nip' => '198702152012012002',
            'phone' => '081234567892',
        ]);

        $students = [];
        $studentNames = [
            'Ahmad Fauzi', 'Bella Permata', 'Citra Dewi', 'Dimas Ardiansyah',
            'Eka Putri', 'Fajar Hidayat', 'Gita Maharani', 'Hendra Gunawan',
            'Intan Nurhayati', 'Joko Prasetyo',
        ];

        foreach ($studentNames as $i => $name) {
            $students[] = User::create([
                'name' => $name,
                'email' => 'student' . ($i + 1) . '@psbu.ac.id',
                'password' => $password,
                'role' => 'student',
                'nis' => '202400' . str_pad((string)($i + 1), 3, '0', STR_PAD_LEFT),
                'phone' => '0812345679' . str_pad((string)($i), 2, '0', STR_PAD_LEFT),
            ]);
        }

        // --- Courses ---
        $courses = [];
        $courseData = [
            ['Matematika', 'MTH-101', 'Matematika Wajib Kelas X', 4],
            ['Fisika', 'PHY-101', 'Fisika Dasar', 3],
            ['Bahasa Inggris', 'ENG-101', 'Bahasa Inggris Kelas X', 3],
            ['Biologi', 'BIO-101', 'Biologi Dasar', 3],
            ['Informatika', 'CS-101', 'Dasar-Dasar Informatika', 3],
        ];

        foreach ($courseData as $data) {
            $courses[] = Course::create([
                'name' => $data[0],
                'code' => $data[1],
                'description' => $data[2],
                'credits' => $data[3],
            ]);
        }

        // --- Classes ---
        $class1 = Classes::create([
            'name' => 'X-A',
            'code' => 'X-A',
            'description' => 'Kelas X - A',
            'teacher_id' => $teacher1->id,
        ]);

        $class2 = Classes::create([
            'name' => 'X-B',
            'code' => 'X-B',
            'description' => 'Kelas X - B',
            'teacher_id' => $teacher2->id,
        ]);

        // Assign students to classes (5 each)
        for ($i = 0; $i < 5; $i++) {
            $class1->students()->attach($students[$i]->id);
            $class2->students()->attach($students[$i + 5]->id);
        }

        // --- Schedules ---
        $days = ['Senin', 'Selasa', 'Rabu', 'Kamis', "Jum'at"];
        $scheduleTemplates = [
            // class1 schedules
            ['class_id' => $class1->id, 'course_id' => $courses[0]->id, 'teacher_id' => $teacher1->id, 'day' => 'Senin', 'start_time' => '07:00', 'end_time' => '08:30', 'room' => 'Ruang 101'],
            ['class_id' => $class1->id, 'course_id' => $courses[1]->id, 'teacher_id' => $teacher1->id, 'day' => 'Senin', 'start_time' => '09:00', 'end_time' => '10:30', 'room' => 'Lab Fisika'],
            ['class_id' => $class1->id, 'course_id' => $courses[2]->id, 'teacher_id' => $teacher2->id, 'day' => 'Selasa', 'start_time' => '07:00', 'end_time' => '08:30', 'room' => 'Ruang 102'],
            ['class_id' => $class1->id, 'course_id' => $courses[4]->id, 'teacher_id' => $teacher2->id, 'day' => 'Selasa', 'start_time' => '09:00', 'end_time' => '10:30', 'room' => 'Lab Komputer'],
            ['class_id' => $class1->id, 'course_id' => $courses[3]->id, 'teacher_id' => $teacher2->id, 'day' => 'Rabu', 'start_time' => '07:00', 'end_time' => '08:30', 'room' => 'Ruang 103'],
            ['class_id' => $class1->id, 'course_id' => $courses[0]->id, 'teacher_id' => $teacher1->id, 'day' => 'Kamis', 'start_time' => '08:00', 'end_time' => '09:30', 'room' => 'Ruang 101'],
            ['class_id' => $class1->id, 'course_id' => $courses[1]->id, 'teacher_id' => $teacher1->id, 'day' => "Jum'at", 'start_time' => '07:00', 'end_time' => '08:30', 'room' => 'Lab Fisika'],
            // class2 schedules
            ['class_id' => $class2->id, 'course_id' => $courses[2]->id, 'teacher_id' => $teacher2->id, 'day' => 'Senin', 'start_time' => '07:00', 'end_time' => '08:30', 'room' => 'Ruang 102'],
            ['class_id' => $class2->id, 'course_id' => $courses[3]->id, 'teacher_id' => $teacher2->id, 'day' => 'Senin', 'start_time' => '09:00', 'end_time' => '10:30', 'room' => 'Ruang 103'],
            ['class_id' => $class2->id, 'course_id' => $courses[0]->id, 'teacher_id' => $teacher1->id, 'day' => 'Selasa', 'start_time' => '07:00', 'end_time' => '08:30', 'room' => 'Ruang 101'],
            ['class_id' => $class2->id, 'course_id' => $courses[4]->id, 'teacher_id' => $teacher2->id, 'day' => 'Rabu', 'start_time' => '07:00', 'end_time' => '08:30', 'room' => 'Lab Komputer'],
            ['class_id' => $class2->id, 'course_id' => $courses[1]->id, 'teacher_id' => $teacher1->id, 'day' => 'Rabu', 'start_time' => '09:00', 'end_time' => '10:30', 'room' => 'Lab Fisika'],
            ['class_id' => $class2->id, 'course_id' => $courses[2]->id, 'teacher_id' => $teacher2->id, 'day' => 'Kamis', 'start_time' => '07:00', 'end_time' => '08:30', 'room' => 'Ruang 102'],
            ['class_id' => $class2->id, 'course_id' => $courses[0]->id, 'teacher_id' => $teacher1->id, 'day' => "Jum'at", 'start_time' => '09:00', 'end_time' => '10:30', 'room' => 'Ruang 101'],
        ];

        $schedules = [];
        foreach ($scheduleTemplates as $data) {
            $schedules[] = Schedule::create($data);
        }

        // --- Announcements ---
        Announcement::create([
            'title' => 'Libur Nasional',
            'content' => 'Diberitahukan bahwa hari Jumat, 28 Mei 2026, merupakan hari libur nasional. Kegiatan belajar mengajar diliburkan.',
            'author_id' => $admin->id,
            'target_role' => 'all',
        ]);

        Announcement::create([
            'title' => 'Jadwal Ujian Akhir Semester',
            'content' => 'Jadwal Ujian Akhir Semester Genap 2025/2026 telah diterbitkan. Silakan cek jadwal masing-masing di menu jadwal.',
            'author_id' => $admin->id,
            'target_role' => 'student',
        ]);

        Announcement::create([
            'title' => 'Rapat Guru',
            'content' => 'Rapat guru akan dilaksanakan pada hari Sabtu, 22 Mei 2026 pukul 09.00 di ruang guru.',
            'author_id' => $admin->id,
            'target_role' => 'teacher',
        ]);

        Announcement::create([
            'title' => 'Pendaftaran Ekstrakurikuler',
            'content' => 'Pendaftaran ekstrakurikuler semester genap dibuka hingga 30 Mei 2026. Silakan daftar ke pembina masing-masing.',
            'author_id' => $admin->id,
            'target_role' => 'student',
        ]);

        // --- Sample Attendances ---
        Attendance::create([
            'schedule_id' => $schedules[0]->id,
            'student_id' => $students[0]->id,
            'teacher_id' => $teacher1->id,
            'date' => now()->toDateString(),
            'status' => 'present',
        ]);

        Attendance::create([
            'schedule_id' => $schedules[0]->id,
            'student_id' => $students[1]->id,
            'teacher_id' => $teacher1->id,
            'date' => now()->toDateString(),
            'status' => 'present',
        ]);

        Attendance::create([
            'schedule_id' => $schedules[0]->id,
            'student_id' => $students[2]->id,
            'teacher_id' => $teacher1->id,
            'date' => now()->toDateString(),
            'status' => 'late',
        ]);

        Attendance::create([
            'schedule_id' => $schedules[0]->id,
            'student_id' => $students[3]->id,
            'teacher_id' => $teacher1->id,
            'date' => now()->toDateString(),
            'status' => 'absent',
        ]);

        Attendance::create([
            'schedule_id' => $schedules[0]->id,
            'student_id' => $students[4]->id,
            'teacher_id' => $teacher1->id,
            'date' => now()->toDateString(),
            'status' => 'present',
        ]);

        // --- Sample Grades ---
        Grade::create([
            'student_id' => $students[0]->id,
            'course_id' => $courses[0]->id,
            'teacher_id' => $teacher1->id,
            'type' => 'assignment',
            'name' => 'PR 1 - Sistem Persamaan',
            'score' => 85,
            'max_score' => 100,
        ]);

        Grade::create([
            'student_id' => $students[0]->id,
            'course_id' => $courses[0]->id,
            'teacher_id' => $teacher1->id,
            'type' => 'quiz',
            'name' => 'Quiz 1 - Matriks',
            'score' => 90,
            'max_score' => 100,
        ]);

        Grade::create([
            'student_id' => $students[0]->id,
            'course_id' => $courses[1]->id,
            'teacher_id' => $teacher1->id,
            'type' => 'assignment',
            'name' => 'Laporan Praktikum 1',
            'score' => 78,
            'max_score' => 100,
        ]);

        Grade::create([
            'student_id' => $students[1]->id,
            'course_id' => $courses[0]->id,
            'teacher_id' => $teacher1->id,
            'type' => 'assignment',
            'name' => 'PR 1 - Sistem Persamaan',
            'score' => 92,
            'max_score' => 100,
        ]);

        Grade::create([
            'student_id' => $students[1]->id,
            'course_id' => $courses[0]->id,
            'teacher_id' => $teacher1->id,
            'type' => 'midterm',
            'name' => 'UTS Matematika',
            'score' => 88,
            'max_score' => 100,
        ]);
    }
}
