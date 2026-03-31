import 'package:dio/dio.dart';
import '../models/voice_note.dart';

class VoiceNoteService {
  final Dio _dio;
  const VoiceNoteService(this._dio);

  Future<List<VoiceNote>> getNotes(String entityType, String entityId) async {
    final response = await _dio.get('/api/voice-notes', queryParameters: {
      'entityType': entityType,
      'entityId': entityId,
    });
    return (response.data as List).map((e) => VoiceNote.fromJson(e)).toList();
  }

  Future<VoiceNote> upload({
    required String filePath,
    required String entityType,
    required String entityId,
    int? duration,
  }) async {
    final formData = FormData.fromMap({
      'audio': await MultipartFile.fromFile(filePath, filename: 'note.m4a'),
      'entityType': entityType,
      'entityId': entityId,
      if (duration != null) 'duration': duration,
    });
    final response = await _dio.post('/api/voice-notes', data: formData);
    return VoiceNote.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    await _dio.delete('/api/voice-notes/$id');
  }
}
