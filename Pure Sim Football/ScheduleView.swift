// ScheduleView.swift

import SwiftUI

struct GameRowView: View {
    let game: Game
    let homeTeam: Team?
    let awayTeam: Team?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Circle().fill(awayTeam?.color ?? .gray).frame(width: 10, height: 10)
                    Text("\(game.awayTeamLocation) \(game.awayTeamName)")
                }
                Text("@").font(.caption).foregroundColor(.gray).padding(.leading, 15)
                 HStack {
                    Circle().fill(homeTeam?.color ?? .gray).frame(width: 10, height: 10)
                    Text("\(game.homeTeamLocation) \(game.homeTeamName)")
                }
            }
            Spacer()
            if game.isPlayed {
                Text("\(game.awayScore ?? 0) - \(game.homeScore ?? 0)")
                    .bold()
                    .foregroundColor( (game.awayScore ?? 0 > game.homeScore ?? 0) ? .primary :
                                      ( (game.homeScore ?? 0 > game.awayScore ?? 0) ? .secondary : .primary ) ) // Consider different color for winner/loser
            } else {
                Text("vs").font(.caption).foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ScheduleView: View {
    @Binding var league: League

    private func gamesByWeek() -> [Int: [Game]] {
        Dictionary(grouping: league.schedule, by: { $0.week })
    }
    private func sortedWeeks() -> [Int] {
        gamesByWeek().keys.sorted()
    }

    private func nextUnplayedWeek() -> Int? {
        // Start checking from the league's current week
        for week in league.currentWeek...league.gamesPerSeason {
            if gamesByWeek()[week]?.contains(where: { !$0.isPlayed }) == true {
                return week
            }
        }
        // If no unplayed games found from current week onwards, check entire schedule for any missed games
        if !allGamesPlayed() {
            return league.schedule.filter { !$0.isPlayed }.map { $0.week }.min()
        }
        return nil // All games played or no games to play
    }
    
    private func allGamesPlayed() -> Bool {
        league.schedule.allSatisfy { $0.isPlayed }
    }

    var body: some View {
        List {
            Section(header: Text("Season Progress: Week \(league.currentWeek) of \(league.gamesPerSeason)")) {
                if league.schedule.isEmpty {
                    Text("No schedule generated for \(league.name).").foregroundColor(.gray).padding()
                } else {
                    ForEach(sortedWeeks(), id: \.self) { weekNumber in
                        Section(header: Text("Week \(weekNumber)")) {
                            if let gamesInWeek = gamesByWeek()[weekNumber], !gamesInWeek.isEmpty {
                                ForEach(gamesInWeek) { game in // Game is Identifiable
                                    GameRowView(game: game, homeTeam: team(byId: game.homeTeamID), awayTeam: team(byId: game.awayTeamID))
                                }
                            } else {
                                Text("No games scheduled for this week.")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("\(league.name) Schedule")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Sim Week") { simulateCurrentWeek() }
                    .disabled(nextUnplayedWeek() == nil || (nextUnplayedWeek() ?? league.gamesPerSeason + 1) > league.gamesPerSeason)

                Button("To Mid-Season") { simulateToWeek(league.tradeDeadlineWeek) }
                     .disabled(nextUnplayedWeek() == nil || (nextUnplayedWeek() ?? league.gamesPerSeason + 1) >= league.tradeDeadlineWeek || (nextUnplayedWeek() ?? league.gamesPerSeason + 1) > league.gamesPerSeason)

                Button("To Playoffs") { simulateToWeek(league.gamesPerSeason) } // Sim to end of regular season
                    .disabled(nextUnplayedWeek() == nil || allGamesPlayed())
                
                Spacer()
                
                Button { resetSchedule() } label: { Image(systemName: "arrow.counterclockwise") }
                  .disabled(league.schedule.isEmpty) // Disable if no schedule to reset
            }
        }
    }

    func team(byId id: UUID) -> Team? {
        league.teams.first(where: { $0.id == id })
    }

    func updateTeamStats(homeTeamID: UUID, awayTeamID: UUID, homeScore: Int, awayScore: Int, isTie: Bool) {
        guard let homeTeamIndex = league.teams.firstIndex(where: { $0.id == homeTeamID }),
              let awayTeamIndex = league.teams.firstIndex(where: { $0.id == awayTeamID }) else {
            print("Error: Could not find teams to update stats for game involving \(homeTeamID) and \(awayTeamID).")
            return
        }

        // Modify copies then assign back to trigger UI update via @Binding
        var homeTeam = league.teams[homeTeamIndex]
        var awayTeam = league.teams[awayTeamIndex]

        homeTeam.pointsFor += homeScore
        homeTeam.pointsAgainst += awayScore
        awayTeam.pointsFor += awayScore
        awayTeam.pointsAgainst += homeScore

        // For H2H, ensure these arrays are initialized in your Team model
        // homeTeam.opponentsPlayed[awayTeamID, default: .neutral].append(gameResult) // More complex H2H

        if isTie {
            homeTeam.ties += 1; awayTeam.ties += 1
            if homeTeam.conferenceId == awayTeam.conferenceId { // Check if in same conference
                homeTeam.conferenceTies += 1; awayTeam.conferenceTies += 1
                if homeTeam.divisionId == awayTeam.divisionId { // Check if in same division
                    homeTeam.divisionalTies += 1; awayTeam.divisionalTies += 1
                }
            }
        } else if homeScore > awayScore { // Home team won
            homeTeam.wins += 1; awayTeam.losses += 1
            if homeTeam.conferenceId == awayTeam.conferenceId {
                homeTeam.conferenceWins += 1; awayTeam.conferenceLosses += 1
                if homeTeam.divisionId == awayTeam.divisionId {
                    homeTeam.divisionalWins += 1; awayTeam.divisionalLosses += 1
                }
            }
        } else { // Away team won
            awayTeam.wins += 1; homeTeam.losses += 1
            if homeTeam.conferenceId == awayTeam.conferenceId { // Still based on homeTeam's perspective for conference match
                awayTeam.conferenceWins += 1; homeTeam.conferenceLosses += 1
                if homeTeam.divisionId == awayTeam.divisionId {
                    awayTeam.divisionalWins += 1; homeTeam.divisionalLosses += 1
                }
            }
        }
        league.teams[homeTeamIndex] = homeTeam
        league.teams[awayTeamIndex] = awayTeam
    }

    func simulateGamesForWeek(_ weekNum: Int) {
        guard weekNum <= league.gamesPerSeason else {
            print("Cannot sim week \(weekNum), season has \(league.gamesPerSeason) games and is likely over.")
            return
        }
        print("Simulating Week \(weekNum)...")
        var gamesActuallySimulatedThisWeek = 0
        for i in league.schedule.indices {
            if league.schedule[i].week == weekNum && !league.schedule[i].isPlayed {
                guard let homeTeam = team(byId: league.schedule[i].homeTeamID),
                      let awayTeam = team(byId: league.schedule[i].awayTeamID) else {
                    print("Error finding teams for game ID \(league.schedule[i].id) in week \(weekNum)")
                    continue
                }
                let simResult = SimulationEngine.simulateGame(homeTeam: homeTeam, awayTeam: awayTeam)
                
                var gameToUpdate = league.schedule[i]
                gameToUpdate.homeScore = simResult.homeScore
                gameToUpdate.awayScore = simResult.awayScore
                // gameToUpdate.isPlayed will be true due to scores being non-nil
                league.schedule[i] = gameToUpdate
                
                updateTeamStats(homeTeamID: homeTeam.id, awayTeamID: awayTeam.id, homeScore: simResult.homeScore, awayScore: simResult.awayScore, isTie: simResult.isTie)
                gamesActuallySimulatedThisWeek += 1
            }
        }
        
        // Check if all games for *this specific week* are now played
        let allGamesInSimmedWeekNowPlayed = league.schedule.filter { $0.week == weekNum }.allSatisfy { $0.isPlayed }

        // Advance league's current week *only if* the simulated week was the league's current week
        // and games were processed or all games in that week are now played.
        if league.currentWeek == weekNum {
            if gamesActuallySimulatedThisWeek > 0 || allGamesInSimmedWeekNowPlayed {
                if weekNum < league.gamesPerSeason {
                    league.currentWeek = weekNum + 1
                } else if weekNum == league.gamesPerSeason && allGamesPlayed() { // All games of entire season played
                    league.currentWeek = league.playoffStartWeek
                    print("Regular season finished. Current week advanced to: \(league.currentWeek)")
                }
            }
        }
        print("Finished Simulating Week \(weekNum). Games simulated: \(gamesActuallySimulatedThisWeek). League's current week is now: \(league.currentWeek)")
    }

    func simulateCurrentWeek() {
        if let weekToSim = nextUnplayedWeek(), weekToSim <= league.gamesPerSeason {
            // Ensure league.currentWeek is set to the week we are about to simulate if it's different
            // This is important if user manually reset and nextUnplayedWeek is in the past.
            if league.currentWeek != weekToSim && weekToSim <= league.gamesPerSeason {
                 print("Aligning league current week from \(league.currentWeek) to \(weekToSim) before simming.")
                 league.currentWeek = weekToSim
            }
            simulateGamesForWeek(league.currentWeek)
        } else {
            print("No more games to sim or season over. Current league week: \(league.currentWeek)")
            if allGamesPlayed() && league.currentWeek <= league.gamesPerSeason {
                league.currentWeek = league.playoffStartWeek
                 print("All games played. League current week set to playoff week: \(league.currentWeek)")
            }
        }
    }
    
    func simulateToWeek(_ targetWeekInclusive: Int) {
        print("Simulating up to week \(targetWeekInclusive)...")
        
        guard let startWeek = nextUnplayedWeek(), startWeek <= league.gamesPerSeason else {
            print("No games to simulate or season is past the target week.")
            if allGamesPlayed() && league.currentWeek <= league.gamesPerSeason {
                league.currentWeek = league.playoffStartWeek
            }
            return
        }

        // Align league.currentWeek to the actual start of simulation if needed
        if league.currentWeek != startWeek && startWeek <= league.gamesPerSeason {
             league.currentWeek = startWeek
        }

        for weekToProcess in league.currentWeek...min(targetWeekInclusive, league.gamesPerSeason) {
            // Check if there are unplayed games in this specific weekToProcess
            let hasUnplayedGamesThisWeek = gamesByWeek()[weekToProcess]?.contains(where: { !$0.isPlayed }) ?? false
            
            if !hasUnplayedGamesThisWeek && league.currentWeek == weekToProcess {
                print("No unplayed games in week \(weekToProcess), but it's the current week. Advancing current week.")
                if league.currentWeek < league.gamesPerSeason {
                    league.currentWeek += 1
                } else if allGamesPlayed() { // Reached end of season games
                     league.currentWeek = league.playoffStartWeek
                     print("All games played by end of simulateToWeek. Set to playoff week: \(league.currentWeek)")
                     break // Exit loop as season is over
                }
                continue // Skip to next week in the loop
            }
            
            if hasUnplayedGamesThisWeek {
                 simulateGamesForWeek(weekToProcess) // This will advance league.currentWeek if weekToProcess was current
            }

            if allGamesPlayed() { // Check after each simmed week
                 print("All regular season games simulated after processing week \(weekToProcess).")
                 if league.currentWeek <= league.gamesPerSeason { // ensure it's not already playoff week
                    league.currentWeek = league.playoffStartWeek
                 }
                 break // Exit loop, regular season is done
            }
            
            // If simulateGamesForWeek advanced league.currentWeek, the loop will continue from the new currentWeek.
            // If weekToProcess was not league.currentWeek, we need to ensure league.currentWeek is at least weekToProcess + 1 for the next iteration.
            if league.currentWeek <= weekToProcess && weekToProcess < league.gamesPerSeason {
                league.currentWeek = weekToProcess + 1
            }
        }
        
        print("Finished simulating to target \(targetWeekInclusive). League's current week is now: \(league.currentWeek)")
    }

    func resetSchedule() {
        print("Resetting schedule and team stats...")
        if league.schedule.isEmpty {
            print("No schedule to reset.")
            return
        }
        for i in league.schedule.indices {
            league.schedule[i].homeScore = nil
            league.schedule[i].awayScore = nil
            // isPlayed will automatically become false
        }
        for i in league.teams.indices {
            league.teams[i].resetSeasonStats() // Make sure Team struct has this method
        }
        league.currentWeek = 1 // Reset to the beginning of the season
        print("Schedule and stats reset. League current week: \(league.currentWeek)")
    }
}
