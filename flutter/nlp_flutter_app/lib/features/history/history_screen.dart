import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/history_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_dimensions.dart';
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
    'translation': AppStrings.filterTranslation,
    'sentiment': AppStrings.filterSentiment,
    'paraphrasing': AppStrings.filterParaphrasing,
    'ner': AppStrings.filterNER,
    'summarization': AppStrings.filterSummarization,
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HistoryStorageService>(
      future: HistoryStorageService.create(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: LoadingIndicator()));
        }

        return BlocProvider(
          create: (context) => HistoryCubit(snapshot.data!)..loadHistory(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.historyTitle),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                PopupMenuButton<String?>(
                  icon: Icon(
                    Icons.filter_list,
                    color: _selectedFilter != null
                        ? AppColors.primaryBlue
                        : null,
                  ),
                  tooltip: AppStrings.filter,
                  onSelected: (value) {
                    setState(() => _selectedFilter = value);
                    context.read<HistoryCubit>().filterByType(value);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String?>(
                      value: null,
                      child: Text(
                        AppStrings.all,
                        style: TextStyle(
                          fontWeight: _selectedFilter == null 
                              ? AppDimensions.fontWeightBold 
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    const PopupMenuDivider(),
                    ..._filterOptions.entries.map((entry) {
                      return PopupMenuItem<String>(
                        value: entry.key,
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontWeight: _selectedFilter == entry.key
                                ? AppDimensions.fontWeightBold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                BlocBuilder<HistoryCubit, HistoryState>(
                  builder: (context, state) {
                    if (state is HistoryLoaded && state.items.isNotEmpty) {
                      return IconButton(
                        icon: const Icon(Icons.delete_sweep),
                        tooltip: AppStrings.clearAllTooltip,
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
                                '${AppStrings.showingFilterOnly} ${_filterOptions[state.filterType]} ${AppStrings.only}',
                                style: TextStyle(
                                  fontSize: AppDimensions.fontSize14,
                                  color: AppColors.primaryBlue,
                                  fontWeight: AppDimensions.fontWeight500,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedFilter = null;
                                  });
                                  context.read<HistoryCubit>().filterByType(
                                    null,
                                  );
                                },
                                child: const Text(AppStrings.clearFilter),
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
                                  SnackBar(
                                    content: const Text(AppStrings.deleted),
                                    duration: AppDimensions.snackbarDuration,
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
                            AppStrings.errorLoadingHistory,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppDimensions.spacing8),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppDimensions.spacing24),
                          ElevatedButton(
                            onPressed: () {
                              context.read<HistoryCubit>().loadHistory();
                            },
                            child: const Text(AppStrings.retry),
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
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedFilter != null ? AppStrings.noItemsFound : AppStrings.noHistoryYet,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: AppDimensions.fontWeight600),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              _selectedFilter != null
                  ? 'No ${_filterOptions[_selectedFilter]} ${AppStrings.historyTitle.toLowerCase()} found'
                  : AppStrings.pastAnalysesWillAppear,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            if (_selectedFilter != null) ...[
              const SizedBox(height: AppDimensions.spacing16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFilter = null;
                  });
                  context.read<HistoryCubit>().filterByType(null);
                },
                child: const Text(AppStrings.clearFilter),
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
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.clearAllHistory),
        content: const Text(
          AppStrings.deleteAllHistoryConfirm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryRed,
            ),
            child: const Text(AppStrings.clearAll),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<HistoryCubit>().clearAll();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(AppStrings.historyCleared),
          duration: AppDimensions.snackbarDuration,
        ),
      );
    }
  }
}
