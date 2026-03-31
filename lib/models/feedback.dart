enum FeedbackStatus { pending, inReview, resolved, rejected }

enum FeedbackPriority { low, medium, high, critical }

class QAFeedback {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final FeedbackStatus status;
  final FeedbackPriority priority;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? screenshotUrl;
  final String? response;
  final String submittedBy;

  QAFeedback({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.resolvedAt,
    this.screenshotUrl,
    this.response,
    required this.submittedBy,
  });

  String get statusText {
    switch (status) {
      case FeedbackStatus.pending:
        return 'Pending';
      case FeedbackStatus.inReview:
        return 'In Review';
      case FeedbackStatus.resolved:
        return 'Resolved';
      case FeedbackStatus.rejected:
        return 'Rejected';
    }
  }

  String get priorityText {
    switch (priority) {
      case FeedbackPriority.low:
        return 'Low';
      case FeedbackPriority.medium:
        return 'Medium';
      case FeedbackPriority.high:
        return 'High';
      case FeedbackPriority.critical:
        return 'Critical';
    }
  }
}