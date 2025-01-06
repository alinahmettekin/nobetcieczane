import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/base/entities/selectable.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/dropdown/search_field.dart';
import 'package:nobetcieczane/features/home/presentation/widgets/dropdown/selectable_list_item.dart';

class DropdownListContent<T extends Selectable> extends StatefulWidget {
  /// DropdownListContent constructor
  const DropdownListContent({
    required this.items,
    required this.isDarkMode,
    required this.onItemSelected,
    super.key,
    this.title,
  });
  final List<T>? items;
  final String? title;
  final bool isDarkMode;
  final void Function(T) onItemSelected;

  @override
  State<DropdownListContent<T>> createState() => _DropdownListContentState<T>();
}

class _DropdownListContentState<T extends Selectable>
    extends State<DropdownListContent<T>> {
  late TextEditingController searchController;
  late List<T>? filteredItems;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    filteredItems = widget.items;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items
          ?.where(
            (item) => item.cities.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Container(
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? Theme.of(context).colorScheme.surface
              : Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Column(
          children: [
            SearchField(
              controller: searchController,
              hintText: widget.title,
              onChanged: _filterItems,
            ),
            const SizedBox(height: 12),
            if (widget.items != null)
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredItems?.length ?? 0,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    height: 16,
                  ),
                  itemBuilder: (context, index) {
                    final item = filteredItems![index];
                    return SelectableListItem(
                      item: item,
                      isDarkMode: widget.isDarkMode,
                      onTap: () => widget.onItemSelected(item),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
