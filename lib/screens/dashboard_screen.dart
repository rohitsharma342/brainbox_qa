import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../models/project.dart';
import '../providers/auth_provider.dart';
import '../providers/project_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/project_card.dart';
import '../widgets/feedback_item.dart';
import '../widgets/apk_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().loadProjects();
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showStatusFilterSheet() {
    final projectProvider = context.read<ProjectProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter by Status',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton(
                    onPressed: () {
                      projectProvider.clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildFilterOption('All Projects', null, projectProvider),
              _buildFilterOption('In Progress', ProjectStatus.inProgress, projectProvider),
              _buildFilterOption('Under Review', ProjectStatus.review, projectProvider),
              _buildFilterOption('Completed', ProjectStatus.completed, projectProvider),
              _buildFilterOption('On Hold', ProjectStatus.onHold, projectProvider),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, ProjectStatus? status, ProjectProvider provider) {
    final isSelected = provider.statusFilter == status;
    return ListTile(
      onTap: () {
        provider.filterByStatus(status);
        Navigator.pop(context);
      },
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? AppTheme.primaryColor : AppTheme.textTertiary,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.surfaceColor,
      elevation: 0,
      title: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                auth.user?.name ?? 'User',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        Consumer<NotificationProvider>(
          builder: (context, notifications, _) {
            return Stack(
              children: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
                  icon: const Icon(Icons.notifications_outlined),
                ),
                if (notifications.unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.errorColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        notifications.unreadCount > 9 ? '9+' : '${notifications.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return _buildProjectsContent();
      case 2:
        return _buildProfileContent();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, _) {
        if (projectProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: () => projectProvider.loadProjects(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchAndFilter(),
                const SizedBox(height: 24),
                _buildProjectSummary(projectProvider),
                const SizedBox(height: 24),
                _buildSectionHeader('Active Projects', () {}),
                const SizedBox(height: 16),
                _buildActiveProjects(projectProvider),
                const SizedBox(height: 24),
                _buildSectionHeader('Recent Feedback', () {}),
                const SizedBox(height: 16),
                _buildRecentFeedback(projectProvider),
                const SizedBox(height: 24),
                _buildSectionHeader('Latest APK Updates', () {}),
                const SizedBox(height: 16),
                _buildAPKUpdates(projectProvider),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.cardShadow,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => context.read<ProjectProvider>().searchProjects(value),
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textTertiary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          context.read<ProjectProvider>().searchProjects('');
                        },
                        icon: const Icon(Icons.clear, color: AppTheme.textTertiary),
                      )
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.cardShadow,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: _showStatusFilterSheet,
            icon: Consumer<ProjectProvider>(
              builder: (context, provider, _) {
                return Icon(
                  Icons.filter_list,
                  color: provider.statusFilter != null
                      ? AppTheme.primaryColor
                      : AppTheme.textTertiary,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectSummary(ProjectProvider provider) {
    final total = provider.projects.length;
    final inProgress = provider.projects.where((p) => p.status == ProjectStatus.inProgress).length;
    final inReview = provider.projects.where((p) => p.status == ProjectStatus.review).length;
    final completed = provider.projects.where((p) => p.status == ProjectStatus.completed).length;

    return Row(
      children: [
        _buildSummaryCard('Total', total, AppTheme.primaryColor),
        const SizedBox(width: 12),
        _buildSummaryCard('Active', inProgress, AppTheme.warningColor),
        const SizedBox(width: 12),
        _buildSummaryCard('Review', inReview, AppTheme.secondaryColor),
        const SizedBox(width: 12),
        _buildSummaryCard('Done', completed, AppTheme.successColor),
      ],
    );
  }

  Widget _buildSummaryCard(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.cardShadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }

  Widget _buildActiveProjects(ProjectProvider provider) {
    final activeProjects = provider.projects
        .where((p) => p.status == ProjectStatus.inProgress || p.status == ProjectStatus.review)
        .take(3)
        .toList();

    if (activeProjects.isEmpty) {
      return _buildEmptyState(
        icon: Icons.folder_outlined,
        title: 'No Active Projects',
        message: 'You don\'t have any active projects at the moment.',
      );
    }

    return Column(
      children: activeProjects.map((project) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ProjectCard(
            project: project,
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.projectDetail,
              arguments: project,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentFeedback(ProjectProvider provider) {
    final feedbacks = provider.recentFeedbacks.take(3).toList();

    if (feedbacks.isEmpty) {
      return _buildEmptyState(
        icon: Icons.feedback_outlined,
        title: 'No Feedback Yet',
        message: 'Your QA feedback will appear here.',
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: feedbacks.asMap().entries.map((entry) {
          final index = entry.key;
          final feedback = entry.value;
          return Column(
            children: [
              FeedbackItem(
                feedback: feedback,
                isCompact: true,
              ),
              if (index < feedbacks.length - 1)
                Divider(height: 1, color: AppTheme.dividerColor),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAPKUpdates(ProjectProvider provider) {
    final apks = provider.latestAPKs.take(3).toList();

    if (apks.isEmpty) {
      return _buildEmptyState(
        icon: Icons.android_outlined,
        title: 'No APK Updates',
        message: 'APK releases will appear here.',
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: apks.asMap().entries.map((entry) {
          final index = entry.key;
          final apk = entry.value;
          return Column(
            children: [
              APKItem(apk: apk),
              if (index < apks.length - 1)
                Divider(height: 1, color: AppTheme.dividerColor),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppTheme.textTertiary),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsContent() {
    return Consumer<ProjectProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final projects = provider.projects;

        if (projects.isEmpty) {
          return Center(
            child: _buildEmptyState(
              icon: Icons.folder_outlined,
              title: 'No Projects Found',
              message: 'Try adjusting your search or filters.',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadProjects(),
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ProjectCard(
                  project: projects[index],
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.projectDetail,
                    arguments: projects[index],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProfileContent() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final user = auth.user;
        if (user == null) return const SizedBox();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (user.company != null) ...
                [
                  const SizedBox(height: 4),
                  Text(
                    user.company!,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              const SizedBox(height: 32),
              _buildProfileOption(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
              ),
              _buildProfileOption(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
              ),
              _buildProfileOption(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Help & Support coming soon'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              _buildProfileOption(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'BrainBox QA',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2024 BrainBox Apps',
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildProfileOption(
                icon: Icons.logout,
                title: 'Logout',
                onTap: _handleLogout,
                isDestructive: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isDestructive ? AppTheme.errorColor : AppTheme.textSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? AppTheme.errorColor : AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive ? AppTheme.errorColor : AppTheme.textTertiary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
              _buildNavItem(1, Icons.folder_outlined, Icons.folder, 'Projects'),
              _buildNavItem(2, Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textTertiary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textTertiary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}