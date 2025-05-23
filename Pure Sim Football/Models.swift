//
//  Models.swift
//  Pure Sim Football
//
//  Created by Jay Estep on 5/22/25.
//

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
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.position == rhs.position &&
               lhs.overall == rhs.overall && lhs.age == rhs.age && lhs.potential == rhs.potential
    }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct Team: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var location: String
    var players: [Player]
    var colorHex: String

    var conferenceId: Int? = nil
    var divisionId: Int? = nil

    // Standings and Record Properties
    var wins: Int = 0
    var losses: Int = 0
    var ties: Int = 0 // Added for completeness, sim engine can decide if ties are possible
    
    var pointsFor: Int = 0
    var pointsAgainst: Int = 0
    
    var divisionalWins: Int = 0
    var divisionalLosses: Int = 0
    var divisionalTies: Int = 0
    
    var conferenceWins: Int = 0
    var conferenceLosses: Int = 0
    var conferenceTies: Int = 0
    
    // Head-to-head tracking: [OpponentTeamID: WinsAgainstThem]
    // This can get complex to manage directly here for multi-way ties.
    // For now, we'll calculate H2H on-the-fly when sorting.
    // We can store a list of opponents beaten / lost to if needed:
    var opponentsBeaten: [UUID] = []
    var opponentsLostTo: [UUID] = []
    var opponentsTiedWith: [UUID] = []

    var gamesPlayed: Int { wins + losses + ties }
    var pointsDifferential: Int { pointsFor - pointsAgainst }
    var winPercentage: Double {
        guard gamesPlayed > 0 else { return 0.0 }
        return (Double(wins) + (Double(ties) * 0.5)) / Double(gamesPlayed)
    }
    var divisionalRecordString: String { "\(divisionalWins)-\(divisionalLosses)-\(divisionalTies)"}
    var conferenceRecordString: String { "\(conferenceWins)-\(conferenceLosses)-\(conferenceTies)"}


    var overallRating: Int {
        guard !players.isEmpty else { return 50 }
        return players.map { $0.overall }.reduce(0, +) / players.count
    }
    var color: Color { Color(hex: colorHex) ?? .gray }

    // Reset stats for a new season
    mutating func resetSeasonStats() {
        wins = 0; losses = 0; ties = 0
        pointsFor = 0; pointsAgainst = 0
        divisionalWins = 0; divisionalLosses = 0; divisionalTies = 0
        conferenceWins = 0; conferenceLosses = 0; conferenceTies = 0
        opponentsBeaten = []; opponentsLostTo = []; opponentsTiedWith = []
    }

    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.location == rhs.location &&
               lhs.players == rhs.players && lhs.colorHex == rhs.colorHex &&
               lhs.conferenceId == rhs.conferenceId && lhs.divisionId == rhs.divisionId &&
               lhs.wins == rhs.wins && lhs.losses == rhs.losses && lhs.ties == rhs.ties && // Added record props
               lhs.pointsFor == rhs.pointsFor && lhs.pointsAgainst == rhs.pointsAgainst &&
               lhs.divisionalWins == rhs.divisionalWins && lhs.divisionalLosses == rhs.divisionalLosses && lhs.divisionalTies == rhs.divisionalTies &&
               lhs.conferenceWins == rhs.conferenceWins && lhs.conferenceLosses == rhs.conferenceLosses && lhs.conferenceTies == rhs.conferenceTies &&
               lhs.opponentsBeaten == rhs.opponentsBeaten && lhs.opponentsLostTo == rhs.opponentsLostTo && lhs.opponentsTiedWith == rhs.opponentsTiedWith
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id); hasher.combine(name); hasher.combine(location); hasher.combine(players)
        hasher.combine(colorHex); hasher.combine(conferenceId); hasher.combine(divisionId)
        hasher.combine(wins); hasher.combine(losses); hasher.combine(ties) // Added record props
        hasher.combine(pointsFor); hasher.combine(pointsAgainst)
        hasher.combine(divisionalWins); hasher.combine(divisionalLosses); hasher.combine(divisionalTies)
        hasher.combine(conferenceWins); hasher.combine(conferenceLosses); hasher.combine(conferenceTies)
        hasher.combine(opponentsBeaten); hasher.combine(opponentsLostTo); hasher.combine(opponentsTiedWith)
    }
}

struct Game: Codable, Identifiable, Hashable { // No changes from your last correct version
    var id = UUID(); var week: Int
    var homeTeamID: UUID; var awayTeamID: UUID
    var homeTeamName: String; var awayTeamName: String
    var homeTeamLocation: String; var awayTeamLocation: String
    var homeScore: Int?; var awayScore: Int?
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
    var gamesPerSeason: Int = 17
    var currentSeasonYear: Int = 2025
    var numberOfConferences: Int = 2
    var divisionsPerConference: Int = 4
    
    // New properties for season simulation flow
    var currentWeek: Int = 1 // Start at week 1
    var tradeDeadlineWeek: Int { gamesPerSeason / 2 + 1 } // Example: Week 9 for a 17-game season
    var playoffStartWeek: Int { gamesPerSeason + 1 } // After all regular season games

    static func == (lhs: League, rhs: League) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.teams == rhs.teams &&
               lhs.isCommissionerMode == rhs.isCommissionerMode && lhs.userTeamId == rhs.userTeamId &&
               lhs.schedule == rhs.schedule && lhs.gamesPerSeason == rhs.gamesPerSeason &&
               lhs.currentSeasonYear == rhs.currentSeasonYear &&
               lhs.numberOfConferences == rhs.numberOfConferences &&
               lhs.divisionsPerConference == rhs.divisionsPerConference &&
               lhs.currentWeek == rhs.currentWeek // Added
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id); hasher.combine(name); hasher.combine(teams)
        hasher.combine(isCommissionerMode); hasher.combine(userTeamId)
        hasher.combine(schedule); hasher.combine(gamesPerSeason)
        hasher.combine(currentSeasonYear); hasher.combine(numberOfConferences); hasher.combine(divisionsPerConference)
        hasher.combine(currentWeek) // Added
    }
}

struct SaveSlot: Codable, Identifiable, Hashable { /* ... (no changes) ... */
    var id: Int; var leagueName: String?; var lastModified: Date?;
    var isEmpty: Bool { leagueName == nil && lastModified == nil }
    var leagueFileName: String { "league_slot_\(id).json" }
    var logoFileName: String { "logo_slot_\(id).png" }
    init(id: Int, leagueName: String? = nil, lastModified: Date? = nil) {
        self.id = id; self.leagueName = leagueName; self.lastModified = lastModified
    }
    static func == (lhs: SaveSlot, rhs: SaveSlot) -> Bool { lhs.id == rhs.id && lhs.leagueName == rhs.leagueName && lhs.lastModified == rhs.lastModified }
    func hash(into hasher: inout Hasher) { hasher.combine(id); hasher.combine(leagueName); hasher.combine(lastModified) }
}
extension Color { /* ... (no changes) ... */
    init?(hex: String) {
        var h = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased(); if h.hasPrefix("#"){h.removeFirst()}; var r:UInt64 = 0
        guard Scanner(string:h).scanHexInt64(&r) else {return nil}; let R,G,B:Double
        switch h.count { case 6:R=Double((r & 0xFF0000)>>16)/255;G=Double((r & 0x00FF00)>>8)/255;B=Double(r & 0x0000FF)/255; default:return nil }
        self.init(red:R,green:G,blue:B)
    }
    func toHex() -> String? {
        let c=UIColor(self); var R,G,B,A:CGFloat(0); guard c.getRed(&R,green:&G,blue:&B,alpha:&A) else{return nil}
        return String(format:"#%02X%02X%02X",Int(R*255),Int(G*255),Int(B*255))
    }
}
