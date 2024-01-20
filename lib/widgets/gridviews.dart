import 'package:flutter/material.dart';
import 'package:taskiee/pods/utils_pod.dart';
import 'package:taskiee/widgets/list_card.dart';
import 'package:taskiee/widgets/note_card.dart';
import 'package:taskiee/widgets/label_card.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

enum GridType { Lists, Labels, Notes }

class GridViews extends HookWidget {
  final GridType gridType;
  final bool inSearch;
  final List gridData;

  const GridViews({
    this.gridType,
    this.gridData,
    this.inSearch = false,
  });

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    final ignoring = useProvider(utilsPod).isShowing;

    var child;
    var gridView;
    var aspectRatio;

    switch (gridType) {
      case GridType.Lists:
        aspectRatio = 1.0;
        child = (index) => ListCard(list: gridData[index]);
        break;
      case GridType.Labels:
        aspectRatio = 2.0;
        child = (index) => LabelCard(label: gridData[index]);
        break;
      case GridType.Notes:
        aspectRatio = 1.0;
        child = (index) => NoteCard(note: gridData[index]);
        break;
    }

    if (inSearch) {
      gridView = SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (_, index) =>
                IgnorePointer(child: child(index), ignoring: ignoring),
            childCount: gridData.length,
          ),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            maxCrossAxisExtent: 192,
            childAspectRatio: aspectRatio,
          ),
        ),
      );
    } else {
      gridView = GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 72),
        itemCount: gridData.length,
        itemBuilder: (_, index) =>
            IgnorePointer(child: child(index), ignoring: ignoring),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          maxCrossAxisExtent: 192,
          childAspectRatio: aspectRatio,
        ),
      );
    }

    switch (gridType) {
      case GridType.Lists:
        return gridView;
      case GridType.Labels:
        return gridView;
      case GridType.Notes:
        {
          gridView = MasonryGridView.builder(
            shrinkWrap: true,
            padding: inSearch
                ? const EdgeInsets.fromLTRB(16, 8, 16, 16)
                : const EdgeInsets.fromLTRB(16, 16, 16, 72),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: gridData.length,
            physics: inSearch
                ? NeverScrollableScrollPhysics()
                : AlwaysScrollableScrollPhysics(),
            itemBuilder: (_, index) => child(index),
            gridDelegate: SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 192),
          );

          return inSearch ? SliverToBoxAdapter(child: gridView) : gridView;
        }
    }
  }
}
