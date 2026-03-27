import 'package:flutter/material.dart';

class AdminItemCard extends StatefulWidget {
  const AdminItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    this.location,
    this.time,
    this.icon = Icons.inventory_2_rounded,
    this.onTap,
    this.description,
    this.metadata = const [],
    this.actionLabel,
    this.onActionPressed,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  final String? location;
  final String? time;
  final IconData icon;
  final VoidCallback? onTap;
  final String? description;
  final List<AdminItemMetadata> metadata;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final Widget? trailing;

  @override
  State<AdminItemCard> createState() => _AdminItemCardState();
}

class _AdminItemCardState extends State<AdminItemCard> {
  @override
  Widget build(BuildContext context) {
    final details = <String>[
      if (widget.location != null && widget.location!.isNotEmpty) widget.location!,
      if (widget.time != null && widget.time!.isNotEmpty) widget.time!,
    ];

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: widget.statusColor.withOpacity(0.12),
                child: Icon(widget.icon, color: widget.statusColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF102A43),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B7C93),
                      ),
                    ),
                    if (widget.description != null &&
                        widget.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF486581),
                          height: 1.35,
                        ),
                      ),
                    ],
                    if (details.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        details.join(' | '),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF829AB1),
                        ),
                      ),
                    ],
                    if (widget.metadata.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.metadata
                            .map(
                              (item) => _MetadataChip(
                                label: item.label,
                                value: item.value,
                                icon: item.icon,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    if (widget.actionLabel != null &&
                        widget.onActionPressed != null) ...[
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: widget.onActionPressed,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0F3D56),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: Text(widget.actionLabel!),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.status,
                      style: TextStyle(
                        color: widget.statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (widget.trailing != null) ...[
                    const SizedBox(height: 10),
                    widget.trailing!,
                  ],
                  if (widget.onTap != null) ...[
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF829AB1),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminItemMetadata {
  const AdminItemMetadata({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;
}

class _MetadataChip extends StatefulWidget {
  const _MetadataChip({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  State<_MetadataChip> createState() => _MetadataChipState();
}

class _MetadataChipState extends State<_MetadataChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD9E2EC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 14, color: const Color(0xFF486581)),
            const SizedBox(width: 6),
          ],
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF486581),
                  ),
              children: [
                TextSpan(
                  text: '${widget.label}: ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: widget.value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
