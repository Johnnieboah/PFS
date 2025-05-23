// StandingsView.swift

import SwiftUI

struct StandingsView: View {
    let league: League // Expects the full League object from DynastyHubView

    // Helper struct to organize teams for display
    struct ConferenceStandings: Identifiable {
        let id: Int // Conference ID (e.g., 0 for NFC, 1 for AFC)
        var name: String
        var divisions: [DivisionStandings]
    }

    struct DivisionStandings: Identifiable {
        let id: Int // Division ID (e.g., 0 for East, 1 for North, etc.)
        var name: String
        var teams: [Team] // Teams will be sorted for standings
    }

    // Computed property to process and sort teams into standings format
    private var conferenceStandings: [ConferenceStandings] {
        guard !league.teams.isEmpty else { return [] }

        var result: [ConferenceStandings] = []

        // Group teams by their conferenceId
        // Assuming conferenceId 0 = "NFC" (or your first conf), 1 = "AFC" (or your second conf)
        // You can map these IDs to actual names later if needed.
        let teamsByConferenceId = Dictionary(grouping: league.teams, by: { $0.conferenceId ?? -1 })

        for confId in teamsByConferenceId.keys.sorted() { // Sort by confId to ensure consistent order
            guard let conferenceTeams = teamsByConferenceId[confId], confId != -1 else { continue }
            
            // You can have a more sophisticated way to name conferences if your League model supports it
            let conferenceName = league.numberOfConferences > 1 ? "Conference \(confId + 1)" : "League Standings"


            var currentConference = ConferenceStandings(id: confId, name: conferenceName, divisions: [])

            // Group teams within this conference by their divisionId
            // Assuming divisionId 0 = "East", 1 = "North", etc.
            let teamsByDivisionId = Dictionary(grouping: conferenceTeams, by: { $0.divisionId ?? -1 })

            for divId in teamsByDivisionId.keys.sorted() { // Sort by divId
                guard var divisionTeams = teamsByDivisionId[divId], divId != -1 else { continue }
                
                // --- Sorting Logic within Division ---
                divisionTeams.sort { t1, t2 in
                    // 1. Win Percentage (higher is better)
                    if t1.winPercentage != t2.winPercentage {
                        return t1.winPercentage > t2.winPercentage
                    }
                    
                    // Note: Full NFL tie-breaking is very complex (H2H, Strength of Vic, etc.)
                    // We'll implement a common subset. H2H requires game analysis.

                    // 2. Divisional Win Percentage (higher is better)
                    // Calculate divisional win percentage on the fly for sorting
                    let t1DivGames = t1.divisionalWins + t1.divisionalLosses + t1.divisionalTies
                    let t1DivPct = t1DivGames > 0 ? (Double(t1.divisionalWins) + Double(t1.divisionalTies) * 0.5) / Double(t1DivGames) : 0.0
                    
                    let t2DivGames = t2.divisionalWins + t2.divisionalLosses + t2.divisionalTies
                    let t2DivPct = t2DivGames > 0 ? (Double(t2.divisionalWins) + Double(t2.divisionalTies) * 0.5) / Double(t2DivGames) : 0.0
                    
                    if t1DivPct != t2DivPct {
                        return t1DivPct > t2DivPct
                    }

                    // 3. Conference Win Percentage (higher is better)
                    let t1ConfGames = t1.conferenceWins + t1.conferenceLosses + t1.conferenceTies
                    let t1ConfPct = t1ConfGames > 0 ? (Double(t1.conferenceWins) + Double(t1.conferenceTies) * 0.5) / Double(t1ConfGames) : 0.0
                    
                    let t2ConfGames = t2.conferenceWins + t2.conferenceLosses + t2.conferenceTies
                    let t2ConfPct = t2ConfGames > 0 ? (Double(t2.conferenceWins) + Double(t2.conferenceTies) * 0.5) / Double(t2ConfGames) : 0.0
                    
                    if t1ConfPct != t2ConfPct {
                        return t1ConfPct > t2ConfPct
                    }
                    
                    // 4. Points Differential (higher is better)
                    if t1.pointsDifferential != t2.pointsDifferential {
                        return t1.pointsDifferential > t2.pointsDifferential
                    }
                    
                    // 5. Points For (higher is better)
                    if t1.pointsFor != t2.pointsFor {
                        return t1.pointsFor > t2.pointsFor
                    }
                    
                    // Fallback: Team name alphabetically for stable sort if all else is equal
                    return t1.name < t2.name
                }
                // --- End Sorting Logic ---
                
                // You can have a more sophisticated way to name divisions
                let divisionName = league.divisionsPerConference > 1 ? "Division \(divId + 1)" : conferenceName // If only 1 div, use conf name
                currentConference.divisions.append(DivisionStandings(id: divId, name: divisionName, teams: divisionTeams))
            }
            // Sort divisions by their ID within the conference for consistent display
            currentConference.divisions.sort { $0.id < $1.id }
            result.append(currentConference)
        }
        // Sort conferences by their ID
        result.sort { $0.id < $1.id }
        return result
    }

    var body: some View {
        List {
            if conferenceStandings.isEmpty {
                ContentUnavailableView(
                    "No Standings Available",
                    systemImage: "list.star",
                    description: Text("Teams might not be generated, assigned to conferences/divisions, or no games have been played.")
                )
            } else {
                ForEach(conferenceStandings) { conference in
                    Section { // Use Section directly for Conference header
                        ForEach(conference.divisions) { division in
                            // Header for each division
                            Section(header: Text("\(conference.name) - \(division.name)").font(.headline).padding(.vertical, 2)) {
                                // Header row for stats
                                TeamStandingsHeaderRow()
                                ForEach(division.teams) { team in
                                    // NavigationLink to a detailed team view (optional)
                                    // For now, just displays row. Replace with NavigationLink if desired.
                                    TeamStandingsRowView(team: team)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Standings - \(league.name)")
        // .listStyle(.plain) // Consider .plain or .insetGroupedListStyle()
    }
}

// Header Row for the stats columns
struct TeamStandingsHeaderRow: View {
    var body: some View {
        HStack {
            Text("Team")
                .font(.caption.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Text("W-L-T")
                .font(.caption.bold())
                .frame(width: 70, alignment: .trailing)
            Text("PCT")
                .font(.caption.bold())
                .frame(width: 55, alignment: .trailing)
            Text("PF")
                .font(.caption.bold())
                .frame(width: 40, alignment: .trailing)
            Text("PA")
                .font(.caption.bold())
                .frame(width: 40, alignment: .trailing)
            Text("DIFF")
                .font(.caption.bold())
                .frame(width: 45, alignment: .trailing)
            Text("DIV")
                .font(.caption.bold())
                .frame(width: 60, alignment: .trailing)
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 2)
        .foregroundColor(.secondary) // Make header text a bit muted
    }
}

// Row for displaying each team's standings
struct TeamStandingsRowView: View {
    let team: Team

    var body: some View {
        HStack {
            Circle()
                .fill(team.color) // Assumes Team struct has a 'color: Color' property from colorHex
                .frame(width: 12, height: 12)
            Text("\(team.location) \(team.name)")
                .font(.callout)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Text("\(team.wins)-\(team.losses)\(team.ties > 0 ? "-\(team.ties)" : "")")
                .font(.footnote)
                .frame(width: 70, alignment: .trailing)
            Text(String(format: "%.3f", team.winPercentage).replacingOccurrences(of: "0.", with: ".")) // Format like .750
                 .font(.footnote)
                 .frame(width: 55, alignment: .trailing)
            Text("\(team.pointsFor)")
                .font(.footnote)
                .frame(width: 40, alignment: .trailing)
            Text("\(team.pointsAgainst)")
                .font(.footnote)
                .frame(width: 40, alignment: .trailing)
            Text("\(team.pointsDifferential)")
                .font(.footnote)
                .frame(width: 45, alignment: .trailing)
                .foregroundColor(team.pointsDifferential >= 0 ? .green.opacity(0.9) : .red.opacity(0.9))
            Text("\(team.divisionalWins)-\(team.divisionalLosses)\(team.divisionalTies > 0 ? "-\(team.divisionalTies)" : "")")
                .font(.footnote)
                .frame(width: 60, alignment: .trailing)
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 3)
    }
}

// --- Preview Provider ---
// To make this preview work, you'll need to have sample data.
// You can create a static function in your League model or here to generate it.
// struct StandingsView_Previews: PreviewProvider {
//    static func createSampleLeagueForStandings() -> League {
//        var teams: [Team] = [
//            // Conference 0, Division 0
//            Team(name: "Eagles", location: "Philadelphia", players: [], colorHex: "#004C54", conferenceId: 0, divisionId: 0, wins: 5, losses: 1, ties: 0, pointsFor: 180, pointsAgainst: 120, divisionalWins: 2, divisionalLosses: 0),
//            Team(name: "Cowboys", location: "Dallas", players: [], colorHex: "#002244", conferenceId: 0, divisionId: 0, wins: 4, losses: 2, ties: 0, pointsFor: 170, pointsAgainst: 130, divisionalWins: 1, divisionalLosses: 1),
//            Team(name: "Giants", location: "New York", players: [], colorHex: "#0B2265", conferenceId: 0, divisionId: 0, wins: 2, losses: 4, ties: 0, pointsFor: 100, pointsAgainst: 150, divisionalWins: 0, divisionalLosses: 2),
//            // Conference 0, Division 1
//            Team(name: "Packers", location: "Green Bay", players: [], colorHex: "#203731", conferenceId: 0, divisionId: 1, wins: 6, losses: 0, ties: 0, pointsFor: 200, pointsAgainst: 100, divisionalWins: 2, divisionalLosses: 0),
//            Team(name: "Vikings", location: "Minnesota", players: [], colorHex: "#4F2683", conferenceId: 0, divisionId: 1, wins: 3, losses: 3, ties: 0, pointsFor: 150, pointsAgainst: 140, divisionalWins: 0, divisionalLosses: 1),
//            // Conference 1, Division 0
//            Team(name: "Chiefs", location: "Kansas City", players: [], colorHex: "#E31837", conferenceId: 1, divisionId: 0, wins: 5, losses: 1, ties: 0, pointsFor: 190, pointsAgainst: 110, divisionalWins: 1, divisionalLosses: 0),
//            Team(name: "Bills", location: "Buffalo", players: [], colorHex: "#00338D", conferenceId: 1, divisionId: 0, wins: 5, losses: 1, ties: 0, pointsFor: 185, pointsAgainst: 115, divisionalWins: 0, divisionalLosses: 1),
//        ]
//        return League(name: "Preview NFL", teams: teams, gamesPerSeason: 17, numberOfConferences: 2, divisionsPerConference: 2)
//    }
//
//    static var previews: some View {
//        NavigationView {
//            StandingsView(league: createSampleLeagueForStandings())
//        }
//    }
// }
