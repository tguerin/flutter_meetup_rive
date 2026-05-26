import 'package:flutter/material.dart';

import '../rive/prez_rive_viewmodel.rive.dart';
import 'back_card_controls.dart';
import 'front_card_controls.dart';
import 'logo_picker.dart';
import 'trigger_buttons.dart';

class CardHud extends StatelessWidget {
  const CardHud({super.key, required this.vm});

  final VmCardViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Section(
                title: 'Triggers',
                icon: Icons.flash_on,
                child: TriggerButtons(vm: vm),
              ),
              _Section(
                title: 'Front card',
                icon: Icons.style,
                child: FrontCardControls(vm: vm),
              ),
              _Section(
                title: 'Back card',
                icon: Icons.palette,
                child: BackCardControls(vm: vm),
              ),
              _Section(
                title: 'Logo binding',
                icon: Icons.image,
                last: true,
                child: LogoPicker(vm: vm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.child,
    this.last = false,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
        if (!last) ...[
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
