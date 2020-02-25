import Foundation

enum Rank: Int, CustomStringConvertible, CaseIterable, Comparable {
    case ace = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case jack = 11
    case queen = 12
    case king = 13
    
    var description: String {
        switch self {
        case .ace:
            return "ace"
        case .jack:
        return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        default:
            return String(rawValue)
        }
    }
    
    static func < (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    static func == (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
//    static var allRanks: [Rank] {
//        return [.ace, .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king]
//    }
}

enum Suit: String, CaseIterable {
    case hearts = "hearts"
    case diamonds = "diamonds"
    case spades = "spades"
    case clubs = "clubs"
    
//    static var allSuits: [Suit] {
//        return [.spades, .hearts, .diamonds, .clubs]
//    }
}

struct Card: CustomStringConvertible, Comparable {
    var rank: Rank
    var suit: Suit
    
    init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }
    
    var description: String {
        return "\(self.rank) of \(self.suit)"
    }
    
    static func < (lhs: Card, rhs: Card) -> Bool {
        if lhs.rank < rhs.rank {
            return true
        } else if lhs.rank > rhs.rank {
            return false
        } else {
            switch lhs.suit.rawValue {
            case "clubs":
                if rhs.suit.rawValue == "clubs" {
                    return false
                } else {
                    return true
                }
            case "diamonds":
                if rhs.suit.rawValue == "clubs" || rhs.suit.rawValue == "diamonds" {
                    return false
                } else {
                    return true
                }
            case "hearts":
                if rhs.suit.rawValue == "spades" {
                    return true
                } else {
                    return false
                }
            case "spades":
                return false
            default:
                return false
            }
        }
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.rank == rhs.rank && lhs.suit.rawValue == rhs.suit.rawValue
    }
}

struct Deck {
    var cards: [Card] = []
    
    init() {
        for singleRank in Rank.allCases {
            for singleSuit in Suit.allCases {
                self.cards.append(Card(rank: singleRank, suit: singleSuit))
            }
        }
    }
    
//    init() {
//        for singleRank in Rank.allRanks {
//            for singleSuit in Suit.allSuits {
//                cards.append(Card(rank: singleRank, suit: singleSuit))
//            }
//        }
//    }
    
    func drawCard() -> Card {
        return cards[Int.random(in: 0...51)]
    }
    
}

protocol CardGame {
    var deck: Deck { get }
    func play()
}

protocol CardGameDelegate {
    func gameDidStart(_ game: CardGame)
    func game(player1DidDraw card1: Card, player2DidDraw card2: Card)
}

class HighLow: CardGame {
    var deck: Deck = Deck()
    var delegate: CardGameDelegate?
    
    func play() {
        delegate?.gameDidStart(self)
        
        let card1 = deck.drawCard()
        let card2 = deck.drawCard()
        
        delegate?.game(player1DidDraw: card1, player2DidDraw: card2)
        
        if card1 == card2 {
            print("Round ends in a tie with a \(card1.description)")
        } else if card1 < card2 {
            print("Player 2 wins with a \(card2.description)")
        } else {
            print("Player 1 wins with a \(card1.description)")
        }
    }
    
}


class CardGameTracker: CardGameDelegate {
    func gameDidStart(_ game: CardGame) {
        if game is HighLow {
            print("Started a new game of High Low")
        }
    }
    
    func game(player1DidDraw card1: Card, player2DidDraw card2: Card) {
        print("Player 1 drew a \(card1.description), player 2 drew a \(card2.description)")
    }
    
    
}


let tracker = CardGameTracker()
let game = HighLow()

game.delegate = tracker
game.play()
game.play()
game.play()
game.play()
game.play()
