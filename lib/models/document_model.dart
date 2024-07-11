import 'package:pirmanent_client/models/user_model.dart';

class Document {
  final String title;
  final String description;
  final String uploadedDigitalSignature;
  final String? signedDigitalSignature;
  final User uploader;
  final User signer;
  final DocumentStatus status;
  final DateTime dateUploaded;
  final DateTime? dateSigned;
  final String docId;
  final bool? isVerified;

  Document({
    required this.uploadedDigitalSignature,
    this.signedDigitalSignature,
    required this.docId,
    required this.title,
    required this.description,
    required this.status,
    required this.uploader,
    required this.signer,
    required this.dateUploaded,
    this.dateSigned,
    this.isVerified,
  });
}

enum DocumentStatus { waiting, signed, cancelled }
