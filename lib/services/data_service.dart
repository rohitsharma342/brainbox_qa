import '../models/project.dart';
import '../models/feedback.dart';
import '../models/notification.dart';
import '../models/user.dart';
import '../models/payment.dart';

class DataService {
  static User getMockUser() {
    return User(
      id: 'user_001',
      name: 'John Anderson',
      email: 'john.anderson@techcorp.com',
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      company: 'TechCorp Solutions',
      emailNotifications: true,
      pushNotifications: true,
      createdAt: DateTime(2024, 1, 15),
    );
  }

  static List<Project> getMockProjects() {
    return [
      Project(
        id: 'proj_001',
        name: 'E-Commerce Mobile App',
        description: 'A comprehensive e-commerce application with advanced features including real-time inventory, payment gateway integration, and personalized recommendations.',
        status: ProjectStatus.inProgress,
        progress: 0.72,
        startDate: DateTime(2024, 2, 1),
        estimatedEndDate: DateTime(2024, 6, 30),
        clientName: 'TechCorp Solutions',
        projectManager: 'Sarah Mitchell',
        imageUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400',
        milestones: [
          ProjectMilestone(
            id: 'ms_001',
            title: 'Project Kickoff',
            description: 'Initial project setup and requirements gathering',
            isCompleted: true,
            completedDate: DateTime(2024, 2, 5),
            order: 1,
          ),
          ProjectMilestone(
            id: 'ms_002',
            title: 'UI/UX Design',
            description: 'Complete design mockups and prototypes',
            isCompleted: true,
            completedDate: DateTime(2024, 2, 28),
            order: 2,
          ),
          ProjectMilestone(
            id: 'ms_003',
            title: 'Core Development',
            description: 'Implementation of core features and functionalities',
            isCompleted: true,
            completedDate: DateTime(2024, 4, 15),
            order: 3,
          ),
          ProjectMilestone(
            id: 'ms_004',
            title: 'API Integration',
            description: 'Backend API integration and testing',
            isCompleted: false,
            order: 4,
          ),
          ProjectMilestone(
            id: 'ms_005',
            title: 'QA Testing',
            description: 'Comprehensive quality assurance testing',
            isCompleted: false,
            order: 5,
          ),
          ProjectMilestone(
            id: 'ms_006',
            title: 'Final Delivery',
            description: 'App store submission and launch',
            isCompleted: false,
            order: 6,
          ),
        ],
        feedbacks: [
          QAFeedback(
            id: 'fb_001',
            projectId: 'proj_001',
            title: 'Cart button not responsive',
            description: 'The add to cart button on the product detail page is not responding on the first tap. Users need to tap twice to add items.',
            status: FeedbackStatus.inReview,
            priority: FeedbackPriority.high,
            createdAt: DateTime(2024, 4, 20),
            submittedBy: 'John Anderson',
            screenshotUrl: 'https://images.unsplash.com/photo-1555421689-d68471e189f2?w=400',
          ),
          QAFeedback(
            id: 'fb_002',
            projectId: 'proj_001',
            title: 'Checkout flow improvement',
            description: 'Consider adding a progress indicator during the checkout process to improve user experience.',
            status: FeedbackStatus.resolved,
            priority: FeedbackPriority.medium,
            createdAt: DateTime(2024, 4, 18),
            resolvedAt: DateTime(2024, 4, 22),
            submittedBy: 'John Anderson',
            response: 'Great suggestion! We have implemented a step indicator in the checkout flow. Please check the latest build.',
          ),
          QAFeedback(
            id: 'fb_003',
            projectId: 'proj_001',
            title: 'Product image loading slow',
            description: 'Product images take too long to load on slower connections. Please optimize image loading.',
            status: FeedbackStatus.pending,
            priority: FeedbackPriority.medium,
            createdAt: DateTime(2024, 4, 25),
            submittedBy: 'John Anderson',
          ),
        ],
        apkVersions: [
          APKVersion(
            id: 'apk_001',
            version: '1.2.0-beta',
            downloadUrl: 'https://example.com/downloads/ecommerce-1.2.0-beta.apk',
            releaseDate: DateTime(2024, 4, 24),
            releaseNotes: 'New features: Wishlist functionality, improved search, bug fixes for cart issues.',
            fileSize: 45000000,
          ),
          APKVersion(
            id: 'apk_002',
            version: '1.1.0-beta',
            downloadUrl: 'https://example.com/downloads/ecommerce-1.1.0-beta.apk',
            releaseDate: DateTime(2024, 4, 10),
            releaseNotes: 'Added payment gateway integration, user profile enhancements.',
            fileSize: 42000000,
          ),
        ],
      ),
      Project(
        id: 'proj_002',
        name: 'Healthcare Management System',
        description: 'A patient management system for healthcare providers with appointment scheduling, medical records, and telemedicine features.',
        status: ProjectStatus.review,
        progress: 0.90,
        startDate: DateTime(2024, 1, 10),
        estimatedEndDate: DateTime(2024, 5, 15),
        clientName: 'TechCorp Solutions',
        projectManager: 'Michael Chen',
        imageUrl: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=400',
        milestones: [
          ProjectMilestone(
            id: 'ms_007',
            title: 'Requirements Analysis',
            description: 'Detailed requirements gathering and documentation',
            isCompleted: true,
            completedDate: DateTime(2024, 1, 20),
            order: 1,
          ),
          ProjectMilestone(
            id: 'ms_008',
            title: 'System Architecture',
            description: 'Design system architecture and database schema',
            isCompleted: true,
            completedDate: DateTime(2024, 2, 5),
            order: 2,
          ),
          ProjectMilestone(
            id: 'ms_009',
            title: 'Core Modules',
            description: 'Development of patient and appointment modules',
            isCompleted: true,
            completedDate: DateTime(2024, 3, 20),
            order: 3,
          ),
          ProjectMilestone(
            id: 'ms_010',
            title: 'Telemedicine Integration',
            description: 'Video consultation and chat features',
            isCompleted: true,
            completedDate: DateTime(2024, 4, 15),
            order: 4,
          ),
          ProjectMilestone(
            id: 'ms_011',
            title: 'Final Review',
            description: 'Client review and feedback incorporation',
            isCompleted: false,
            order: 5,
          ),
        ],
        feedbacks: [
          QAFeedback(
            id: 'fb_004',
            projectId: 'proj_002',
            title: 'Video call quality issues',
            description: 'Video calls have intermittent quality drops. Audio sync issues noticed during longer calls.',
            status: FeedbackStatus.inReview,
            priority: FeedbackPriority.critical,
            createdAt: DateTime(2024, 4, 22),
            submittedBy: 'John Anderson',
          ),
        ],
        apkVersions: [
          APKVersion(
            id: 'apk_003',
            version: '2.0.0-rc1',
            downloadUrl: 'https://example.com/downloads/healthcare-2.0.0-rc1.apk',
            releaseDate: DateTime(2024, 4, 20),
            releaseNotes: 'Release candidate with all features. Ready for final testing.',
            fileSize: 58000000,
          ),
        ],
      ),
      Project(
        id: 'proj_003',
        name: 'Fitness Tracking App',
        description: 'A comprehensive fitness app with workout tracking, nutrition planning, and social features for fitness enthusiasts.',
        status: ProjectStatus.inProgress,
        progress: 0.45,
        startDate: DateTime(2024, 3, 1),
        estimatedEndDate: DateTime(2024, 8, 31),
        clientName: 'TechCorp Solutions',
        projectManager: 'Emily Rodriguez',
        imageUrl: 'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=400',
        milestones: [
          ProjectMilestone(
            id: 'ms_012',
            title: 'Project Planning',
            description: 'Define scope, timeline, and resource allocation',
            isCompleted: true,
            completedDate: DateTime(2024, 3, 10),
            order: 1,
          ),
          ProjectMilestone(
            id: 'ms_013',
            title: 'Design Phase',
            description: 'UI/UX design and user testing',
            isCompleted: true,
            completedDate: DateTime(2024, 4, 1),
            order: 2,
          ),
          ProjectMilestone(
            id: 'ms_014',
            title: 'Workout Module',
            description: 'Develop workout tracking features',
            isCompleted: false,
            order: 3,
          ),
          ProjectMilestone(
            id: 'ms_015',
            title: 'Nutrition Module',
            description: 'Develop nutrition and meal planning features',
            isCompleted: false,
            order: 4,
          ),
          ProjectMilestone(
            id: 'ms_016',
            title: 'Social Features',
            description: 'Community and social sharing functionality',
            isCompleted: false,
            order: 5,
          ),
        ],
        feedbacks: [],
        apkVersions: [
          APKVersion(
            id: 'apk_004',
            version: '0.5.0-alpha',
            downloadUrl: 'https://example.com/downloads/fitness-0.5.0-alpha.apk',
            releaseDate: DateTime(2024, 4, 15),
            releaseNotes: 'Alpha build with basic workout tracking. Design preview available.',
            fileSize: 35000000,
          ),
        ],
      ),
      Project(
        id: 'proj_004',
        name: 'Restaurant POS System',
        description: 'A complete point-of-sale system for restaurants with order management, inventory tracking, and analytics dashboard.',
        status: ProjectStatus.completed,
        progress: 1.0,
        startDate: DateTime(2023, 10, 1),
        estimatedEndDate: DateTime(2024, 3, 31),
        clientName: 'TechCorp Solutions',
        projectManager: 'David Kim',
        imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
        milestones: [
          ProjectMilestone(
            id: 'ms_017',
            title: 'Discovery',
            description: 'Business analysis and requirements',
            isCompleted: true,
            completedDate: DateTime(2023, 10, 15),
            order: 1,
          ),
          ProjectMilestone(
            id: 'ms_018',
            title: 'Development',
            description: 'Full system development',
            isCompleted: true,
            completedDate: DateTime(2024, 2, 15),
            order: 2,
          ),
          ProjectMilestone(
            id: 'ms_019',
            title: 'Testing & QA',
            description: 'Comprehensive testing phase',
            isCompleted: true,
            completedDate: DateTime(2024, 3, 15),
            order: 3,
          ),
          ProjectMilestone(
            id: 'ms_020',
            title: 'Deployment',
            description: 'Production deployment and training',
            isCompleted: true,
            completedDate: DateTime(2024, 3, 30),
            order: 4,
          ),
        ],
        feedbacks: [
          QAFeedback(
            id: 'fb_005',
            projectId: 'proj_004',
            title: 'Minor UI adjustment',
            description: 'Font size on order summary could be larger for better readability.',
            status: FeedbackStatus.resolved,
            priority: FeedbackPriority.low,
            createdAt: DateTime(2024, 3, 10),
            resolvedAt: DateTime(2024, 3, 12),
            submittedBy: 'John Anderson',
            response: 'Updated font sizes across the order flow. Thank you for the feedback!',
          ),
        ],
        apkVersions: [
          APKVersion(
            id: 'apk_005',
            version: '1.0.0',
            downloadUrl: 'https://example.com/downloads/pos-1.0.0.apk',
            releaseDate: DateTime(2024, 3, 30),
            releaseNotes: 'Final release version. All features complete and tested.',
            fileSize: 52000000,
          ),
        ],
      ),
    ];
  }

  static List<AppNotification> getMockNotifications() {
    return [
      AppNotification(
        id: 'notif_001',
        title: 'New APK Available',
        message: 'E-Commerce Mobile App v1.2.0-beta is now available for download.',
        type: NotificationType.apkRelease,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        projectId: 'proj_001',
      ),
      AppNotification(
        id: 'notif_002',
        title: 'Feedback Response',
        message: 'Your feedback "Checkout flow improvement" has been resolved.',
        type: NotificationType.feedbackResponse,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
        projectId: 'proj_001',
      ),
      AppNotification(
        id: 'notif_003',
        title: 'Milestone Completed',
        message: 'Healthcare Management System has completed the Telemedicine Integration milestone.',
        type: NotificationType.milestone,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        projectId: 'proj_002',
      ),
      AppNotification(
        id: 'notif_004',
        title: 'Project Update',
        message: 'Fitness Tracking App design phase has been completed successfully.',
        type: NotificationType.projectUpdate,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        projectId: 'proj_003',
      ),
      AppNotification(
        id: 'notif_005',
        title: 'Weekly Summary',
        message: 'Your weekly project summary is ready. Check out the progress of all your projects.',
        type: NotificationType.general,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
      AppNotification(
        id: 'notif_006',
        title: 'Project Completed',
        message: 'Congratulations! Restaurant POS System has been successfully delivered.',
        type: NotificationType.projectUpdate,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        isRead: true,
        projectId: 'proj_004',
      ),
    ];
  }

  static List<APKVersion> getAllLatestAPKs() {
    final projects = getMockProjects();
    List<APKVersion> allApks = [];
    for (var project in projects) {
      if (project.apkVersions.isNotEmpty) {
        allApks.add(project.apkVersions.first);
      }
    }
    allApks.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
    return allApks.take(5).toList();
  }

  static List<Payment> getMockPaymentsForProject(String projectId) {
    final projects = getMockProjects();
    final project = projects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => projects.first,
    );

    List<Payment> payments = [];
    for (var milestone in project.milestones) {
      PaymentStatus status;
      DateTime? paidDate;
      String? transactionId;
      String? paymentMethod;

      if (milestone.isCompleted) {
        status = PaymentStatus.paid;
        paidDate = milestone.completedDate?.add(const Duration(days: 5));
        transactionId = 'TXN${milestone.id.hashCode.abs()}';
        paymentMethod = 'Bank Transfer';
      } else {
        status = PaymentStatus.pending;
      }

      double amount;
      switch (milestone.order) {
        case 1:
          amount = 5000.0;
          break;
        case 2:
          amount = 8000.0;
          break;
        case 3:
          amount = 12000.0;
          break;
        case 4:
          amount = 10000.0;
          break;
        case 5:
          amount = 8000.0;
          break;
        case 6:
          amount = 7000.0;
          break;
        default:
          amount = 5000.0;
      }

      payments.add(Payment(
        id: 'pay_${milestone.id}',
        milestoneId: milestone.id,
        projectId: projectId,
        amount: amount,
        status: status,
        paidDate: paidDate,
        dueDate: milestone.completedDate?.add(const Duration(days: 15)) ??
            DateTime.now().add(const Duration(days: 30)),
        transactionId: transactionId,
        paymentMethod: paymentMethod,
      ));
    }
    return payments;
  }
}