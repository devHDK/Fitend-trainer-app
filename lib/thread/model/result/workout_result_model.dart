import 'package:fitend_trainer_app/thread/model/result/workout_list_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workout_result_model.g.dart';

abstract class WorkoutResultModelBase {}

class WorkoutResultModelError extends WorkoutResultModelBase {
  final String message;

  WorkoutResultModelError({
    required this.message,
  });
}

class WorkoutResultModelLoading extends WorkoutResultModelBase {}

@JsonSerializable()
class WorkoutResultModel extends WorkoutResultModelBase {
  @JsonKey(name: "workoutScheduleId")
  final int workoutScheduleId;
  @JsonKey(name: "userId")
  final int userId;
  @JsonKey(name: "startDate")
  final String startDate;
  @JsonKey(name: "workoutTitle")
  final String workoutTitle;
  @JsonKey(name: "workoutSubTitle")
  final String workoutSubTitle;
  @JsonKey(name: "targetMuscleTypes")
  final List<String> targetMuscleTypes;
  @JsonKey(name: "workoutTotalTime")
  String? workoutTotalTime;
  @JsonKey(name: "isWorkoutComplete")
  final bool isWorkoutComplete;
  @JsonKey(name: "heartRates")
  List<int>? heartRates;
  @JsonKey(name: "workoutDuration")
  int? workoutDuration;
  @JsonKey(name: "calories")
  int? calories;
  @JsonKey(name: "strengthIndex")
  int? strengthIndex;
  @JsonKey(name: "issueIndexes")
  List<int>? issueIndexes;
  @JsonKey(name: "contents")
  String? contents;
  @JsonKey(name: "trainerNickname")
  final String trainerNickname;
  @JsonKey(name: "seq")
  final int seq;
  @JsonKey(name: "trainerProfileImage")
  final String trainerProfileImage;
  @JsonKey(name: "exercises")
  final List<Exercise> exercises;
  List<WorkoutData>? workoutSchedules;

  WorkoutResultModel({
    required this.workoutScheduleId,
    required this.userId,
    required this.startDate,
    required this.workoutTitle,
    required this.workoutSubTitle,
    required this.targetMuscleTypes,
    required this.workoutTotalTime,
    required this.isWorkoutComplete,
    this.heartRates,
    this.calories,
    this.workoutDuration,
    this.strengthIndex,
    this.issueIndexes,
    this.contents,
    required this.trainerNickname,
    required this.seq,
    required this.trainerProfileImage,
    required this.exercises,
    this.workoutSchedules,
  });

  WorkoutResultModel copyWith({
    int? workoutScheduleId,
    int? userId,
    String? startDate,
    String? workoutTitle,
    String? workoutSubTitle,
    List<String>? targetMuscleTypes,
    String? workoutTotalTime,
    bool? isWorkoutComplete,
    List<int>? heartRates,
    int? workoutDuration,
    int? strengthIndex,
    List<int>? issueIndexes,
    String? contents,
    String? trainerNickname,
    int? seq,
    String? trainerProfileImage,
    List<Exercise>? exercises,
    List<WorkoutData>? workoutSchedules,
  }) =>
      WorkoutResultModel(
        workoutScheduleId: workoutScheduleId ?? this.workoutScheduleId,
        userId: userId ?? this.userId,
        startDate: startDate ?? this.startDate,
        workoutTitle: workoutTitle ?? this.workoutTitle,
        workoutSubTitle: workoutSubTitle ?? this.workoutSubTitle,
        targetMuscleTypes: targetMuscleTypes ?? this.targetMuscleTypes,
        workoutTotalTime: workoutTotalTime ?? this.workoutTotalTime,
        isWorkoutComplete: isWorkoutComplete ?? this.isWorkoutComplete,
        heartRates: heartRates ?? this.heartRates,
        workoutDuration: workoutDuration ?? this.workoutDuration,
        strengthIndex: strengthIndex ?? this.strengthIndex,
        issueIndexes: issueIndexes ?? this.issueIndexes,
        contents: contents ?? this.contents,
        trainerNickname: trainerNickname ?? this.trainerNickname,
        seq: seq ?? this.seq,
        trainerProfileImage: trainerProfileImage ?? this.trainerProfileImage,
        exercises: exercises ?? this.exercises,
        workoutSchedules: workoutSchedules ?? this.workoutSchedules,
      );

  factory WorkoutResultModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutResultModelToJson(this);
}

@JsonSerializable()
class Exercise {
  @JsonKey(name: "workoutPlanId")
  final int workoutPlanId;
  @JsonKey(name: "exerciseId")
  final int exerciseId;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "description")
  final String description;
  @JsonKey(name: "trackingFieldId")
  final int trackingFieldId;
  @JsonKey(name: "circuitGroupNum")
  int? circuitGroupNum;
  @JsonKey(name: "setType")
  String? setType;
  @JsonKey(name: "circuitSeq")
  int? circuitSeq;
  @JsonKey(name: "isVideoRecord")
  bool? isVideoRecord;
  @JsonKey(name: "targetMuscles")
  final List<TargetMuscle> targetMuscles;
  @JsonKey(name: "videos")
  final List<Video> videos;
  @JsonKey(name: "setInfo")
  final List<SetInfo> setInfo;
  @JsonKey(name: "recordSetInfo")
  final List<SetInfo> recordSetInfo;

  Exercise({
    required this.workoutPlanId,
    required this.exerciseId,
    required this.name,
    required this.description,
    required this.trackingFieldId,
    this.circuitGroupNum,
    this.setType,
    this.circuitSeq,
    this.isVideoRecord,
    required this.targetMuscles,
    required this.videos,
    required this.setInfo,
    required this.recordSetInfo,
  });

  Exercise copyWith({
    int? workoutPlanId,
    int? exerciseId,
    String? name,
    String? description,
    int? trackingFieldId,
    int? circuitGroupNum,
    String? setType,
    int? circuitSeq,
    bool? isVideoRecord,
    List<TargetMuscle>? targetMuscles,
    List<Video>? videos,
    List<SetInfo>? setInfo,
    List<SetInfo>? recordSetInfo,
  }) =>
      Exercise(
        workoutPlanId: workoutPlanId ?? this.workoutPlanId,
        exerciseId: exerciseId ?? this.exerciseId,
        name: name ?? this.name,
        description: description ?? this.description,
        trackingFieldId: trackingFieldId ?? this.trackingFieldId,
        circuitGroupNum: circuitGroupNum ?? this.circuitGroupNum,
        setType: setType ?? this.setType,
        circuitSeq: circuitSeq ?? this.circuitSeq,
        isVideoRecord: isVideoRecord ?? this.isVideoRecord,
        targetMuscles: targetMuscles ?? this.targetMuscles,
        videos: videos ?? this.videos,
        setInfo: setInfo ?? this.setInfo,
        recordSetInfo: recordSetInfo ?? this.recordSetInfo,
      );

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);
}

@JsonSerializable()
class SetInfo {
  @JsonKey(name: "index")
  final int index;
  @JsonKey(name: "reps")
  int? reps;
  @JsonKey(name: "weight")
  int? weight;
  @JsonKey(name: "seconds")
  int? seconds;

  SetInfo({
    required this.index,
    this.reps,
    this.weight,
    this.seconds,
  });

  SetInfo copyWith({
    int? index,
    int? reps,
    int? weight,
    int? seconds,
  }) =>
      SetInfo(
        index: index ?? this.index,
        reps: reps ?? this.reps,
        weight: weight ?? this.weight,
        seconds: seconds ?? this.seconds,
      );

  factory SetInfo.fromJson(Map<String, dynamic> json) =>
      _$SetInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SetInfoToJson(this);
}

@JsonSerializable()
class TargetMuscle {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "type")
  final String type;

  TargetMuscle({
    required this.id,
    required this.name,
    required this.type,
  });

  TargetMuscle copyWith({
    int? id,
    String? name,
    String? type,
  }) =>
      TargetMuscle(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
      );

  factory TargetMuscle.fromJson(Map<String, dynamic> json) =>
      _$TargetMuscleFromJson(json);

  Map<String, dynamic> toJson() => _$TargetMuscleToJson(this);
}

@JsonSerializable()
class Video {
  @JsonKey(name: "url")
  final String url;
  @JsonKey(name: "index")
  final int index;
  @JsonKey(name: "thumbnail")
  final String thumbnail;

  Video({
    required this.url,
    required this.index,
    required this.thumbnail,
  });

  Video copyWith({
    String? url,
    int? index,
    String? thumbnail,
  }) =>
      Video(
        url: url ?? this.url,
        index: index ?? this.index,
        thumbnail: thumbnail ?? this.thumbnail,
      );

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}
