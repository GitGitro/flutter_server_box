import 'package:flutter/material.dart';
import 'package:toolbox/view/widget/input_field.dart';
import 'package:toolbox/view/widget/round_rect_card.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../core/utils/ui.dart';
import '../../data/res/color.dart';

class TagEditor extends StatelessWidget {
  final List<String> tags;
  final S s;
  final void Function(List<String>)? onChanged;
  final void Function(String)? onTapTag;
  final List<String>? tagSuggestions;

  const TagEditor({
    super.key,
    required this.tags,
    required this.s,
    this.onChanged,
    this.onTapTag,
    this.tagSuggestions,
  });

  @override
  Widget build(BuildContext context) {
    return RoundRectCard(ListTile(
      leading: const Icon(Icons.tag),
      title: _buildTags(tags),
      trailing: InkWell(
        child: const Icon(Icons.add),
        onTap: () {
          _showTagDialog(context, tags, onChanged);
        },
      ),
    ));
  }

  Widget _buildTags(List<String> tags) {
    tagSuggestions?.removeWhere((element) => tags.contains(element));
    final suggestionLen = tagSuggestions?.length ?? 0;
    final counts = tags.length + suggestionLen + (suggestionLen == 0 ? 0 : 1);
    if (counts == 0) return Text(s.tag);
    return ConstrainedBox(constraints: BoxConstraints(maxHeight: 27), child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        if (index < tags.length) {
          return _buildTagItem(tags[index], false);
        } else if (index > tags.length) {
          return _buildTagItem(tagSuggestions![index - tags.length - 1], true);
        }
        return const VerticalDivider();
      },
      itemCount: counts,
    ),);
  }

  Widget _buildTagItem(String tag, bool isAdd) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: () => onTapTag?.call(tag),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: primaryColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#$tag',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 4.0),
              InkWell(
                child: Icon(
                  isAdd ? Icons.add_circle : Icons.cancel,
                  size: 14.0,
                  color: Colors.white,
                ),
                onTap: () {
                  if (isAdd) {
                    tags.add(tag);
                  } else {
                    tags.remove(tag);
                  }
                  onChanged?.call(tags);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showTagDialog(
    BuildContext context,
    List<String> tags,
    void Function(List<String>)? onChanged,
  ) {
    final textEditingController = TextEditingController();
    showRoundDialog(
      context: context,
      title: Text(s.add),
      child: Input(
        controller: textEditingController,
        hint: s.tag,
      ),
      actions: [
        TextButton(
          onPressed: () {
            final tag = textEditingController.text;
            tags.add(tag.trim());
            onChanged?.call(tags);
            Navigator.pop(context);
          },
          child: Text(s.add),
        ),
      ],
    );
  }
}
