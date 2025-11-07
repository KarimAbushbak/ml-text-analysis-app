import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/history_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/loading_indicator.dart';
import 'history_cubit.dart';
import 'history_state.dart';
import 'history_detail_screen.dart';
import 'widgets/history_list_item.dart';

/// History screen showing past analyses
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _selectedFilter;

  final Map<String, String> _filterOptions = {
    'translation': 'Translation',
    'sentiment': 'Sentiment',
    'paraphrasing': 'Paraphrasing',
    'ner': 'NER',
    'summarization': 'Summarization',
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HistoryStorageService>(
      future: HistoryStorageService.create(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: LoadingIndicator()),
          );
        }

        return BlocProvider(
          create: (context) => HistoryCubit(snapshot.data!)..loadHistory(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('History'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                // Wrap actions in Builder to get correct context
                Builder(
                  builder: (context) => PopupMenuButton<String?>(
                    icon: Icon(
                      Icons.filter_list,
                      color: _selectedFilter != null ? AppColors.primaryBlue : null,
                    ),
                    tooltip: 'Filter by feature',
                    onSelected: (value) {
                      setState(() {
                        _selectedFilter = value;
                      });
                      context.read<HistoryCubit>().filterByType(value);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String?>(
                        value: null,
                        child: Row(
                          children: [
                            Icon(
                              _selectedFilter == null
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text('All'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      ..._filterOptions.entries.map((entry) {
                        return PopupMenuItem<String>(
                          value: entry.key,
                          child: Row(
                            children: [
                              Icon(
                                _selectedFilter == entry.key
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(entry.value),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                // Clear all button
                BlocBuilder<HistoryCubit, HistoryState>(
                  builder: (context, state) {
                    if (state is HistoryLoaded && state.items.isNotEmpty) {
                      return IconButton(
                        icon: const Icon(Icons.delete_sweep),
                        tooltip: 'Clear all',
                        onPressed: () => _showClearAllDialog(context),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            body: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoading) {
                  return const Center(child: LoadingIndicator());
                }

                if (state is HistoryEmpty) {
                  return _buildEmptyState(context);
                }

                if (state is HistoryLoaded) {
                  return Column(
                    children: [
                      // Filter indicator
                      if (state.isFiltered)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          child: Row(
                            children: [
                              Icon(
                                Icons.filter_alt,
                                size: 16,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Showing ${_filterOptions[state.filterType]} only',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedFilter = null;
                                  });
                                  context.read<HistoryCubit>().filterByType(null);
                                },
                                child: const Text('Clear filter'),
                              ),
                            ],
                          ),
                        ),
                      // History list
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            final item = state.items[index];
                            return HistoryListItem(
                              item: item,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HistoryDetailScreen(item: item),
                                  ),
                                );
                              },
                              onDelete: () {
                                context.read<HistoryCubit>().deleteItem(item.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('History item deleted'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                if (state is HistoryError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.primaryRed,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error Loading History',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              context.read<HistoryCubit>().loadHistory();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedFilter != null ? 'No items found' : 'No history yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter != null
                  ? 'No ${_filterOptions[_selectedFilter]} history found'
                  : 'Your past analyses will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
              textAlign: TextAlign.center,
            ),
            if (_selectedFilter != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFilter = null;
                  });
                  context.read<HistoryCubit>().filterByType(null);
                },
                child: const Text('Clear filter'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showClearAllDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Clear All History'),
          content: const Text(
            'Are you sure you want to delete all history? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryRed,
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      context.read<HistoryCubit>().clearAll();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All history cleared'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
