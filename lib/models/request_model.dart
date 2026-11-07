import 'package:flutter/material.dart';

enum RequestStatus {
  awaitingReview,
  inProgress,
  assigned,
  resolved,
}

class RequestModel {
  final String id;
  final String code;
  final String title;
  final String location;
  final String timeAgo;
  final RequestStatus status;
  final IconData icon;

  const RequestModel({
    required this.id,
    required this.code,
    required this.title,
    required this.location,
    required this.timeAgo,
    required this.status,
    required this.icon,
  });

  String get statusLabel {
    switch (status) {
      case RequestStatus.awaitingReview:
        return 'Awaiting review';
      case RequestStatus.inProgress:
        return 'In progress';
      case RequestStatus.assigned:
        return 'Assigned';
      case RequestStatus.resolved:
        return 'Resolved';
    }
  }

  Color get statusBackgroundColor {
    switch (status) {
      case RequestStatus.awaitingReview:
        return const Color(0xFFFDF3E7);
      case RequestStatus.inProgress:
        return const Color(0xFFEAF2F8);
      case RequestStatus.assigned:
        return const Color(0xFFF2EFFB);
      case RequestStatus.resolved:
        return const Color(0xFFE8F5EE);
    }
  }

  Color get statusTextColor {
    switch (status) {
      case RequestStatus.awaitingReview:
        return const Color(0xFFB8722E);
      case RequestStatus.inProgress:
        return const Color(0xFF3B739E);
      case RequestStatus.assigned:
        return const Color(0xFF6B54A6);
      case RequestStatus.resolved:
        return const Color(0xFF2E7D5B);
    }
  }
}
