import 'package:flutter/material.dart';
import '../../../models/profile.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;
  final double angle;
  final Offset offset;
  final bool showShadow;

  final VoidCallback? onPass;
  final VoidCallback? onLike;
  final VoidCallback? onSuperLike;

  const ProfileCard({
    super.key,
    required this.profile,
    this.angle = 0,
    this.offset = Offset.zero,
    this.showShadow = true,
    this.onPass,
    this.onLike,
    this.onSuperLike,
  });

  @override
  Widget build(BuildContext context) {
    final rotation = angle * 3.1415926535 / 180.0;

    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: rotation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular hero image "card"
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: showShadow
                    ? [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.14),
                          blurRadius: 26,
                          spreadRadius: 6,
                        ),
                      ]
                    : null,
                image: DecorationImage(
                  image: profile.avatarUrl.isNotEmpty
                      ? NetworkImage(profile.avatarUrl)
                      : const AssetImage('assets/images/default_profile.png')
                            as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(130),
                    bottomRight: Radius.circular(130),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${profile.fullName}, ${profile.age}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      profile.profession,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  icon: Icons.close,
                  color: const Color(0xFFE8E0FF),
                  iconColor: const Color(0xFF4B3A8F),
                  onTap: onPass,
                ),
                const SizedBox(width: 22),
                _ActionButton(
                  icon: Icons.favorite,
                  size: 70,
                  color: const Color(0xFFFFEEF0),
                  iconColor: const Color(0xFFE53935),
                  onTap: onLike,
                ),
                const SizedBox(width: 22),
                _ActionButton(
                  icon: Icons.star,
                  color: const Color(0xFFE8E0FF),
                  iconColor: const Color(0xFF6A1B9A),
                  onTap: onSuperLike,
                ),
              ],
            ),

            const SizedBox(height: 18),

            // About + Read More (opens sheet)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F1147),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    profile.about,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => _showProfileSheet(context, profile),
                    child: const Text(
                      'Read More…',
                      style: TextStyle(
                        color: Color(0xFFD32F2F),
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFD32F2F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileSheet(BuildContext context, Profile p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          left: 16,
          right: 16,
          top: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 44,
                foregroundImage: p.avatarUrl.isNotEmpty
                    ? NetworkImage(p.avatarUrl)
                    : null,
                backgroundColor: const Color(0xFFE8E0FF),
                child: p.avatarUrl.isEmpty
                    ? Text(
                        p.initials.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F1147),
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${p.fullName}, ${p.age}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(p.profession, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 12),
            Text(p.about, style: const TextStyle(height: 1.45)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final double size;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.iconColor,
    this.size = 58,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 6,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: iconColor, size: size == 70 ? 30 : 24),
        ),
      ),
    );
  }
}
