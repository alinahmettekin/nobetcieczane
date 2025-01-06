import 'package:flutter/material.dart';

/// Recent searches widget that shows the recent searches of the user.
class RecentSearchs extends StatelessWidget {
  /// RecentSearchs Constructor
  const RecentSearchs({
    required this.searches,
    required this.onSearchTap,
    required this.onDeleteItem,
    required this.onClearAll,
    super.key,
  });

  /// List of searches
  final List<Map<String, String>> searches;

  /// Function that will be called when a search is tapped
  final void Function(Map<String, String>) onSearchTap;

  /// Function that will be called when a search is deleted
  final void Function(Map<String, String>) onDeleteItem;

  /// Function that will be called when all searches are deleted
  final void Function() onClearAll;

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) return const SizedBox.shrink();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Son aramalar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showApproveDialog(
                      context: context,
                      title: 'Tüm Aramaları Sil',
                      content:
                          'Tüm aramaları silmek istediğinizden emin misiniz?',
                      onApprove: onClearAll,
                    );
                  },
                  child: const Text(
                    'Tümünü Sil',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.0005),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: searches.length,
                itemBuilder: (context, index) {
                  final search = searches[index];
                  return InkWell(
                    onTap: () => onSearchTap(search),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,

                            /// no time to fix this
                            // ignore: deprecated_member_use
                            backgroundColor: Colors.blueAccent.withOpacity(0.1),
                            child: const Icon(
                              Icons.history,
                              size: 24,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  search['cityName'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  search['districtName'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _showApproveDialog(
                                context: context,
                                title: 'Aramayı sil',
                                content:
                                    'Aramayı silmek istediğinize emin misiniz?',
                                onApprove: () => onDeleteItem(search),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showApproveDialog({
    required BuildContext context,
    required String title,
    required String content,
    required void Function() onApprove,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İPTAL'),
          ),
          TextButton(
            onPressed: () {
              onApprove();
              Navigator.pop(context);
            },
            child: const Text('SİL', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
