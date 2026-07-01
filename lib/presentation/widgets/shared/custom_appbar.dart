import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    //final textStyles = Theme.of(context).textTheme;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          //
          width: double.infinity,
          child: Row(
            //
            children: [
              //
              Icon(
                Icons.monetization_on_outlined,
                color: colors.primary,
                size: 40,
              ),
              const SizedBox(width: 5),
              Text(
                'PRESTAPAGO',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: colors.primary),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
