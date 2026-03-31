class VoiceNote {
  final int id;
  final String entityType;
  final String entityId;
  final String audioUrl;
  final int? duration;
  final String createdAt;

  const VoiceNote({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.audioUrl,
    this.duration,
    required this.createdAt,
  });

  factory VoiceNote.fromJson(Map<String, dynamic> json) => VoiceNote(
        id: (json['id'] as num).toInt(),
        entityType: json['entityType'] as String,
        entityId: json['entityId'].toString(),
        audioUrl: json['audioUrl'] as String,
        duration: json['duration'] != null ? (json['duration'] as num).toInt() : null,
        createdAt: json['createdAt'] as String,
      );
}
