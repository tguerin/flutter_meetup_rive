import 'dart:async';
import 'dart:math';

import '../rive/demo_flutter_minigame_viewmodel.rive.dart';

/// Plugs the "Find the A of hearts" gameplay onto [VmMiniGameViewModel]:
///   1. Dresses the three cards each round, hiding A♥ behind a random one.
///   2. Watches the per-card `isFaceVisibleStream` to detect the user's pick
///      (a single card going face-up while the other two stay face-down —
///      that filter cleanly skips the intro / restart reveal, which flips
///      all three together).
///   3. Fires `triggerWin` or `triggerLoose` on the parent view-model.
///   4. Re-randomizes for the next round once Rive's restart flow flips
///      all cards face-down again.
class MinigameController {
  MinigameController(this._vm) {
    _cards = [_vm.card1, _vm.card2, _vm.card3];
    for (final card in _cards) {
      _lastFaceVisible[card] = card.isFaceVisible;
      _subscriptions.add(
        card.isFaceVisibleStream.listen((v) => _onFaceVisibleChanged(card, v)),
      );
    }
    _setupRound();
  }

  /// Values used to dress the two losing cards. Anything that isn't the Ace
  /// would work; this pool keeps the reveal feeling like "court cards from
  /// the rest of the deck" rather than a sea of A's.
  static const _losingValues = <String>[
    'K',
    'Q',
    'J',
    '10',
    '9',
    '8',
    '7',
  ];

  static const _resolutionDelay = Duration(seconds: 1);

  final VmMiniGameViewModel _vm;
  late final List<VmCardViewModel> _cards;
  final List<StreamSubscription<bool>> _subscriptions = [];
  final Map<VmCardViewModel, bool> _lastFaceVisible = {};
  final Random _random = Random();

  /// True once the user has picked a card this round; flips back to false on
  /// the next round.
  bool _resolved = false;
  Timer? _resolutionTimer;
  bool _disposed = false;

  void _setupRound() {
    _resolved = false;

    final winnerIndex = _random.nextInt(_cards.length);
    final losers = _pickTwoDistinctLosers();
    var loserCursor = 0;

    for (var i = 0; i < _cards.length; i++) {
      if (i == winnerIndex) {
        _cards[i]
          ..valueCard = 'A'
          ..symbolsCard = SymbolsCard.heart;
      } else {
        final (value, suit) = losers[loserCursor++];
        _cards[i]
          ..valueCard = value
          ..symbolsCard = suit;
      }
    }
  }

  List<(String, SymbolsCard)> _pickTwoDistinctLosers() {
    final pool = <(String, SymbolsCard)>[
      for (final v in _losingValues)
        for (final s in SymbolsCard.values) (v, s),
    ];
    pool.shuffle(_random);
    return [pool[0], pool[1]];
  }

  void _onFaceVisibleChanged(VmCardViewModel card, bool faceVisible) {
    final wasVisible = _lastFaceVisible[card] ?? false;
    _lastFaceVisible[card] = faceVisible;

    if (_resolved) {
      // After resolution, wait for the BtRestart flow to flip everything
      // face-down before dealing a new round.
      if (!faceVisible && _cards.every((c) => !c.isFaceVisible)) {
        _setupRound();
      }
      return;
    }

    // A user pick = one card going face-up while the other two remain
    // face-down. The intro / restart animation flips all three together, so
    // it never satisfies this condition.
    final isUserPick = !wasVisible &&
        faceVisible &&
        _cards.where((c) => c != card).every((c) => !c.isFaceVisible);
    if (!isUserPick) return;

    _resolved = true;
    final isWinner =
        card.valueCard == 'A' && card.symbolsCard == SymbolsCard.heart;
    _resolutionTimer?.cancel();
    _resolutionTimer = Timer(_resolutionDelay, () {
      if (_disposed) return;
      if (isWinner) {
        _vm.triggerWin();
      } else {
        _vm.triggerLoose();
      }
    });
  }

  void dispose() {
    _disposed = true;
    _resolutionTimer?.cancel();
    _resolutionTimer = null;
    for (final s in _subscriptions) {
      s.cancel();
    }
    _subscriptions.clear();
  }
}
