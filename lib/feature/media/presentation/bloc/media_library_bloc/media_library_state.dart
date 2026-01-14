part of 'media_library_bloc.dart';

sealed class MediaLibraryState extends Equatable {
  const MediaLibraryState();
  
  @override
  List<Object> get props => [];
}

class MediaLibraryInitial extends MediaLibraryState {
  const MediaLibraryInitial();
}

class MediaLibraryLoading extends MediaLibraryState {
  const MediaLibraryLoading();
}

class MediaLibraryLoaded extends MediaLibraryState {
  final List<MediaItem> items;

  const MediaLibraryLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class MediaLibraryError extends MediaLibraryState {
  final String message;

  const MediaLibraryError(this.message);

  @override
  List<Object> get props => [message];
}