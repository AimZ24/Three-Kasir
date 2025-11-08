import 'package:flutter/material.dart';
import 'package:kasirsuper/core/core.dart';

class SearchTextInput extends StatelessWidget {
  const SearchTextInput({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.theme.primaryColor.withAlpha((0.3 * 255).round()),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: context.theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 16,
          color: context.theme.textTheme.bodyLarge?.color,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: context.theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            AppIcons.search,
            color: context.theme.primaryColor,
            size: 24,
          ),
          suffixIcon: controller?.text.isNotEmpty ?? false
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: context.theme.iconTheme.color,
                  ),
                  onPressed: () {
                    controller?.clear();
                    onChanged?.call('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
