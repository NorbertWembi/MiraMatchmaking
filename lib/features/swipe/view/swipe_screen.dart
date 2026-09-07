import 'package:flutter/material.dart';
import 'package:matchmaking/features/swipe/widgets/profile_card.dart';
import 'package:matchmaking/mock/mock_profiles.dart';
import 'package:matchmaking/models/profile.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with SingleTickerProviderStateMixin {
  final List<Profile> _deck = List.of(mockProfiles);
  int _topIndex = 0;
  Offset _dragOffset = Offset.zero;

  late final AnimationController _ctrl;
  late Animation<Offset> _slide = const AlwaysStoppedAnimation(Offset.zero);
  late Animation<double> _fade = const AlwaysStoppedAnimation(1.0);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails d) =>
      setState(() => _dragOffset += d.delta);

  void _onDragEnd(DragEndDetails d) {
    const threshold = 120.0;
    final dx = _dragOffset.dx;
    if (dx.abs() > threshold) {
      _handleDecision(dx > 0 ? Decision.like : Decision.pass);
    } else {
      setState(() => _dragOffset = Offset.zero);
    }
  }

  Future<void> _handleDecision(Decision decision) async {
    final end = switch (decision) {
      Decision.like => const Offset(1.2, 0),
      Decision.pass => const Offset(-1.2, 0),
      Decision.superLike => const Offset(0, -1.2),
    };
    _slide = Tween(
      begin: Offset.zero,
      end: end,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _fade = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    await _ctrl.forward();
    if (!mounted) return;
    setState(() {
      _topIndex++;
      _dragOffset = Offset.zero;
    });
    _ctrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    const navHeight = 92.0;
    final verticalPadding = 16 * 2 + 8;
    final available =
        size.height - kToolbarHeight - navHeight - verticalPadding;
    final cardWidth = size.width > 520 ? 430.0 : size.width * .92;
    final cardHeight = available.clamp(560.0, 760.0);

    final remaining = _deck.length - _topIndex;

    // compute swipe badges based on drag
    final dx = _dragOffset.dx;
    final likeOpacity = dx > 0 ? (dx / 120).clamp(0.0, 1.0) : 0.0;
    final nopeOpacity = dx < 0 ? (-dx / 120).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      appBar: AppBar(title: const Text('Discover')),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (remaining <= 0)
                          const Center(child: Text('No more profiles')),

                        if (remaining > 1)
                          Positioned(
                            top: 20,
                            left: 0,
                            right: 0,
                            child: Opacity(
                              opacity: 0.6,
                              child: ProfileCard(
                                key: ValueKey(
                                  'under-${_deck[_topIndex + 1].id}',
                                ),
                                profile: _deck[_topIndex + 1],
                                showShadow: false,
                              ),
                            ),
                          ),

                        if (remaining > 0)
                          GestureDetector(
                            onPanUpdate: _onDragUpdate,
                            onPanEnd: _onDragEnd,
                            child: FadeTransition(
                              opacity: _fade,
                              child: SlideTransition(
                                position: _slide,
                                child: Stack(
                                  children: [
                                    ProfileCard(
                                      key: ValueKey(
                                        _deck[_topIndex].id,
                                      ), 
                                      profile: _deck[_topIndex],
                                      angle: _dragOffset.dx / 20,
                                      offset: _dragOffset,
                                      onPass: () =>
                                          _handleDecision(Decision.pass),
                                      onLike: () =>
                                          _handleDecision(Decision.like),
                                      onSuperLike: () =>
                                          _handleDecision(Decision.superLike),
                                    ),

                                    // LIKE / NOPE badges
                                    Positioned(
                                      top: 14,
                                      left: 24,
                                      child: Opacity(
                                        opacity: likeOpacity,
                                        child: _Badge(
                                          text: 'LIKE',
                                          color: const Color(0xFF43A047),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 14,
                                      right: 24,
                                      child: Opacity(
                                        opacity: nopeOpacity,
                                        child: _Badge(
                                          text: 'NOPE',
                                          color: const Color(0xFFE53935),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum Decision { like, pass, superLike }

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
