import SwiftUI

// GameRowView should be defined here if not in its own file and used by ScheduleView
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
                                      ( (game.homeScore ?? 0 > game.awayScore ?? 0) ? .secondary : .primary ) )
            } else {
                Text("vs").font(.caption).foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ScheduleView: View {
    @Binding var league: League

    // Using computed properties that depend on league state
    private func gamesByWeek() -> [Int: [Game]] {
        Dictionary(grouping: league.schedule, by: { $0.week })
    }
    private func sortedWeeks() -> [Int] {
        gamesByWeek().keys.sorted()
    }

    private func nextUnplayedWeek() -> Int? {
        for week in league.currentWeek...league.gamesPerSeason {
            if gamesByWeek()[week]?.contains(where: { !$0.isPlayed }) == true {
                return week
            }
        }
        if !allGamesPlayed() {
            return league.schedule.filter { !$0.isPlayed }.map { $0.week }.min()
        }
        return nil
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
                            ForEach(gamesByWeek()[weekNumber] ?? []) { game in
                                GameRowView(game: game, homeTeam: team(byId: game.homeTeamID), awayTeam: team(byId: game.awayTeamID))
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
                    .disabled((nextUnplayedWeek() == nil) || (nextUnplayedWeek()! > league.gamesPerSeason))

                Button("To Mid-Season") { simulateToWeek(league.tradeDeadlineWeek) }
                     .disabled((nextUnplayedWeek() == nil) || (nextUnplayedWeek()! >= league.tradeDeadlineWeek) || (nextUnplayedWeek()! > league.gamesPerSeason))

                Button("To Playoffs") { simulateToWeek(league.gamesPerSeason) }
                    .disabled((nextUnplayedWeek() == nil) || allGamesPlayed())
                
                Spacer()
                
                Button { resetSchedule() } label: { Image(systemName: "arrow.counterclockwise") }
            }
        }
    }

    func team(byId id: UUID) -> Team? {
        league.teams.first(where: { $0.id == id })
    }

    func updateTeamStats(homeTeamID: UUID, awayTeamID: UUID, homeScore: Int, awayScore: Int, isTie: Bool) {
        guard let homeTeamIndex = league.teams.firstIndex(where: { $0.id == homeTeamID }),
              let awayTeamIndex = league.teams.firstIndex(where: { $0.id == awayTeamID }) else {
            print("Error: Could not find teams to update stats."); return
        }

        // It's crucial to modify the teams array through the binding to ensure changes propagate
        var homeTeam = league.teams[homeTeamIndex]
        var awayTeam = league.teams[awayTeamIndex]

        homeTeam.pointsFor += homeScore
        homeTeam.pointsAgainst += awayScore
        awayTeam.pointsFor += awayScore
        awayTeam.pointsAgainst += homeScore

        let homeTeamConferenceId = homeTeam.conferenceId // Use temp vars for comparison
        let homeTeamDivisionId = homeTeam.divisionId
        let awayTeamConferenceId = awayTeam.conferenceId
        let awayTeamDivisionId = awayTeam.divisionId


        if isTie {
            homeTeam.ties += 1
            awayTeam.ties += 1
            // homeTeam.opponentsTiedWith.append(awayTeamID) // Ensure these array properties exist on Team model
            // awayTeam.opponentsTiedWith.append(homeTeamID)
            if homeTeamConferenceId == awayTeamConferenceId {
                homeTeam.conferenceTies += 1
                awayTeam.conferenceTies += 1
                if homeTeamDivisionId == awayTeamDivisionId {
                    homeTeam.divisionalTies += 1
                    awayTeam.divisionalTies += 1
                }
            }
        } else if homeScore > awayScore {
            homeTeam.wins += 1
            // homeTeam.opponentsBeaten.append(awayTeamID)
            awayTeam.losses += 1
            // awayTeam.opponentsLostTo.append(homeTeamID)
            if homeTeamConferenceId == awayTeamConferenceId {
                homeTeam.conferenceWins += 1
                awayTeam.conferenceLosses += 1
                if homeTeamDivisionId == awayTeamDivisionId {
                    homeTeam.divisionalWins += 1
                    awayTeam.divisionalLosses += 1
                }
            }
        } else { // awayScore > homeScore
            awayTeam.wins += 1
            // awayTeam.opponentsBeaten.append(homeTeamID)
            homeTeam.losses += 1
            // homeTeam.opponentsLostTo.append(awayTeamID)
             if homeTeamConferenceId == awayTeamConferenceId {
                awayTeam.conferenceWins += 1
                homeTeam.conferenceLosses += 1
                if homeTeamDivisionId == awayTeamDivisionId {
                    awayTeam.divisionalWins += 1
                    homeTeam.divisionalLosses += 1
                }
            }
        }
        // Assign the modified teams back to the league's teams array
        league.teams[homeTeamIndex] = homeTeam
        league.teams[awayTeamIndex] = awayTeam
    }

    func simulateGamesForWeek(_ weekNum: Int) {
        guard weekNum <= league.gamesPerSeason else {
            print("Cannot sim week \(weekNum), season has \(league.gamesPerSeason) games."); return
        }
        print("Simulating Week \(weekNum)...")
        var gamesActuallySimulatedThisWeek = 0
        for i in league.schedule.indices { // Loop through indices to modify item
            if league.schedule[i].week == weekNum && !league.schedule[i].isPlayed {
                guard let homeTeam = team(byId: league.schedule[i].homeTeamID),
                      let awayTeam = team(byId: league.schedule[i].awayTeamID) else {
                    print("Error finding teams for game in week \(weekNum)"); continue
                }
                let simResult = SimulationEngine.simulateGame(homeTeam: homeTeam, awayTeam: awayTeam)
                
                // Create a mutable copy of the game to update it
                var gameToUpdate = league.schedule[i]
                gameToUpdate.homeScore = simResult.homeScore
                gameToUpdate.awayScore = simResult.awayScore
                league.schedule[i] = gameToUpdate // Assign the updated game back
                
                updateTeamStats(homeTeamID: homeTeam.id, awayTeamID: awayTeam.id, homeScore: simResult.homeScore, awayScore: simResult.awayScore, isTie: simResult.isTie)
                gamesActuallySimulatedThisWeek += 1
            }
        }
        
        let allGamesInSimmedWeekPlayed = league.schedule.filter { $0.week == weekNum }.allSatisfy { $0.isPlayed }

        if league.currentWeek == weekNum && (gamesActuallySimulatedThisWeek > 0 || allGamesInSimmedWeekPlayed) {
            if weekNum < league.gamesPerSeason {
                league.currentWeek = weekNum + 1
            } else if weekNum == league.gamesPerSeason && allGamesPlayed() {
                league.currentWeek = league.playoffStartWeek
                print("Regular season finished. Current week: \(league.currentWeek)")
            }
        } else if league.currentWeek == weekNum && gamesActuallySimulatedThisWeek == 0 && allGamesInSimmedWeekPlayed {
             if weekNum < league.gamesPerSeason { league.currentWeek = weekNum + 1 }
             else if weekNum == league.gamesPerSeason { league.currentWeek = league.playoffStartWeek }
        }
        print("Finished Week \(weekNum). League current week: \(league.currentWeek)")
    }

    func simulateCurrentWeek() {
        // Use the computed property consistently
        if let weekToSim = nextUnplayedWeek(), weekToSim <= league.gamesPerSeason {
            if league.currentWeek != weekToSim { league.currentWeek = weekToSim }
            simulateGamesForWeek(league.currentWeek)
        } else {
            print("No more games to sim or season over. Current week: \(league.currentWeek)")
            if allGamesPlayed() && league.currentWeek <= league.gamesPerSeason {
                league.currentWeek = league.playoffStartWeek
                 print("All games played. Set to playoff week: \(league.currentWeek)")
            }
        }
    }
    
    func simulateToWeek(_ targetWeekInclusive: Int) {
        print("Simulating up to week \(targetWeekInclusive)...")
        // Use the computed property to find the starting point.
        var currentProcessingWeek = nextUnplayedWeek() ?? league.currentWeek
        
        while currentProcessingWeek <= targetWeekInclusive && currentProcessingWeek <= league.gamesPerSeason {
            if league.currentWeek != currentProcessingWeek {
                league.currentWeek = currentProcessingWeek
            }
            
            let gamesToSimInThisProcessingWeek = league.schedule.filter { $0.week == currentProcessingWeek && !$0.isPlayed }
            if gamesToSimInThisProcessingWeek.isEmpty {
                print("No unplayed games in week \(currentProcessingWeek).")
                if currentProcessingWeek < league.gamesPerSeason {
                    currentProcessingWeek += 1
                    if currentProcessingWeek <= league.gamesPerSeason { // Check before assigning
                        league.currentWeek = currentProcessingWeek
                    }
                    continue
                } else {
                    break // Reached end of season or target
                }
            }
            
            simulateGamesForWeek(currentProcessingWeek)
            
            if allGamesPlayed() {
                 print("All regular season games simulated after processing week \(currentProcessingWeek).")
                 league.currentWeek = league.playoffStartWeek
                 break
            }
            
            // Determine next week for the loop based on where league.currentWeek landed or loop var
            if league.currentWeek > currentProcessingWeek {
                currentProcessingWeek = league.currentWeek
            } else {
                currentProcessingWeek += 1
                if currentProcessingWeek <= league.gamesPerSeason {
                    league.currentWeek = currentProcessingWeek
                } else if allGamesPlayed() { // If we advanced past last regular season week AND all games are played
                    league.currentWeek = league.playoffStartWeek
                    break; // Ensure loop terminates if season is over
                }
            }
        } // Corrected: End of while loop brace placement
        
        if allGamesPlayed() && league.currentWeek <= league.gamesPerSeason {
            league.currentWeek = league.playoffStartWeek
        } else if !allGamesPlayed() && league.currentWeek > league.gamesPerSeason {
            league.currentWeek = nextUnplayedWeek() ?? league.playoffStartWeek
        }
        print("Finished simulating to target \(targetWeekInclusive). League current week: \(league.currentWeek)")
    } // Corrected: End of simulateToWeek brace placement

    func resetSchedule() {
        print("Resetting schedule and team stats...")
        for i in league.schedule.indices {
            var gameToReset = league.schedule[i] // Get a mutable copy
            gameToReset.homeScore = nil
            gameToReset.awayScore = nil
            league.schedule[i] = gameToReset // Assign the copy back
        }
        for i in league.teams.indices {
            league.teams[i].resetSeasonStats()
        }
        league.currentWeek = 1
    }
}
