// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutResultModel _$WorkoutResultModelFromJson(Map<String, dynamic> json) =>
    WorkoutResultModel(
      workoutScheduleId: json['workoutScheduleId'] as int,
      userId: json['userId'] as int,
      startDate: json['startDate'] as String,
      workoutTitle: json['workoutTitle'] as String,
      workoutSubTitle: json['workoutSubTitle'] as String,
      targetMuscleTypes: (json['targetMuscleTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      workoutTotalTime: json['workoutTotalTime'] as String?,
      isWorkoutComplete: json['isWorkoutComplete'] as bool,
      heartRates:
          (json['heartRates'] as List<dynamic>?)?.map((e) => e as int).toList(),
      calories: json['calories'] as int?,
      workoutDuration: json['workoutDuration'] as int?,
      strengthIndex: json['strengthIndex'] as int?,
      issueIndexes: (json['issueIndexes'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      contents: json['contents'] as String?,
      trainerNickname: json['trainerNickname'] as String,
      seq: json['seq'] as int,
      trainerProfileImage: json['trainerProfileImage'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      workoutSchedules: (json['workoutSchedules'] as List<dynamic>?)
          ?.map((e) => WorkoutData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutResultModelToJson(WorkoutResultModel instance) =>
    <String, dynamic>{
      'workoutScheduleId': instance.workoutScheduleId,
      'userId': instance.userId,
      'startDate': instance.startDate,
      'workoutTitle': instance.workoutTitle,
      'workoutSubTitle': instance.workoutSubTitle,
      'targetMuscleTypes': instance.targetMuscleTypes,
      'workoutTotalTime': instance.workoutTotalTime,
      'isWorkoutComplete': instance.isWorkoutComplete,
      'heartRates': instance.heartRates,
      'workoutDuration': instance.workoutDuration,
      'calories': instance.calories,
      'strengthIndex': instance.strengthIndex,
      'issueIndexes': instance.issueIndexes,
      'contents': instance.contents,
      'trainerNickname': instance.trainerNickname,
      'seq': instance.seq,
      'trainerProfileImage': instance.trainerProfileImage,
      'exercises': instance.exercises,
      'workoutSchedules': instance.workoutSchedules,
    };

Exercise _$ExerciseFromJson(Map<String, dynamic> json) => Exercise(
      workoutPlanId: json['workoutPlanId'] as int,
      exerciseId: json['exerciseId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      trackingFieldId: json['trackingFieldId'] as int,
      circuitGroupNum: json['circuitGroupNum'] as int?,
      setType: json['setType'] as String?,
      circuitSeq: json['circuitSeq'] as int?,
      isVideoRecord: json['isVideoRecord'] as bool?,
      targetMuscles: (json['targetMuscles'] as List<dynamic>)
          .map((e) => TargetMuscle.fromJson(e as Map<String, dynamic>))
          .toList(),
      videos: (json['videos'] as List<dynamic>)
          .map((e) => Video.fromJson(e as Map<String, dynamic>))
          .toList(),
      setInfo: (json['setInfo'] as List<dynamic>)
          .map((e) => SetInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      recordSetInfo: (json['recordSetInfo'] as List<dynamic>)
          .map((e) => SetInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'workoutPlanId': instance.workoutPlanId,
      'exerciseId': instance.exerciseId,
      'name': instance.name,
      'description': instance.description,
      'trackingFieldId': instance.trackingFieldId,
      'circuitGroupNum': instance.circuitGroupNum,
      'setType': instance.setType,
      'circuitSeq': instance.circuitSeq,
      'isVideoRecord': instance.isVideoRecord,
      'targetMuscles': instance.targetMuscles,
      'videos': instance.videos,
      'setInfo': instance.setInfo,
      'recordSetInfo': instance.recordSetInfo,
    };

SetInfo _$SetInfoFromJson(Map<String, dynamic> json) => SetInfo(
      index: json['index'] as int,
      reps: json['reps'] as int?,
      weight: json['weight'] as int?,
      seconds: json['seconds'] as int?,
    );

Map<String, dynamic> _$SetInfoToJson(SetInfo instance) => <String, dynamic>{
      'index': instance.index,
      'reps': instance.reps,
      'weight': instance.weight,
      'seconds': instance.seconds,
    };

TargetMuscle _$TargetMuscleFromJson(Map<String, dynamic> json) => TargetMuscle(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$TargetMuscleToJson(TargetMuscle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
    };

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      url: json['url'] as String,
      index: json['index'] as int,
      thumbnail: json['thumbnail'] as String,
    );

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'url': instance.url,
      'index': instance.index,
      'thumbnail': instance.thumbnail,
    };
