import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/repository_providers.dart';
import '../models/voice_note.dart';
import '../services/voice_note_service.dart';

final voiceNoteServiceProvider = Provider<VoiceNoteService>(
  (ref) => VoiceNoteService(ref.watch(dioProvider)),
);

final voiceNotesProvider =
    FutureProvider.family<List<VoiceNote>, ({String entityType, String entityId})>(
  (ref, params) => ref
      .watch(voiceNoteServiceProvider)
      .getNotes(params.entityType, params.entityId),
);
