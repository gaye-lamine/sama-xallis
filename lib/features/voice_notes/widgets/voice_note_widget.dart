import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_text_styles.dart';
import '../../../core/widgets/app_feedback.dart';
import '../models/voice_note.dart';
import '../providers/voice_note_provider.dart';

class VoiceNoteWidget extends ConsumerStatefulWidget {
  final String entityType;
  final String entityId;

  const VoiceNoteWidget({super.key, required this.entityType, required this.entityId});

  @override
  ConsumerState<VoiceNoteWidget> createState() => _VoiceNoteWidgetState();
}

class _VoiceNoteWidgetState extends ConsumerState<VoiceNoteWidget> {
  final _recorder = AudioRecorder();
  bool _recording = false;
  bool _uploading = false;
  int _seconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final ok = await _recorder.hasPermission();
    if (!ok) {
      if (mounted) AppFeedback.error(context, 'Permission micro refusée');
      return;
    }
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/note_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(const RecordConfig(), path: path);
    setState(() { _recording = true; _seconds = 0; });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _seconds++));
  }

  Future<void> _stopAndUpload() async {
    _timer?.cancel();
    final path = await _recorder.stop();
    setState(() { _recording = false; _uploading = true; });
    if (path == null) { setState(() => _uploading = false); return; }
    try {
      await ref.read(voiceNoteServiceProvider).upload(
        filePath: path,
        entityType: widget.entityType,
        entityId: widget.entityId,
        duration: _seconds,
      );
      ref.invalidate(voiceNotesProvider((entityType: widget.entityType, entityId: widget.entityId)));
      if (mounted) AppFeedback.success(context, 'Note vocale enregistrée');
    } catch (_) {
      if (mounted) AppFeedback.error(context, 'Erreur lors de l\'envoi');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  void _cancel() {
    _timer?.cancel();
    _recorder.stop();
    setState(() { _recording = false; _seconds = 0; });
  }

  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(voiceNotesProvider(
        (entityType: widget.entityType, entityId: widget.entityId)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.mic_outlined, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.xs),
            const Text('Notes vocales', style: AppTextStyles.small),
            const Spacer(),
            if (_recording) ...[
              Text(_fmt(_seconds),
                  style: const TextStyle(color: AppColors.danger, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(width: AppSpacing.sm),
              _Btn(icon: Icons.stop, color: AppColors.danger, onTap: _stopAndUpload),
              const SizedBox(width: AppSpacing.xs),
              _Btn(icon: Icons.close, color: AppColors.textSecondary, onTap: _cancel),
            ] else if (_uploading)
              const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
            else
              _Btn(icon: Icons.mic, color: AppColors.primary, onTap: _start),
          ],
        ),
        if (_recording) ...[
          const SizedBox(height: AppSpacing.xs),
          _Pulse(seconds: _seconds),
        ],
        notes.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (list) => list.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    ...list.map((n) => _NoteRow(
                          note: n,
                          onDelete: () async {
                            await ref.read(voiceNoteServiceProvider).delete(n.id);
                            ref.invalidate(voiceNotesProvider((
                                entityType: widget.entityType,
                                entityId: widget.entityId)));
                          },
                        )),
                  ],
                ),
        ),
      ],
    );
  }
}

class _Pulse extends StatefulWidget {
  final int seconds;
  const _Pulse({required this.seconds});

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Container(
          width: 8, height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.danger.withOpacity(0.4 + 0.6 * _ctrl.value),
          ),
        ),
      ),
      const SizedBox(width: AppSpacing.xs),
      const Text('Enregistrement...', style: TextStyle(color: AppColors.danger, fontSize: 12)),
    ]);
  }
}

class _NoteRow extends StatefulWidget {
  final VoiceNote note;
  final VoidCallback onDelete;
  const _NoteRow({required this.note, required this.onDelete});

  @override
  State<_NoteRow> createState() => _NoteRowState();
}

class _NoteRowState extends State<_NoteRow> {
  final _player = AudioPlayer();
  bool _playing = false;

  @override
  void dispose() { _player.dispose(); super.dispose(); }

  Future<void> _toggle() async {
    if (_playing) {
      await _player.stop();
      setState(() => _playing = false);
    } else {
      await _player.setUrl(widget.note.audioUrl);
      setState(() => _playing = true);
      await _player.play();
      if (mounted) setState(() => _playing = false);
    }
  }

  String _fmt(int? s) {
    if (s == null) return '';
    return '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Row(children: [
        GestureDetector(
          onTap: _toggle,
          child: Container(
            width: 34, height: 34,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: Icon(_playing ? Icons.stop : Icons.play_arrow, color: Colors.white, size: 18),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Note vocale', style: AppTextStyles.small.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
            if (widget.note.duration != null)
              Text(_fmt(widget.note.duration), style: AppTextStyles.small),
          ],
        )),
        GestureDetector(
          onTap: widget.onDelete,
          child: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger),
        ),
      ]),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _Btn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
