<?php

namespace App\Filament\Resources;

use App\Filament\Resources\GradeResource\Pages;
use App\Models\Grade;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class GradeResource extends Resource
{
    protected static ?string $model = Grade::class;

    protected static ?string $navigationIcon = 'heroicon-o-academic-cap';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Select::make('student_id')
                    ->label('Student')
                    ->relationship('student', 'name')
                    ->searchable()
                    ->preload()
                    ->required(),
                Forms\Components\Select::make('course_id')
                    ->label('Course')
                    ->relationship('course', 'name')
                    ->searchable()
                    ->preload()
                    ->required(),
                Forms\Components\Hidden::make('teacher_id')
                    ->default(fn() => auth()->id()),
                Forms\Components\Select::make('type')
                    ->options([
                        'assignment' => 'Assignment',
                        'quiz' => 'Quiz',
                        'midterm' => 'Midterm',
                        'final' => 'Final',
                    ])
                    ->required(),
                Forms\Components\TextInput::make('name')
                    ->required()
                    ->maxLength(255),
                Forms\Components\TextInput::make('score')
                    ->numeric()
                    ->required()
                    ->minValue(0),
                Forms\Components\TextInput::make('max_score')
                    ->numeric()
                    ->required()
                    ->minValue(0)
                    ->default(100),
                Forms\Components\Textarea::make('note')
                    ->maxLength(65535),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('student.name')
                    ->label('Student')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('course.name')
                    ->label('Course')
                    ->sortable(),
                Tables\Columns\TextColumn::make('type')
                    ->badge()
                    ->sortable(),
                Tables\Columns\TextColumn::make('name')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('score')
                    ->sortable(),
                Tables\Columns\TextColumn::make('max_score')
                    ->label('Max')
                    ->sortable(),
                Tables\Columns\TextColumn::make('teacher.name')
                    ->label('Teacher')
                    ->toggleable(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('type')
                    ->options([
                        'assignment' => 'Assignment',
                        'quiz' => 'Quiz',
                        'midterm' => 'Midterm',
                        'final' => 'Final',
                    ]),
                Tables\Filters\SelectFilter::make('course_id')
                    ->label('Course')
                    ->relationship('course', 'name'),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getRelations(): array
    {
        return [];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListGrades::route('/'),
            'create' => Pages\CreateGrade::route('/create'),
            'edit' => Pages\EditGrade::route('/{record}/edit'),
        ];
    }
}
