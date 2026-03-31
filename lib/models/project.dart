import 'feedback.dart';

enum ProjectStatus { inProgress, review, completed, onHold }

class Project {
  final String id;
  final String name;
  final String description;
  final ProjectStatus status;
  final double progress;
  final DateTime startDate;
  final DateTime? estimatedEndDate;
  final String clientName;
  final String projectManager;
  final List<ProjectMilestone> milestones;
  final List<QAFeedback> feedbacks;
  final List<APKVersion> apkVersions;
  final String imageUrl;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.progress,
    required this.startDate,
    this.estimatedEndDate,
    required this.clientName,
    required this.projectManager,
    required this.milestones,
    required this.feedbacks,
    required this.apkVersions,
    required this.imageUrl,
  });

  String get statusText {
    switch (status) {
      case ProjectStatus.inProgress:
        return 'In Progress';
      case ProjectStatus.review:
        return 'Under Review';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.onHold:
        return 'On Hold';
    }
  }
}

class ProjectMilestone {
  final String id;
  final String title;
  final String description;
  final DateTime? completedDate;
  final bool isCompleted;
  final int order;

  ProjectMilestone({
    required this.id,
    required this.title,
    required this.description,
    this.completedDate,
    required this.isCompleted,
    required this.order,
  });
}

class APKVersion {
  final String id;
  final String version;
  final String downloadUrl;
  final DateTime releaseDate;
  final String releaseNotes;
  final int fileSize;

  APKVersion({
    required this.id,
    required this.version,
    required this.downloadUrl,
    required this.releaseDate,
    required this.releaseNotes,
    required this.fileSize,
  });

  String get fileSizeFormatted {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}