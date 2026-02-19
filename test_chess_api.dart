import 'package:chess/chess.dart' as chess;

void main() {
  print(chess.Chess.validate_fen('startpos'));
  final board = chess.Chess();
  // print(board.validate()); // Check if this exists
}
