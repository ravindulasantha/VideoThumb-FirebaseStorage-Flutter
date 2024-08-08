import 'package:firebase_storage/firebase_storage.dart';
import 'package:thumtest/workout.dart';

class WorkoutService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Workout>> fetchWorkouts() async {
    List<Workout> workouts = [];

    // Assume you have a predefined list of workout titles
    List<String> workoutTitles = ['Barbell Wrist Extension On Knees', 'Bodyweight Single Leg Deadlift', 'Workout3'];

    for (String title in workoutTitles) {
      String thumbnailUrl = await _storage.ref('thumbnails/$title.png').getDownloadURL();
      String videoUrl = await _storage.ref('videos/$title.mp4').getDownloadURL();

      workouts.add(Workout(title: title, thumbnailUrl: thumbnailUrl, videoUrl: videoUrl));
    }

    return workouts;
  }
}
