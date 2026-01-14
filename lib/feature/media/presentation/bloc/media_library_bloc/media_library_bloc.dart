import 'package:bagaer/feature/media/domain/entities/media_item.dart';
import 'package:bagaer/feature/media/domain/usecases/delete_media.dart';
import 'package:bagaer/feature/media/domain/usecases/list_media.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'media_library_event.dart';
part 'media_library_state.dart';

class MediaLibraryBloc extends Bloc<MediaLibraryEvent, MediaLibraryState> {
  final ListMedia listMedia;
  final DeleteMedia deleteMedia;

  MediaLibraryBloc({
    required this.listMedia,
    required this.deleteMedia,
  }) : super(MediaLibraryInitial()) {
    on<LoadMediaLibrary>(_onLoad);
    on<DeleteMediaRequested>(_onDelete);
  }

  Future<void> _onLoad(LoadMediaLibrary event, Emitter<MediaLibraryState> emit,) async {
    try {
      emit(const MediaLibraryLoading());
      final items = await listMedia();
      emit(MediaLibraryLoaded(items));
    } catch (e) {
      emit(MediaLibraryError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteMediaRequested event, Emitter<MediaLibraryState> emit,) async {
    try {
      await deleteMedia(event.id);
      final items = await listMedia();
      emit(MediaLibraryLoaded(items));
    } catch (e) {
      emit(MediaLibraryError(e.toString()));
    }
  }
}
