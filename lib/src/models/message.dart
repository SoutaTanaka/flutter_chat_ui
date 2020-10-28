import 'package:meta/meta.dart';
import 'package:flutter_chat_ui/src/utils.dart';

enum MessageType {
  image,
  text,
}

enum Status { error, read, sending, sent }

@immutable
abstract class MessageModel {
  const MessageModel(
    this.authorId,
    this.id,
    this.status,
    this.timestamp,
    this.type,
  )   : assert(authorId != null),
        assert(id != null),
        assert(timestamp != null),
        assert(type != null);

  final String authorId;
  final String id;
  final Status status;
  final int timestamp;
  final MessageType type;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final String type = json['type'];

    switch (type) {
      case 'image':
        return ImageMessageModel.fromJson(json);
      case 'text':
        return TextMessageModel.fromJson(json);
      default:
        return null;
    }
  }
}

@immutable
class ImageMessageModel extends MessageModel {
  const ImageMessageModel({
    @required String authorId,
    this.height,
    @required String id,
    @required this.imageName,
    @required this.size,
    Status status,
    @required int timestamp,
    @required this.url,
    this.width,
  })  : assert(imageName != null),
        assert(size != null),
        assert(url != null),
        super(authorId, id, status, timestamp, MessageType.text);

  final double height;
  final String imageName;
  final int size;
  final String url;
  final double width;

  ImageMessageModel.fromJson(Map<String, dynamic> json)
      : height = json['height']?.toDouble(),
        imageName = json['imageName'],
        size = json['size'],
        url = json['url'],
        width = json['width']?.toDouble(),
        super(
          json['authorId'],
          json['id'],
          getStatusFromString(json['status']),
          json['timestamp'],
          MessageType.image,
        );
}

@immutable
class TextMessageModel extends MessageModel {
  const TextMessageModel({
    @required String authorId,
    @required String id,
    Status status,
    @required this.text,
    @required int timestamp,
  })  : assert(text != null),
        super(authorId, id, status, timestamp, MessageType.text);

  final String text;

  TextMessageModel.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        super(
          json['authorId'],
          json['id'],
          getStatusFromString(json['status']),
          json['timestamp'],
          MessageType.text,
        );
}