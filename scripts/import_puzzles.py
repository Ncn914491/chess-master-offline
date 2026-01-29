import json
import csv
import io
import sys
import random
import os

try:
    import requests
except ImportError:
    requests = None

# Configuration
OUTPUT_FILE = 'assets/puzzles/puzzles.json'
TARGET_COUNT = 2000
MIN_POPULARITY = 80
MAX_RATING_DEVIATION = 100
LICHESS_DB_URL = 'https://database.lichess.org/lichess_db_puzzle.csv.zst'

# Fallback puzzles (if zstandard is missing or download fails)
FALLBACK_PUZZLES = [
    {
        "id": 1,
        "fen": "r1bqkb1r/pppp1ppp/2n2n2/4p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR w KQkq - 0 3",
        "moves": "h5f7",
        "rating": 400,
        "themes": "mateIn1,short,opening",
        "popularity": 81
    },
    {
        "id": 2,
        "fen": "r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5Q2/PPPP1PPP/RNB1K1NR b KQkq - 3 3",
        "moves": "f3f7",
        "rating": 450,
        "themes": "mateIn1,short,opening",
        "popularity": 85
    },
    {
        "id": 3,
        "fen": "rn1qkbnr/pbpp1ppp/1p6/4p3/2B1P3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 4",
        "moves": "f3f7",
        "rating": 500,
        "themes": "mateIn1,short,opening",
        "popularity": 90
    },
    {
        "id": 4,
        "fen": "rnb1kbnr/pp1ppppp/8/q1p5/2B1P3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 2 4",
        "moves": "f3f7",
        "rating": 600,
        "themes": "mateIn1,short,opening",
        "popularity": 88
    },
    {
        "id": 5,
        "fen": "rnbqkb1r/pp2pppp/3p1n2/2p5/2B1P3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 4",
        "moves": "f3f7",
        "rating": 650,
        "themes": "mateIn1,short,opening",
        "popularity": 82
    },
    {
        "id": 6,
        "fen": "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1",
        "moves": "e7e5 f2f4 e5f4 g1f3",
        "rating": 1500,
        "themes": "kingsGambit,opening",
        "popularity": 95
    },
    {
        "id": 7,
        "fen": "r2q1rk1/ppp2ppp/2n1bn2/2b1p3/4P3/2P2N2/PP1NBPPP/R1BQ1RK1 w - - 3 9",
        "moves": "b2b4 c5b6 a2a4 a7a5",
        "rating": 1600,
        "themes": "opening,middlegame",
        "popularity": 92
    },
    {
        "id": 8,
        "fen": "r1bq1rk1/pp2bppp/2n1pn2/8/3P4/P1N2N2/1P2BPPP/R1BQ1RK1 b - - 0 10",
        "moves": "a7a6 b2b4 b7b5 c1b2",
        "rating": 1550,
        "themes": "queensGambit,opening",
        "popularity": 88
    },
    {
        "id": 9,
        "fen": "rnbqkb1r/ppp2ppp/5n2/3p4/8/2N2N2/PPPP1PPP/R1BQKB1R w KQkq - 2 5",
        "moves": "d2d4 f8b4 c1d2 e8g8",
        "rating": 1450,
        "themes": "opening,development",
        "popularity": 91
    },
    {
        "id": 10,
        "fen": "r1bqk2r/pppp1ppp/2n2n2/4p3/1b2P3/2NP1N2/PPP2PPP/R1BQKB1R w KQkq - 1 5",
        "moves": "c1d2 e8g8 a2a3 b4c3",
        "rating": 1400,
        "themes": "opening,threeKnights",
        "popularity": 89
    },
    {
        "id": 11,
        "fen": "2r3k1/1p1q1p2/p3pQp1/3pP2p/3P3P/1P4P1/P4P2/2R3K1 w - - 1 29",
        "moves": "c1c8 d7c8 g1g2 c8c2",
        "rating": 1800,
        "themes": "endgame,equality",
        "popularity": 85
    },
    {
        "id": 12,
        "fen": "8/8/4k3/8/5K2/8/6P1/8 w - - 0 1",
        "moves": "f4g5 e6f7 g5h6 f7g8",
        "rating": 2000,
        "themes": "endgame,pawnEnding",
        "popularity": 80
    },
    {
        "id": 13,
        "fen": "8/p7/1p6/1P6/P7/8/4K3/k7 w - - 0 1",
        "moves": "e2d3 a1b2 d3c4 b2a3",
        "rating": 2100,
        "themes": "endgame,kingOpposition",
        "popularity": 82
    },
    {
        "id": 14,
        "fen": "8/5p2/4p3/4P1k1/4K3/8/8/8 w - - 1 1",
        "moves": "e4e3 g5f5 e3d4 f5f4",
        "rating": 2200,
        "themes": "endgame,zugzwang",
        "popularity": 85
    },
    {
        "id": 15,
        "fen": "r4rk1/pp1n1pp1/2p1pn1p/q6P/2PP4/3Q1NN1/PP3PP1/R3R1K1 w - - 1 17",
        "moves": "f3e5 d7e5 d4e5 f6g4",
        "rating": 1750,
        "themes": "middlegame,advantage",
        "popularity": 87
    }
]

def main():
    print(f"Starting puzzle import script...")

    if requests is None:
        print("requests library NOT found.")
        print("To download the full puzzle database, please install requests and zstandard:")
        print("  pip install requests zstandard")
        print("\nUsing sample puzzles for now...")
        save_puzzles(FALLBACK_PUZZLES)
        return

    try:
        import zstandard as zstd
        print("zstandard library found. Attempting to download and process full database...")

        try:
            download_and_process_puzzles(zstd)
        except Exception as e:
            print(f"Error downloading/processing puzzles: {e}")
            print("Falling back to sample puzzles.")
            save_puzzles(FALLBACK_PUZZLES)

    except ImportError:
        print("zstandard library NOT found.")
        print("To download the full puzzle database (2000+ puzzles), please install zstandard:")
        print("  pip install zstandard")
        print("  python3 scripts/import_puzzles.py")
        print("\nUsing sample puzzles for now...")
        save_puzzles(FALLBACK_PUZZLES)

def download_and_process_puzzles(zstd):
    if requests is None:
        raise ImportError("requests module not available")

    print(f"Downloading stream from {LICHESS_DB_URL}...")
    response = requests.get(LICHESS_DB_URL, stream=True)
    response.raise_for_status()

    dctx = zstd.ZstdDecompressor()
    reader = dctx.stream_reader(response.raw)
    text_reader = io.TextIOWrapper(reader, encoding='utf-8')
    csv_reader = csv.reader(text_reader)

    # Skip header if present (Lichess CSV usually has header)
    # Header: PuzzleId,FEN,Moves,Rating,RatingDeviation,Popularity,NbPlays,Themes,GameUrl,OpeningTags
    header = next(csv_reader, None)

    puzzles = []
    count = 0

    print("Processing puzzles...")
    for row in csv_reader:
        if len(puzzles) >= TARGET_COUNT:
            break

        if not row or len(row) < 9:
            continue

        # Parse fields
        puzzle_id_str = row[0]
        fen = row[1]
        moves = row[2]
        rating = int(row[3])
        rating_deviation = int(row[4])
        popularity = int(row[5])
        themes = row[7]

        # Filter
        if popularity < MIN_POPULARITY or rating_deviation > MAX_RATING_DEVIATION:
            continue

        # Convert ID to int if possible (Lichess IDs are strings like "00008")
        # We'll generate an incremental ID or hash
        # For simplicity in app model, use incremental
        count += 1

        puzzle = {
            "id": count,
            "fen": fen,
            "moves": moves,
            "rating": rating,
            "themes": themes,
            "popularity": popularity
        }

        puzzles.append(puzzle)

        if count % 100 == 0:
            print(f"Collected {count} puzzles...", end='\r')

    print(f"\nCollected {len(puzzles)} puzzles.")
    save_puzzles(puzzles)

def save_puzzles(puzzles):
    # Ensure directory exists
    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)

    with open(OUTPUT_FILE, 'w') as f:
        json.dump(puzzles, f, indent=2)

    print(f"Saved {len(puzzles)} puzzles to {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
