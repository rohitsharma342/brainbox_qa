import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/feedback.dart';
import '../providers/project_provider.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';

class FeedbackModal extends StatefulWidget {
  final String projectId;
  final VoidCallback onSubmitted;

  const FeedbackModal({
    super.key,
    required this.projectId,
    required this.onSubmitted,
  });

  @override
  State<FeedbackModal> createState() => _FeedbackModalState();
}

class _FeedbackModalState extends State<FeedbackModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  FeedbackPriority _priority = FeedbackPriority.medium;
  bool _isLoading = false;
  bool _hasScreenshot = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await context.read<ProjectProvider>().submitFeedback(
      projectId: widget.projectId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      screenshotPath: _hasScreenshot ? 'screenshot.png' : null,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      widget.onSubmitted();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted successfully'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.1,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Submit Feedback',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _titleController,
                label: 'Title',
                hint: 'Brief summary of the issue',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe the issue in detail...',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Priority',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: FeedbackPriority.values.map((priority) {
                  final isSelected = _priority == priority;
                  return ChoiceChip(
                    label: Text(_getPriorityLabel(priority)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _priority = priority);
                    },
                    selectedColor: _getPriorityColor(priority).withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? _getPriorityColor(priority)
                          : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'Screenshot (Optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => setState(() => _hasScreenshot = !_hasScreenshot),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _hasScreenshot
                          ? AppTheme.primaryColor
                          : AppTheme.dividerColor,
                      width: _hasScreenshot ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: _hasScreenshot
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 32,
                                color: AppTheme.successColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Screenshot attached',
                                style: TextStyle(
                                  color: AppTheme.successColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextButton(
                                onPressed: () => setState(() => _hasScreenshot = false),
                                child: const Text('Remove'),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 32,
                                color: AppTheme.textTertiary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to add screenshot',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'Submit',
                      onPressed: _submitFeedback,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPriorityLabel(FeedbackPriority priority) {
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

  Color _getPriorityColor(FeedbackPriority priority) {
    switch (priority) {
      case FeedbackPriority.low:
        return AppTheme.textTertiary;
      case FeedbackPriority.medium:
        return AppTheme.warningColor;
      case FeedbackPriority.high:
        return AppTheme.errorColor;
      case FeedbackPriority.critical:
        return Colors.red.shade900;
    }
  }
}