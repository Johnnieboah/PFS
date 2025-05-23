// Models.swift

import SwiftUI
import Foundation

struct Player: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var position: String
    var overall: Int
    var age: Int
    var potential: Int

    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.position == rhs.position &&
               lhs.overall == rhs.overall &&
               lhs.age == rhs.age &&
               lhs.potential == rhs.potential
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Team: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var location: String
    var players: [Player]
    var colorHex: String

    var conferenceId: Int? = nil // 0 for first conference, 1 for second, etc.
    var divisionId: Int? = nil   // 0 for first division in conf, 1 for second, etc.

    // Standings and Record Properties
    var wins: Int = 0
    var losses: Int = 0
    var ties: Int = 0
    
    var pointsFor: Int = 0
    var pointsAgainst: Int = 0
    
    var divisionalWins: Int = 0
    var divisionalLosses: Int = 0
    var divisionalTies: Int = 0
    
    var conferenceWins: Int = 0
    var conferenceLosses: Int = 0
    var conferenceTies: Int = 0
    
    var opponentsBeaten: [UUID] = []
    var opponentsLostTo: [UUID] = []
    var opponentsTiedWith: [UUID] = []

    // Computed Properties for Standings
    var gamesPlayed: Int { wins + losses + ties }
    var pointsDifferential: Int { pointsFor - pointsAgainst }
    
    var winPercentage: Double {
        guard gamesPlayed > 0 else { return 0.0 }
        // Standard win percentage calculation, treating ties as half a win
        return (Double(wins) + (Double(ties) * 0.5)) / Double(gamesPlayed)
    }
    
    var divisionalRecordString: String { "\(divisionalWins)-\(divisionalLosses)\(divisionalTies > 0 ? "-\(divisionalTies)" : "")" }
    var conferenceRecordString: String { "\(conferenceWins)-\(conferenceLosses)\(conferenceTies > 0 ? "-\(conferenceTies)" : "")" }

    var overallRating: Int {
        guard !players.isEmpty else { return Int.random(in: 40...60) } // Default for empty team
        let sum = players.map { $0.overall }.reduce(0, +)
        return sum / players.count
    }

    var color: Color { Color(hex: colorHex) ?? .gray }

    mutating func resetSeasonStats() {
        wins = 0; losses = 0; ties = 0
        pointsFor = 0; pointsAgainst = 0
        divisionalWins = 0; divisionalLosses = 0; divisionalTies = 0
        conferenceWins = 0; conferenceLosses = 0; conferenceTies = 0
        opponentsBeaten = []; opponentsLostTo = []; opponentsTiedWith = []
    }

    // Equatable: Only ID is usually enough for identifiable items if content can change
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.id == rhs.id // If you need full content equality, add other properties
    }

    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Only hash ID for simplicity if using in Sets/Dictionaries by identity
    }
}

struct Game: Codable, Identifiable, Hashable {
    var id = UUID()
    var week: Int
    var homeTeamID: UUID
    var awayTeamID: UUID
    var homeTeamName: String // Denormalized for easier display if needed
    var awayTeamName: String // Denormalized
    var homeTeamLocation: String // Denormalized
    var awayTeamLocation: String // Denormalized
    var homeScore: Int?
    var awayScore: Int?

    var isPlayed: Bool { homeScore != nil && awayScore != nil }

    static func == (lhs: Game, rhs: Game) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct League: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var teams: [Team]
    var isCommissionerMode: Bool = false
    var userTeamId: UUID? = nil
    var schedule: [Game] = []
    
    var gamesPerSeason: Int = 17       // e.g., 17 games
    var currentSeasonYear: Int = 2025
    var numberOfConferences: Int = 2   // e.g., AFC, NFC
    var divisionsPerConference: Int = 4 // e.g., East, North, South, West
    
    var currentWeek: Int = 1
    var tradeDeadlineWeek: Int { (gamesPerSeason / 2) + 1 } // Approx mid-season
    var playoffStartWeek: Int { gamesPerSeason + 1 }     // Week after regular season ends

    // Equatable: Only ID is usually enough
    static func == (lhs: League, rhs: League) -> Bool { lhs.id == rhs.id }
    
    // Hashable
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct SaveSlot: Codable, Identifiable, Hashable {
    var id: Int // Slot number (e.g., 0, 1, 2)
    var leagueName: String?
    var lastModified: Date?

    var isEmpty: Bool { leagueName == nil && lastModified == nil }
    var leagueFileName: String { "league_slot_\(id).json" }
    var logoFileName: String { "logo_slot_\(id).png" }

    init(id: Int, leagueName: String? = nil, lastModified: Date? = nil) {
        self.id = id
        self.leagueName = leagueName
        self.lastModified = lastModified
    }

    static func == (lhs: SaveSlot, rhs: SaveSlot) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        var r: Double = 0.0
        var g: Double = 0.0
        var b: Double = 0.0
        // Alpha component is not handled by this simple version, assumes full opacity
        // var a: Double = 1.0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if hexSanitized.count == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
        } else {
            // You could add support for 3-digit hex or 8-digit hex (with alpha) here if needed
            return nil // Unsupported hex format length
        }

        self.init(red: r, green: g, blue: b)
    }

    func toHex() -> String? {
        // Using UIColor to get components is reliable
        let uiColor = UIColor(self)
        var redComponent: CGFloat = 0
        var greenComponent: CGFloat = 0
        var blueComponent: CGFloat = 0
        var alphaComponent: CGFloat = 0

        guard uiColor.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent) else {
            // Failed to get components
            return nil
        }

        // Convert CGFloat components (0.0-1.0) to Int (0-255) and format as hex
        // lround is used for proper rounding of float to integer
        let r = lround(Double(redComponent * 255))
        let g = lround(Double(greenComponent * 255))
        let b = lround(Double(blueComponent * 255))

        return String(format: "#%02lX%02lX%02lX", r, g, b)
    }
}
