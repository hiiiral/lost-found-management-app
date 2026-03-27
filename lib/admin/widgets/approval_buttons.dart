import 'package:flutter/material.dart';

class ApprovalButtons extends StatefulWidget {
  const ApprovalButtons({
    super.key,
    this.onApprove,
    this.onReject,
    this.onReview,
    this.approveLabel = 'Approve',
    this.rejectLabel = 'Reject',
    this.reviewLabel = 'Review',
    this.showReview = false,
    this.isCompact = false,
  });

  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onReview;
  final String approveLabel;
  final String rejectLabel;
  final String reviewLabel;
  final bool showReview;
  final bool isCompact;

  @override
  State<ApprovalButtons> createState() => _ApprovalButtonsState();
}

class _ApprovalButtonsState extends State<ApprovalButtons> {
  @override
  Widget build(BuildContext context) {
    final approveButton = ElevatedButton.icon(
      onPressed: widget.onApprove,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0F3D56),
        foregroundColor: Colors.white,
        padding: _buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
      label: Text(widget.approveLabel),
    );

    final rejectButton = OutlinedButton.icon(
      onPressed: widget.onReject,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFD62828),
        side: const BorderSide(color: Color(0xFFF1B5B5)),
        padding: _buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      icon: const Icon(Icons.close_rounded, size: 18),
      label: Text(widget.rejectLabel),
    );

    final reviewButton = TextButton.icon(
      onPressed: widget.onReview,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF0F3D56),
        padding: _buttonPadding,
      ),
      icon: const Icon(Icons.visibility_outlined, size: 18),
      label: Text(widget.reviewLabel),
    );

    if (widget.isCompact) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.end,
        children: [
          if (widget.showReview) reviewButton,
          rejectButton,
          approveButton,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showReview) ...[
          reviewButton,
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(child: rejectButton),
            const SizedBox(width: 12),
            Expanded(child: approveButton),
          ],
        ),
      ],
    );
  }

  EdgeInsetsGeometry get _buttonPadding {
    if (widget.isCompact) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
    }

    return const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  }
}
