import 'package:flutter/material.dart';
import '../models/request_model.dart';

abstract class RequestService {
  Future<List<RequestModel>> getRecentRequests();
  Future<Map<String, int>> getRequestMetrics();
}

class RequestServiceImpl implements RequestService {
  static const List<RequestModel> _mockRequests = [
    RequestModel(
      id: '1',
      code: 'MR-2481',
      title: 'Air conditioner not cooling',
      location: 'Finance · Floor 3',
      timeAgo: '12 min ago',
      status: RequestStatus.awaitingReview,
      icon: Icons.ac_unit_rounded,
    ),
    RequestModel(
      id: '2',
      code: 'MR-2480',
      title: 'Strange noise from elevator',
      location: 'Main lobby · Elevator 2',
      timeAgo: '38 min ago',
      status: RequestStatus.inProgress,
      icon: Icons.apartment_rounded,
    ),
    RequestModel(
      id: '3',
      code: 'MR-2479',
      title: 'Flickering meeting room lights',
      location: 'Operations · Room 204',
      timeAgo: '1 hr ago',
      status: RequestStatus.assigned,
      icon: Icons.lightbulb_outline_rounded,
    ),
  ];

  @override
  Future<List<RequestModel>> getRecentRequests() async {
    return List.unmodifiable(_mockRequests);
  }

  @override
  Future<Map<String, int>> getRequestMetrics() async {
    return {
      'open': 3,
      'inProgress': 1,
      'resolved': 8,
    };
  }
}
