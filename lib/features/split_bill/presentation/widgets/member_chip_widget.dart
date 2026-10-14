import 'package:flutter/material.dart';
import '../../../../app/config/l10n.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../domain/entities/member_entity.dart';

class MemberChipWidget extends StatelessWidget {
  final List<MemberEntity> members;
  final VoidCallback onAddMember;
  final Function(String memberId)? onRemoveMember;
  final bool isEditable;

  const MemberChipWidget({
    super.key,
    required this.members,
    required this.onAddMember,
    this.onRemoveMember,
    this.isEditable = true,
  });

  Color _getAvatarColor(int index) {
    const colors = [
      Color(0xFF0D6EFF),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFF10B981),
      Color(0xFFF59E0B),
      Color(0xFF06B6D4),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: members.length + (isEditable ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (isEditable && index == members.length) {
            // Add Friend Button
            return InkWell(
              onTap: onAddMember,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 72,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.5),
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.l10n.add,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }

          final member = members[index];
          final avatarColor = _getAvatarColor(index);
          final initial = member.name.isNotEmpty
              ? member.name[0].toUpperCase()
              : '?';

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 72,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: member.isCurrentUser
                        ? AppTheme.primaryColor.withValues(alpha: 0.5)
                        : (isDark ? Colors.white12 : Colors.grey.shade200),
                    width: member.isCurrentUser ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: avatarColor,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      member.isCurrentUser ? context.l10n.me : member.name,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (isEditable && !member.isCurrentUser && onRemoveMember != null)
                Positioned(
                  top: -4,
                  right: -4,
                  child: InkWell(
                    onTap: () => onRemoveMember!(member.id),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
