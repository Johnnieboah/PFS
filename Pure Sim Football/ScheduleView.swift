import SwiftUI

struct ScheduleView: View {
    @Binding var league: League

    private var gamesByWeek: [Int: [Game]] {
        Dictionary(grouping: league.schedule, by: { $0.week })
    }
    private var sortedWeeks: [Int] { gamesByWeek.keys.sorted() }

    // Find the next week that has unplayed games
    private var nextUnplayedWeek: Int? {
        for week in league.currentWeek...league.gamesPerSeason {
            if gamesByWeek[week]?.contains(where: { !$0.isPlayed }) == true {
                return week
            }
        }
        // If currentWeek is beyond gamesPerSeason, or all games in current/future weeks are played
        if league.currentWeek > league.gamesPerSeason && !allGamesPlayed() { // Check if there are ANY unplayed games left from previous weeks
             return league.schedule.filter { !$0.isPlayed }.map { $0.week }.min()
        }
        return nil // All games up to end of season might be played or no unplayed games in future weeks
    }
    
    private func allGamesPlayed() -> Bool {
        league.schedule.allSatisfy { $0.isPlayed }
    }

    var body: some View {
        List {
            Section(header: Text("Season Progress: Week \(league.currentWeek) / \(league.gamesPerSeason)")) {
                if league.schedule.isEmpty {
                    Text("No schedule generated yet for \(league.name).").foregroundColor(.gray).padding()
                } else {
                    ForEach(sortedWeeks, id: \.self) { weekNumber in
                        // Only show current week and future weeks, or all weeks if preferred
                        // For now, showing all weeks for simplicity
                        Section(header: Text("Week \(weekNumber)")) {
                            ForEach(gamesByWeek[weekNumber] ?? []) { game in
                                GameRowView(game: game, homeTeam: team(byId: game.homeTeamID), awayTeam: team(byId: game.awayTeamID))
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("\(league.name) Schedule")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) { // Using bottomBar for sim controls
                Button("Sim Week") { simulateCurrentWeek() }
                    .disabled(nextUnplayedWeek == nil || nextUnplayedWeek! > league.gamesPerSeason)

                Button("To Mid-Season") { simulateToWeek(league.tradeDeadlineWeek) }
                    .disabled(nextUnplayedWeek == nil || nextUnplayedWeek! >= league.tradeDeadlineWeek || nextUnplayedWeek! > league.gamesPerSeason)

                Button("To Playoffs") { simulateToWeek(league.playoffStartWeek - 1) } // Sim to end of regular season
                    .disabled(nextUnplayedWeek == nil || allGamesPlayed())
                
                Spacer() // Pushes to leading/trailing if not enough items
                
                Button { resetSchedule() } label: { Image(systemName: "arrow.counterclockwise") }
            }
        }
    }

    func team(byId id: UUID) -> Team? {
        league.teams.first(where: { $0.id == id })
    }

    func updateTeamStats(homeTeamID: UUID, awayTeamID: UUID, homeScore: Int, awayScore: Int) {
        guard let homeTeamIndex = league.teams.firstIndex(where: { $0.id == homeTeamID }),
              let awayTeamIndex = league.teams.firstIndex(where: { $0.id == awayTeamID }) else {
            print("Error: Could not find teams to update stats.")
            return
        }

        // Update points
        league.teams[homeTeamIndex].pointsFor += homeScore
        league.teams[homeTeamIndex].pointsAgainst += awayScore
        league.teams[awayTeamIndex].pointsFor += awayScore
        league.teams[awayTeamIndex].pointsAgainst += homeScore

        // Update Win/Loss/Tie
        if homeScore > awayScore {
            league.teams[homeTeamIndex].wins += 1
            league.teams[homeTeamIndex].opponentsBeaten.append(awayTeamID)
            league.teams[awayTeamIndex].losses += 1
            league.teams[awayTeamIndex].opponentsLostTo.append(homeTeamID)
        } else if awayScore > homeScore {
            league.teams[awayTeamIndex].wins += 1
            league.teams[awayTeamIndex].opponentsBeaten.append(homeTeamID)
            league.teams[homeTeamIndex].losses += 1
            league.teams[homeTeamIndex].opponentsLostTo.append(awayTeamID)
        } else { // Tie
            league.teams[homeTeamIndex].ties += 1
            league.teams[awayTeamIndex].ties += 1
            league.teams[homeTeamIndex].opponentsTiedWith.append(awayTeamID)
            league.teams[awayTeamIndex].opponentsTiedWith.append(homeTeamID)
        }

        // Update Divisional/Conference Records
        let homeTeam = league.teams[homeTeamIndex]
        let awayTeam = league.teams[awayTeamIndex]

        let isConferenceGame = homeTeam.conferenceId == awayTeam.conferenceId
        let isDivisionalGame = isConferenceGame && homeTeam.divisionId == awayTeam.divisionId

        if isDivisionalGame {
            if homeScore > awayScore {
                league.teams[homeTeamIndex].divisionalWins += 1
                league.teams[awayTeamIndex].divisionalLosses += 1
            } else if awayScore > homeScore {
                league.teams[awayTeamIndex].divisionalWins += 1
                league.teams[homeTeamIndex].divisionalLosses += 1
            } else {
                league.teams[homeTeamIndex].divisionalTies += 1
                league.teams[awayTeamIndex].divisionalTies += 1
            }
        }
        if isConferenceGame { // All divisional games are also conference games
            if homeScore > awayScore {
                league.teams[homeTeamIndex].conferenceWins += 1
                league.teams[awayTeamIndex].conferenceLosses += 1
            } else if awayScore > homeScore {
                league.teams[awayTeamIndex].conferenceWins += 1
                league.teams[homeTeamIndex].conferenceLosses += 1
            } else {
                league.teams[homeTeamIndex].conferenceTies += 1
                league.teams[awayTeamIndex].conferenceTies += 1
            }
        }
    }

    func simulateGamesForWeek(_ weekNum: Int) {
        guard weekNum <= league.gamesPerSeason else {
            print("Cannot simulate week \(weekNum), season only has \(league.gamesPerSeason) games.")
            return
        }
        print("Simulating games for Week \(weekNum)...")
        for i in league.schedule.indices {
            if league.schedule[i].week == weekNum && !league.schedule[i].isPlayed {
                guard let homeTeam = team(byId: league.schedule[i].homeTeamID),
                      let awayTeam = team(byId: league.schedule[i].awayTeamID) else {
                    print("Error finding teams for game in week \(weekNum)")
                    continue
                }
                let (hScore, aScore) = SimulationEngine.simulateGame(homeTeam: homeTeam, awayTeam: awayTeam)
                league.schedule[i].homeScore = hScore
                league.schedule[i].awayScore = aScore
                updateTeamStats(homeTeamID: homeTeam.id, awayTeamID: awayTeam.id, homeScore: hScore, awayScore: aScore)
            }
        }
        if league.currentWeek == weekNum { // Only advance currentWeek if we simulated the current one
             if weekNum < league.gamesPerSeason {
                league.currentWeek += 1
            } else if weekNum == league.gamesPerSeason && allGamesPlayed() {
                 league.currentWeek = league.playoffStartWeek // Season over, move to playoffs week
                 print("Regular season finished. Current week set to: \(league.currentWeek)")
            }
        }
        print("Finished simulating Week \(weekNum). League current week is now: \(league.currentWeek)")
    }

    func simulateCurrentWeek() {
        if let weekToSim = nextUnplayedWeek, weekToSim <= league.gamesPerSeason {
            simulateGamesForWeek(weekToSim)
        } else {
            print("No more games to simulate in the current week or season is over.")
        }
    }
    
    func simulateToWeek(_ targetWeek: Int) {
        guard let startWeek = nextUnplayedWeek, startWeek <= targetWeek, startWeek <= league.gamesPerSeason else {
            print("Cannot simulate to week \(targetWeek). Current sim week: \(league.currentWeek) or target is invalid.")
            return
        }
        print("Simulating from week \(startWeek) up to week \(targetWeek)...")
        for weekNum in startWeek...min(targetWeek, league.gamesPerSeason) {
            // Check if all games in this week are already played before trying to sim
            let gamesInThisWeek = league.schedule.filter { $0.week == weekNum }
            if gamesInThisWeek.
