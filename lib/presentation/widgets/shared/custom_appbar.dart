import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final String? title;
  final IconData? icon;

  const CustomAppbar({
    super.key,
    this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle =
        Theme.of(context).textTheme.titleLarge?.copyWith(color: colors.primary);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: colors.primary, size: 40),
                const SizedBox(width: 5),
              ],
              Text(
                title ?? 'PRESTAPAGO',
                style: titleStyle,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
