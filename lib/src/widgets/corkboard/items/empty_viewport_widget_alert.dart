import 'package:flutter/material.dart';

class EmptyViewportWidget extends StatelessWidget {
  const EmptyViewportWidget({
    super.key,
    required this.isViewportEmptyNotifier,
    required this.constraints,
  });

  final BoxConstraints constraints;
  final ValueNotifier<bool> isViewportEmptyNotifier;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: (constraints.maxWidth * 0.50) - 130,
      bottom: 80,
      child: ValueListenableBuilder<bool>(
        valueListenable: isViewportEmptyNotifier,
        builder: (BuildContext context, bool value, Widget? _) {
          if (value) {
            return InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'No hay objetos visibles',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
