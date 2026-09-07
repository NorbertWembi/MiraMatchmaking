import 'package:flutter/material.dart';
import '../../../models/profile.dart';

class MatchTile extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onTap;

  const MatchTile({super.key, required this.profile, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 22,
        child: Text(profile.initials.toUpperCase()),
      ),
      title: Text(
        '${profile.fullName}, ${profile.age}',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        profile.profession,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
      visualDensity: VisualDensity.comfortable,
    );
  }
}
