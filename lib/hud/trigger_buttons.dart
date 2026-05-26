import 'package:flutter/material.dart';

import '../rive/prez_rive_viewmodel.rive.dart';

class TriggerButtons extends StatelessWidget {
  const TriggerButtons({super.key, required this.vm});

  final VmCardViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: vm.triggerFlip,
              icon: const Icon(Icons.flip),
              label: const Text('Flip'),
            ),
            FilledButton.icon(
              onPressed: vm.triggerBump,
              icon: const Icon(Icons.touch_app),
              label: const Text('Bump'),
            ),
            FilledButton.tonalIcon(
              onPressed: vm.triggerSwitchToBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Switch to back'),
            ),
            FilledButton.tonalIcon(
              onPressed: vm.triggerSwitchToFace,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Switch to face'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder<bool>(
          stream: vm.isFaceVisibleStream,
          initialData: vm.isFaceVisible,
          builder: (context, snapshot) {
            final visible = snapshot.data ?? false;
            return Row(
              children: [
                Icon(
                  visible ? Icons.visibility : Icons.visibility_off,
                  size: 18,
                  color: visible ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  visible ? 'Face visible' : 'Back visible',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
