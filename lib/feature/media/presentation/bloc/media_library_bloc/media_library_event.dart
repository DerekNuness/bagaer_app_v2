part of 'media_library_bloc.dart';

sealed class MediaLibraryEvent extends Equatable {
  const MediaLibraryEvent();

  @override
  List<Object> get props => [];
}

/// Carrega mídias salvas no SQLite
class LoadMediaLibrary extends MediaLibraryEvent {
  const LoadMediaLibrary();
}

/// Remove mídia do SQLite
class DeleteMediaRequested extends MediaLibraryEvent {
  final int id;

  const DeleteMediaRequested(this.id);

  @override
  List<Object> get props => [id];
}
