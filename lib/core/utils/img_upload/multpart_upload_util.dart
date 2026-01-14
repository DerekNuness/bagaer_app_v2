import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';

Future<MultipartFile> multipartFromAnyPath(String path) async {
  final isAsset = path.startsWith('assets/');

  final filename = path.split('/').last;
  final ext = filename.contains('.') ? filename.split('.').last.toLowerCase() : '';
  final mediaType = _mediaTypeFromExt(ext);

  if (isAsset) {
    final byteData = await rootBundle.load(path);
    final Uint8List bytes = byteData.buffer.asUint8List();

    return MultipartFile.fromBytes(
      bytes,
      filename: filename,
      contentType: mediaType,
    );
  }

  final file = File(path);
  final exists = await file.exists();
  if (!exists) {
    throw Exception('File not found: $path');
  }

  return MultipartFile.fromFile(
    path,
    filename: filename,
    contentType: mediaType,
  );
}

MediaType _mediaTypeFromExt(String ext) {
  switch (ext) {
    case 'png':
      return MediaType('image', 'png');
    case 'webp':
      return MediaType('image', 'webp');
    case 'heic':
      return MediaType('image', 'heic');
    case 'jpeg':
    case 'jpg':
    default:
      return MediaType('image', 'jpeg');
  }
}