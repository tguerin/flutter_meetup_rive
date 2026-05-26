import 'package:flutter/material.dart';

import '../rive/prez_rive_viewmodel.rive.dart';

const _swatches = <Color>[
  Color(0xFF1E88E5),
  Color(0xFFD81B60),
  Color(0xFF43A047),
  Color(0xFFFB8C00),
  Color(0xFF8E24AA),
  Color(0xFF00ACC1),
];

class BackCardControls extends StatelessWidget {
  const BackCardControls({super.key, required this.vm});

  final VmCardViewModel vm;

  PropertyOfVmBackCard get _back => vm.propertyOfVmBackCard;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder<bool>(
          stream: _back.customBgStream,
          initialData: _back.customBg,
          builder: (context, snapshot) {
            final value = snapshot.data ?? _back.customBg;
            return SwitchListTile(
              title: const Text('Custom background'),
              subtitle: const Text('Toggles between default and bound assets'),
              value: value,
              onChanged: (v) => _back.customBg = v,
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          },
        ),
        const SizedBox(height: 4),
        Text('Background color', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        StreamBuilder<Color>(
          stream: _back.colorBgStream,
          initialData: _back.colorBg,
          builder: (context, snapshot) {
            final current = snapshot.data ?? _back.colorBg;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in _swatches)
                  _Swatch(
                    color: c,
                    selected: current.toARGB32() == c.toARGB32(),
                    onTap: () => _back.colorBg = c,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: selected
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}
