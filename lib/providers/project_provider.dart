import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/feedback.dart';
import '../services/data_service.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  List<Project> _filteredProjects = [];
  bool _isLoading = false;
  String _searchQuery = '';
  ProjectStatus? _statusFilter;
  String? _errorMessage;

  List<Project> get projects => _filteredProjects.isEmpty && _searchQuery.isEmpty && _statusFilter == null
      ? _projects
      : _filteredProjects;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  ProjectStatus? get statusFilter => _statusFilter;
  String? get errorMessage => _errorMessage;

  List<APKVersion> get latestAPKs => DataService.getAllLatestAPKs();

  List<QAFeedback> get recentFeedbacks {
    List<QAFeedback> allFeedbacks = [];
    for (var project in _projects) {
      allFeedbacks.addAll(project.feedbacks);
    }
    allFeedbacks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return allFeedbacks.take(5).toList();
  }

  Future<void> loadProjects() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      _projects = DataService.getMockProjects();
      _applyFilters();
    } catch (e) {
      _errorMessage = 'Failed to load projects. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchProjects(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByStatus(ProjectStatus? status) {
    _statusFilter = status;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProjects = _projects.where((project) {
      bool matchesSearch = _searchQuery.isEmpty ||
          project.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          project.description.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesStatus = _statusFilter == null || project.status == _statusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = null;
    _filteredProjects = [];
    notifyListeners();
  }

  Future<bool> submitFeedback({
    required String projectId,
    required String title,
    required String description,
    required FeedbackPriority priority,
    String? screenshotPath,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final projectIndex = _projects.indexWhere((p) => p.id == projectId);
    if (projectIndex == -1) return false;

    final newFeedback = QAFeedback(
      id: 'fb_${DateTime.now().millisecondsSinceEpoch}',
      projectId: projectId,
      title: title,
      description: description,
      status: FeedbackStatus.pending,
      priority: priority,
      createdAt: DateTime.now(),
      submittedBy: 'John Anderson',
      screenshotUrl: screenshotPath != null
          ? 'https://images.unsplash.com/photo-1555421689-d68471e189f2?w=400'
          : null,
    );

    final project = _projects[projectIndex];
    final updatedFeedbacks = List<QAFeedback>.from(project.feedbacks)..add(newFeedback);

    _projects[projectIndex] = Project(
      id: project.id,
      name: project.name,
      description: project.description,
      status: project.status,
      progress: project.progress,
      startDate: project.startDate,
      estimatedEndDate: project.estimatedEndDate,
      clientName: project.clientName,
      projectManager: project.projectManager,
      milestones: project.milestones,
      feedbacks: updatedFeedbacks,
      apkVersions: project.apkVersions,
      imageUrl: project.imageUrl,
    );

    _applyFilters();
    notifyListeners();
    return true;
  }

  Future<bool> requestUpdate(String projectId, String message) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}