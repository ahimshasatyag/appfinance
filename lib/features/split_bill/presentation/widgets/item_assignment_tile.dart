import 'package:flutter/material.dart';
import '../../../../app/config/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../domain/entities/bill_item_entity.dart';
import '../../domain/entities/member_entity.dart';

class ItemAssignmentTile extends StatelessWidget {
  final BillItemEntity item;
  final List<MemberEntity> members;
  final Function(String memberId) onToggleMember;
  final VoidCallback onAssignAll;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isEditable;

  const ItemAssignmentTile({
    super.key,
    required this.item,
    required this.members,
    required this.onToggleMember,
    required this.onAssignAll,
    this.onEdit,
    this.onDelete,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAllSelected =
        members.isNotEmpty && item.assignedMemberIds.length == members.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name, Qty, Price, Actions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.quantity}x @ ${Formatters.formatCurrency(item.price)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.formatCurrency(item.totalPrice),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  if (item.assignedMemberIds.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${Formatters.formatCurrency(item.pricePerPerson)}/org',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
              if (isEditable) ...[
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 20,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  onSelected: (value) {
                    if (value == 'edit') onEdit?.call();
                    if (value == 'delete') onDelete?.call();
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text(context.l10n.editItem),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(context.l10n.delete, style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Assignment section: "Siapa yang patungan?"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.coveredBy(item.assignedMemberIds.length, members.length),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              if (isEditable)
                InkWell(
                  onTap: onAssignAll,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      isAllSelected ? context.l10n.unselectAll : context.l10n.selectAll,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Member selection chips
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: members.map((member) {
              final isAssigned = item.assignedMemberIds.contains(member.id);

              return FilterChip(
                label: Text(member.isCurrentUser ? context.l10n.me : member.name),
                selected: isAssigned,
                showCheckmark: true,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isAssigned
                      ? Colors.white
                      : (isDark ? Colors.white70 : const Color(0xFF1E293B)),
                ),
                backgroundColor: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey.shade100,
                selectedColor: AppTheme.primaryColor,
                side: BorderSide(
                  color: isAssigned
                      ? AppTheme.primaryColor
                      : (isDark ? Colors.white12 : Colors.grey.shade300),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onSelected: isEditable ? (_) => onToggleMember(member.id) : null,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
