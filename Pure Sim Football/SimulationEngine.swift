import Foundation

// Define RawScheduledGame at a scope accessible to SimulationEngine.
// Ensure this is the ONLY definition of RawScheduledGame in your project.
// If you previously had it in Models.swift, REMOVE IT FROM THERE.
struct RawScheduledGame: Codable, Hashable {
let week: Int
let awayTeamRealName: String
let homeTeamRealName: String
let neutralSiteLocation: String?
}

// Ensure this struct SimulationEngine is defined ONLY ONCE in this file.
struct SimulationEngine {

// This map is CRUCIAL.
static let realToFictionalTeamMap: [String: (location: String, nickname: String)] = [
"Arizona Cardinals": ("Arizona", "Inferno"), "Atlanta Falcons": ("Atlanta", "Aviators"),
"Baltimore Ravens": ("Baltimore", "Nightwings"), "Buffalo Bills": ("Buffalo", "Stallions"),
"Carolina Panthers": ("Charlotte", "Prowlers"), "Chicago Bears": ("Chicago", "Bruisers"),
"Cincinnati Bengals": ("Cincinnati", "Stripes"), "Cleveland Browns": ("Cleveland", "Rockers"),
"Dallas Cowboys": ("Dallas", "Stars"), "Denver Broncos": ("Denver", "Peaks"),
"Detroit Lions": ("Detroit", "Automata"), "Green Bay Packers": ("Green Bay", "Voyageurs"),
"Houston Texans": ("Houston", "Comets"), "Indianapolis Colts": ("Indianapolis", "Racers"),
"Jacksonville Jaguars": ("Jacksonville", "Current"), "Kansas City Chiefs": ("Kansas City", "Scouts"),
"Las Vegas Raiders": ("Las Vegas", "Aces"), "Los Angeles Chargers": ("Los Angeles", "Thunderbolts"),
"Los Angeles Rams": ("Los Angeles", "Stags"), "Miami Dolphins": ("Miami", "Tides"),
"Minnesota Vikings": ("Minnesota", "Norsemen"),
"New England Patriots": ("New England", "Minutemen"),
"New Orleans Saints": ("New Orleans", "Revelers"), "New York Giants": ("New York", "Goliaths"),
"New York Jets": ("New York", "Knights"), "Philadelphia Eagles": ("Philadelphia", "Freedom"),
"Pittsburgh Steelers": ("Pittsburgh", "Forgers"), "San Francisco 49ers": ("San Francisco", "Prospectors"),
"Seattle Seahawks": ("Seattle", "Cascades"), "Tampa Bay Buccaneers": ("Tampa Bay", "Cannons"),
"Tennessee Titans": ("Tennessee", "Rhythm"),
"Washington Commanders": ("Washington", "Capitals")
]

    // --- 2025 NFL SCHEDULE DATA ---
    // YOU NEED TO POPULATE THIS ARRAY FULLY with all 272 unique games.
    // I'm only putting a few AFC East examples here as a placeholder.
    static let real2025ScheduleData: [RawScheduledGame] = [
        // ==== AFC EAST (Example - Needs to be fully populated by you) ====
        RawScheduledGame(week: 1, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Buffalo Bills", neutralSiteLocation: nil),
               RawScheduledGame(week: 1, awayTeamRealName: "Miami Dolphins", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
               RawScheduledGame(week: 1, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "New York Jets", neutralSiteLocation: nil),
               RawScheduledGame(week: 1, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "New England Patriots", neutralSiteLocation: nil),
               RawScheduledGame(week: 2, awayTeamRealName: "Buffalo Bills", homeTeamRealName: "New York Jets", neutralSiteLocation: nil),
               RawScheduledGame(week: 2, awayTeamRealName: "New England Patriots", homeTeamRealName: "Miami Dolphins", neutralSiteLocation: nil),
               RawScheduledGame(week: 3, awayTeamRealName: "Miami Dolphins", homeTeamRealName: "Buffalo Bills", neutralSiteLocation: nil),
               RawScheduledGame(week: 3, awayTeamRealName: "New York Jets", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),
               RawScheduledGame(week: 3, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "New England Patriots", neutralSiteLocation: nil),
               RawScheduledGame(week: 4, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Buffalo Bills", neutralSiteLocation: nil),
               RawScheduledGame(week: 4, awayTeamRealName: "New York Jets", homeTeamRealName: "Miami Dolphins", neutralSiteLocation: nil),
               RawScheduledGame(week: 4, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "New England Patriots", neutralSiteLocation: nil),
               RawScheduledGame(week: 5, awayTeamRealName: "New England Patriots", homeTeamRealName: "Buffalo Bills", neutralSiteLocation: nil),
               RawScheduledGame(week: 5, awayTeamRealName: "Miami Dolphins", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
               RawScheduledGame(week: 5, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "New York Jets", neutralSiteLocation: nil),
               RawScheduledGame(week: 6, awayTeamRealName: "Buffalo Bills", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),
               RawScheduledGame(week: 6, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "Miami Dolphins", neutralSiteLocation: nil),
               RawScheduledGame(week: 6, awayTeamRealName: "Denver Broncos", homeTeamRealName: "New York Jets", neutralSiteLocation: "London"),
               RawScheduledGame(week: 6, awayTeamRealName: "New England Patriots", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
               RawScheduledGame(week: 7, awayTeamRealName: "Miami Dolphins", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
               RawScheduledGame(week: 7, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "New York Jets", neutralSiteLocation: nil),
               RawScheduledGame(week: 7, awayTeamRealName: "New England Patriots", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
               RawScheduledGame(week: 8, awayTeamRealName: "Buffalo Bills", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
               RawScheduledGame(week: 8, awayTeamRealName: "Miami Dolphins", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),
               RawScheduledGame(week: 8, awayTeamRealName: "New York Jets", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
               RawScheduledGame(week: 8, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "New England Patriots", neutralSiteLocation: nil),
               RawScheduledGame(week: 9, awayTeamRealName: "Kansas City Chiefs", homeTeamRealName: "Buffalo Bills", neutralSiteLocation: nil),
               RawScheduledGame(week: 9, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Miami Dolphins", neutralSiteLocation: nil),
               RawScheduledGame(week: 9, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "New England Patriots", neutralSiteLocation: nil),
               RawScheduledGame(week: 10, awayTeamRealName: "Buffalo Bills", homeTeamRealName: "Miami Dolphins", neutralSiteLocation: nil),
               RawScheduledGame(week: 10, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "New York Jets", neutralSiteLocation: nil),
               RawScheduledGame(week: 10, awayTeamRealName: "New England Patriots", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),
               RawScheduledGame(week: 11, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Buffalo Bills", neutralSiteLocation: nil),
               RawScheduledGame(week: 11, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Miami Dolphins", neutralSiteLocation: "Madrid"),
               RawScheduledGame(week: 11, awayTeamRealName: "New York Jets", homeTeamRealName: "New England Patriots", neutralSiteLocation: nil),
               RawScheduledGame(week: 12, awayTeamRealName: "Buffalo Bills", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
               RawScheduledGame(week: 12, awayTeamRealName: "New York Jets", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
               RawScheduledGame(week: 12, awayTeamRealName: "New England Patriots", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
               RawScheduledGame(week: 13, awayTeamRealName: "Buffalo Bills", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
               RawScheduledGame(week: 13, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Miami Dolphins", neutralSiteLocation: nil),
               RawScheduledGame(week: 13, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "New York Jets", neutralSiteLocation: nil),
               RawScheduledGame(week: 13, awayTeamRealName: "New York Giants", homeTeamRealName: "New England Patriots", neutralSiteLocation: nil),
               RawScheduledGame(week: 14, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Buffalo Bills", neutralSiteLocation: nil),
               // MIA @ NYJ is same as NYJ @ MIA in Wk4 due to team-centric source; only one should be here:
               // RawScheduledGame(week: 14, awayTeamRealName: "Miami Dolphins", homeTeamRealName: "New York Jets", neutralSiteLocation: nil), // Covered by Wk4 Jets@Dolphins
               RawScheduledGame(week: 15, awayTeamRealName: "Buffalo Bills", homeTeamRealName: "New England Patriots", neutralSiteLocation: nil),
               RawScheduledGame(week: 15, awayTeamRealName: "Miami Dolphins", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
               RawScheduledGame(week: 15, awayTeamRealName: "New York Jets", homeTeamRealName: "Jacksonville Jaguars", neutralSiteLocation: nil),
               RawScheduledGame(week: 16, awayTeamRealName: "Buffalo Bills", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
               RawScheduledGame(week: 16, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Miami Dolphins", neutralSiteLocation: nil),
               RawScheduledGame(week: 16, awayTeamRealName: "New York Jets", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
               RawScheduledGame(week: 16, awayTeamRealName: "New England Patriots", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
               RawScheduledGame(week: 17, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Buffalo Bills", neutralSiteLocation: nil),
               RawScheduledGame(week: 17, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Miami Dolphins", neutralSiteLocation: nil),
               RawScheduledGame(week: 17, awayTeamRealName: "New England Patriots", homeTeamRealName: "New York Jets", neutralSiteLocation: nil),
               RawScheduledGame(week: 18, awayTeamRealName: "New York Jets", homeTeamRealName: "Buffalo Bills", neutralSiteLocation: nil),
               RawScheduledGame(week: 18, awayTeamRealName: "Miami Dolphins", homeTeamRealName: "New England Patriots", neutralSiteLocation: nil),

               // AFC NORTH (Processed based on your earlier input - ensure only unique games)
               RawScheduledGame(week: 1, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
               RawScheduledGame(week: 2, awayTeamRealName: "Jacksonville Jaguars", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
               RawScheduledGame(week: 3, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
               RawScheduledGame(week: 4, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
               RawScheduledGame(week: 5, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
               RawScheduledGame(week: 6, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
               RawScheduledGame(week: 7, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
               // Week 8: Jets @ Bengals (already listed from Jets schedule)
               // Week 9: Bears @ Bengals (already listed from Bears schedule)
               RawScheduledGame(week: 11, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
               // Week 12: Patriots @ Bengals (already listed from Patriots schedule)
               RawScheduledGame(week: 13, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
               // Week 14: Bengals @ Bills (already listed from Bills schedule)
               RawScheduledGame(week: 15, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
               // Week 16: Bengals @ Dolphins (already listed from Dolphins schedule)
               RawScheduledGame(week: 17, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
               // Week 18: Browns @ Bengals (Divisional)
               
               RawScheduledGame(week: 2, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
               RawScheduledGame(week: 3, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
               RawScheduledGame(week: 4, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
               RawScheduledGame(week: 5, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: "London"),
               RawScheduledGame(week: 6, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
               // Week 7: Dolphins @ Browns (already listed)
               // Week 8: Browns @ Patriots (already listed)
               // Week 10: Browns @ Jets (already listed)
               RawScheduledGame(week: 11, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
               RawScheduledGame(week: 12, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
               RawScheduledGame(week: 13, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
               RawScheduledGame(week: 14, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
               RawScheduledGame(week: 15, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
               // Week 16: Bills @ Browns (already listed)
               RawScheduledGame(week: 17, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),

               RawScheduledGame(week: 3, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
               RawScheduledGame(week: 4, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
               RawScheduledGame(week: 5, awayTeamRealName: "Houston Texans", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
               RawScheduledGame(week: 6, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
               RawScheduledGame(week: 8, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
               // Week 9: Ravens @ Dolphins (already listed)
               RawScheduledGame(week: 10, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
               // Week 12: Jets @ Ravens (already listed)
               RawScheduledGame(week: 14, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
               // Week 16: Patriots @ Ravens (already listed)
               RawScheduledGame(week: 17, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
               RawScheduledGame(week: 18, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil), //Divisional
               
               RawScheduledGame(week: 2, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
               // Week 3: Steelers @ Patriots (already listed)
               RawScheduledGame(week: 4, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: "Dublin"),
               // Week 8: Packers @ Steelers (already listed)
               RawScheduledGame(week: 9, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
               RawScheduledGame(week: 10, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
               RawScheduledGame(week: 12, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
               // Week 13: Bills @ Steelers (already listed)
               RawScheduledGame(week: 16, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),

        // generateSchedule function
        static func generateSchedule(
        for leagueTeams: [Team],
        gamesToPlayPerTeamTarget: Int,
        isFirstSeason: Bool,
        isUsingDefaultTeams: Bool,
        leagueStructure: (conferences: Int, divisionsPerConference: Int)
        ) -> [Game] {

        guard !leagueTeams.isEmpty, gamesToPlayPerTeamTarget > 0 else { return [] }

        // Check if real2025ScheduleData has more than just placeholder data
        let hasMeaningfulRealScheduleData = real2025ScheduleData.count > 5 // Arbitrary number greater than 1-2 examples

        if isFirstSeason && isUsingDefaultTeams && leagueTeams.count == 32 && hasMeaningfulRealScheduleData {
            print("Attempting to generate schedule from real 2025 NFL data.")
            var generatedGames: [Game] = []
            var gamesScheduledCountPerTeam: [UUID: Int] = Dictionary(uniqueKeysWithValues: leagueTeams.map { ($0.id, 0) })
            var uniqueGameEntries = Set<String>()

            for rawGame in real2025ScheduleData {
                guard let homeFictionalInfo = realToFictionalTeamMap[rawGame.homeTeamRealName],
                      let awayFictionalInfo = realToFictionalTeamMap[rawGame.awayTeamRealName] else {
                    continue
                }

                guard let homeTeam = leagueTeams.first(where: { $0.location == homeFictionalInfo.location && $0.name == homeFictionalInfo.nickname }),
                      let awayTeam = leagueTeams.first(where: { $0.location == awayFictionalInfo.location && $0.name == awayFictionalInfo.nickname }) else {
                    continue
                }
                
                let teamIDsSorted = [homeTeam.id.uuidString, awayTeam.id.uuidString].sorted()
                let gameKey = "\(teamIDsSorted[0])-\(teamIDsSorted[1])-W\(rawGame.week)"
                
                if uniqueGameEntries.contains(gameKey) {
                    continue
                }
                uniqueGameEntries.insert(gameKey)

                let game = Game(
                    week: rawGame.week,
                    homeTeamID: homeTeam.id, awayTeamID: awayTeam.id,
                    homeTeamName: homeTeam.name, awayTeamName: awayTeam.name,
                    homeTeamLocation: homeTeam.location, awayTeamLocation: awayTeam.location,
                    homeScore: nil, awayScore: nil
                )
                generatedGames.append(game)
                gamesScheduledCountPerTeam[homeTeam.id, default: 0] += 1
                gamesScheduledCountPerTeam[awayTeam.id, default: 0] += 1
            }
            
            print("Generated \(generatedGames.count) unique games from Real 2025 Schedule data.")
            let expectedGamesInFullRealSchedule = (leagueTeams.count * 17) / 2
            // Adjusted threshold to be more lenient if data is partially filled
            if generatedGames.count >= expectedGamesInFullRealSchedule - (leagueTeams.count * 2) {
                print("Using real schedule data.")
                return generatedGames.sorted {
                    if $0.week != $1.week { return $0.week < $1.week }
                    if $0.homeTeamName != $1.homeTeamName { return $0.homeTeamName < $1.homeTeamName }
                    return $0.awayTeamName < $1.awayTeamName
                }
            } else {
                print("Real 2025 schedule data was insufficient (\(generatedGames.count) games generated vs expected ~\(expectedGamesInFullRealSchedule)). Falling back to random generation.")
            }
        }

        print("Generating random schedule for \(gamesToPlayPerTeamTarget) games per team...")
        var schedule: [Game] = []
        var gamesPlayedCounts: [UUID: Int] = Dictionary(uniqueKeysWithValues: leagueTeams.map { ($0.id, 0) })
        let teamsDict = Dictionary(uniqueKeysWithValues: leagueTeams.map { ($0.id, $0) })
        let finalWeekDesignator = gamesToPlayPerTeamTarget
        var teamsNeedingFinalGame = Set(leagueTeams.map { $0.id })

        for team1Id in teamsNeedingFinalGame.shuffled() {
            guard teamsNeedingFinalGame.contains(team1Id), let team1 = teamsDict[team1Id] else { continue }
            if (gamesPlayedCounts[team1Id] ?? 0) >= gamesToPlayPerTeamTarget { teamsNeedingFinalGame.remove(team1Id); continue }
            let potentialOpponents = leagueTeams.filter { team2 in
                team1.id != team2.id && team1.conferenceId == team2.conferenceId && team1.divisionId == team2.divisionId &&
                teamsNeedingFinalGame.contains(team2.id) && (gamesPlayedCounts[team2.id] ?? 0) < gamesToPlayPerTeamTarget
            }
            if let team2 = potentialOpponents.shuffled().first {
                let homeTeam = Bool.random() ? team1 : team2; let awayTeam = (homeTeam.id == team1.id) ? team2 : team1
                schedule.append(Game(week: finalWeekDesignator, homeTeamID: homeTeam.id, awayTeamID: awayTeam.id, homeTeamName: homeTeam.name, awayTeamName: awayTeam.name, homeTeamLocation: homeTeam.location, awayTeamLocation: awayTeam.location))
                gamesPlayedCounts[homeTeam.id, default: 0] += 1; gamesPlayedCounts[awayTeam.id, default: 0] += 1
                teamsNeedingFinalGame.remove(homeTeam.id); teamsNeedingFinalGame.remove(awayTeam.id)
            }
        }
        if !teamsNeedingFinalGame.isEmpty {print("Warning: \(teamsNeedingFinalGame.count) teams still need final divisional game.")}

        for week in 1..<(finalWeekDesignator) {
            var teamsAvailableThisWeek = Set(leagueTeams.map{$0.id}).filter { (gamesPlayedCounts[$0] ?? 0) < (gamesToPlayPerTeamTarget - 1) }
            let shuffledTeamsForWeek = leagueTeams.filter{ teamsAvailableThisWeek.contains($0.id) }.shuffled()
            var scheduledInThisLoopPass: Set<UUID> = []
            for team1 in shuffledTeamsForWeek {
                guard teamsAvailableThisWeek.contains(team1.id), !scheduledInThisLoopPass.contains(team1.id) else { continue }
                let potentialOpponents = shuffledTeamsForWeek.filter { team2 in
                    team1.id != team2.id && teamsAvailableThisWeek.contains(team2.id) && !scheduledInThisLoopPass.contains(team2.id) &&
                    !schedule.contains(where: { ($0.homeTeamID == team1.id && $0.awayTeamID == team2.id && $0.week < week && $0.week != finalWeekDesignator) || ($0.homeTeamID == team2.id && $0.awayTeamID == team1.id && $0.week < week && $0.week != finalWeekDesignator) })
                }
                if let team2 = potentialOpponents.first {
                    let homeTeam = Bool.random() ? team1 : team2; let awayTeam = (homeTeam.id == team1.id) ? team2 : team1
                    schedule.append(Game(week: week, homeTeamID: homeTeam.id, awayTeamID: awayTeam.id, homeTeamName: homeTeam.name, awayTeamName: awayTeam.name, homeTeamLocation: homeTeam.location, awayTeamLocation: awayTeam.location))
                    gamesPlayedCounts[homeTeam.id, default: 0] += 1; gamesPlayedCounts[awayTeam.id, default: 0] += 1
                    scheduledInThisLoopPass.insert(homeTeam.id); scheduledInThisLoopPass.insert(awayTeam.id)
                }
            }
        }
        for teamId in leagueTeams.map({$0.id}) {
            let team1 = teamsDict[teamId]!; while (gamesPlayedCounts[teamId] ?? 0) < gamesToPlayPerTeamTarget {
                let potentialOpponents = leagueTeams.filter { $0.id != teamId && (gamesPlayedCounts[$0.id] ?? 0) < gamesToPlayPerTeamTarget }
                if let team2 = potentialOpponents.randomElement() {
                    var weekForExtraGame = 1; var foundWeek = false
                    let upperRandomBound = finalWeekDesignator > 1 ? finalWeekDesignator : 2
                    if upperRandomBound > 1 { // Ensure range is valid for Int.random
                        for w in 1..<upperRandomBound {
                            let t1Plays = schedule.contains{$0.week==w && ($0.homeTeamID==team1.id || $0.awayTeamID==team1.id)}
                            let t2Plays = schedule.contains{$0.week==w && ($0.homeTeamID==team2.id || $0.awayTeamID==team2.id)}
                            if !t1Plays && !t2Plays { weekForExtraGame=w; foundWeek=true; break }
                        }
                        if !foundWeek { weekForExtraGame = Int.random(in: 1..<upperRandomBound) }
                    } else { // Fallback if finalWeekDesignator is 1 (very short season)
                        weekForExtraGame = 1
                    }


                    let homeTeam = Bool.random() ? team1 : team2; let awayTeam = (homeTeam.id == team1.id) ? team2 : team1
                    schedule.append(Game(week: weekForExtraGame, homeTeamID: homeTeam.id, awayTeamID: awayTeam.id, homeTeamName: homeTeam.name, awayTeamName: awayTeam.name, homeTeamLocation: homeTeam.location, awayTeamLocation: awayTeam.location))
                    gamesPlayedCounts[homeTeam.id, default: 0] += 1; gamesPlayedCounts[awayTeam.id, default: 0] += 1
                } else { print("Could not fill schedule for \(team1.name)."); break }
            }
        }
        print("Final random schedule: \(schedule.count) games. Counts:"); gamesPlayedCounts.forEach { print("Team \(teamsDict[$0.key]?.name ?? "?"): \($0.value)") }

        return schedule.sorted {
            if $0.week != $1.week { return $0.week < $1.week }
            if $0.homeTeamName != $1.homeTeamName { return $0.homeTeamName < $1.homeTeamName }
            return $0.awayTeamName < $1.awayTeamName
        }
        }

        static func simulateGame(homeTeam: Team, awayTeam: Team) -> (homeScore: Int, awayScore: Int, isTie: Bool) {
        let homeBaseStrength = homeTeam.overallRating; let awayBaseStrength = awayTeam.overallRating
        let homeAdvantage = 5; let skillDifference = homeBaseStrength + homeAdvantage - awayBaseStrength
        var homeScore = 10 + Int.random(in: 0...20); var awayScore = 10 + Int.random(in: 0...20)
        if skillDifference > 0 { homeScore += Int(Double(skillDifference)*0.5); awayScore -= Int(Double(skillDifference)*0.25) }
        else { awayScore += Int(Double(abs(skillDifference))*0.5); homeScore -= Int(Double(abs(skillDifference))*0.25) }
        homeScore = max(0, homeScore); awayScore = max(0, awayScore)
        let isTieGame = homeScore == awayScore
        return (homeScore, awayScore, isTieGame)
        }


        } // This is the final brace for struct SimulationEngine

        </immersive>

        2. ScheduleView.swift (Corrected)

        This version was provided in the previous response and should address its specific errors. Key things were defining GameRowView (or ensuring it's accessible), defining resetSchedule, handling the 3-part tuple from simulateGame, and fixing brace/syntax errors.

        <immersive type="code" title="ScheduleView.swift (Re-provide Corrected)" id="schedule_view_fix_4">

        Swift
        import SwiftUI

        // GameRowView should be defined here if not in its own file and only used by ScheduleView.
        // Ensure this is the ONLY definition of GameRowView.
        struct GameRowView: View {
        let game: Game
        let homeTeam: Team?
        let awayTeam: Team?

        var body: some View {
        HStack {
        VStack(alignment: .leading, spacing: 2) {
        HStack {
        Circle().fill(awayTeam?.color ?? .gray).frame(width: 10, height: 10)
        Text("(game.awayTeamLocation) (game.awayTeamName)")
        }
        Text("@").font(.caption).foregroundColor(.gray).padding(.leading, 15)
        HStack {
        Circle().fill(homeTeam?.color ?? .gray).frame(width: 10, height: 10)
        Text("(game.homeTeamLocation) (game.homeTeamName)")
        }
        }
        Spacer()
        if game.isPlayed {
        Text("(game.awayScore ?? 0) - (game.homeScore ?? 0)")
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

        // Using functions for computed properties that depend on league state for clarity
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
        if !allGamesPlayed() { // Check any past unplayed games
        return league.schedule.filter { !$0.isPlayed }.map { $0.week }.min()
        }
        return nil
        }

        private func allGamesPlayed() -> Bool {
        league.schedule.allSatisfy { $0.isPlayed }
        }

        var body: some View { // This ensures conformance to View
        List {
        Section(header: Text("Season Progress: Week (league.currentWeek) of (league.gamesPerSeason)")) {
        if league.schedule.isEmpty {
        Text("No schedule generated for (league.name).").foregroundColor(.gray).padding()
        } else {
        ForEach(sortedWeeks(), id: .self) { weekNumber in
        Section(header: Text("Week (weekNumber)")) {
        ForEach(gamesByWeek()[weekNumber] ?? []) { game in // Game is Identifiable
        GameRowView(game: game, homeTeam: team(byId: game.homeTeamID), awayTeam: team(byId: game.awayTeamID))
        }
        }
        }
        }
        }
        }
        .navigationTitle("(league.name) Schedule")
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

        var homeTeam = league.teams[homeTeamIndex]
        var awayTeam = league.teams[awayTeamIndex]

        homeTeam.pointsFor += homeScore
        homeTeam.pointsAgainst += awayScore
        awayTeam.pointsFor += awayScore
        awayTeam.pointsAgainst += homeScore

        let homeTeamConferenceId = homeTeam.conferenceId
        let homeTeamDivisionId = homeTeam.divisionId
        let awayTeamConferenceId = awayTeam.conferenceId
        let awayTeamDivisionId = awayTeam.divisionId

        if isTie {
            homeTeam.ties += 1; awayTeam.ties += 1
            if homeTeamConferenceId == awayTeamConferenceId {
                homeTeam.conferenceTies += 1; awayTeam.conferenceTies += 1
                if homeTeamDivisionId == awayTeamDivisionId {
                    homeTeam.divisionalTies += 1; awayTeam.divisionalTies += 1
                }
            }
        } else if homeScore > awayScore {
            homeTeam.wins += 1; awayTeam.losses += 1
            if homeTeamConferenceId == awayTeamConferenceId {
                homeTeam.conferenceWins += 1; awayTeam.conferenceLosses += 1
                if homeTeamDivisionId == awayTeamDivisionId {
                    homeTeam.divisionalWins += 1; awayTeam.divisionalLosses += 1
                }
            }
        } else {
            awayTeam.wins += 1; homeTeam.losses += 1
             if homeTeamConferenceId == awayTeamConferenceId {
                awayTeam.conferenceWins += 1; homeTeam.conferenceLosses += 1
                if homeTeamDivisionId == awayTeamDivisionId {
                    awayTeam.divisionalWins += 1; homeTeam.divisionalLosses += 1
                }
            }
        }
        league.teams[homeTeamIndex] = homeTeam
        league.teams[awayTeamIndex] = awayTeam
        }

        func simulateGamesForWeek(_ weekNum: Int) {
        guard weekNum <= league.gamesPerSeason else {
        print("Cannot sim week (weekNum)."); return
        }
        print("Simulating Week (weekNum)...")
        var gamesActuallySimulatedThisWeek = 0
        for i in league.schedule.indices {
        if league.schedule[i].week == weekNum && !league.schedule[i].isPlayed {
        guard let homeTeam = team(byId: league.schedule[i].homeTeamID),
        let awayTeam = team(byId: league.schedule[i].awayTeamID) else {
        print("Error finding teams for game in week (weekNum)"); continue
        }
        let simResult = SimulationEngine.simulateGame(homeTeam: homeTeam, awayTeam: awayTeam)

                var gameToUpdate = league.schedule[i]
                gameToUpdate.homeScore = simResult.homeScore
                gameToUpdate.awayScore = simResult.awayScore
                league.schedule[i] = gameToUpdate
                
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
        if let weekToSim = nextUnplayedWeek(), weekToSim <= league.gamesPerSeason {
        if league.currentWeek != weekToSim { league.currentWeek = weekToSim }
        simulateGamesForWeek(league.currentWeek)
        } else {
        print("No more games to sim or season over. Current week: (league.currentWeek)")
        if allGamesPlayed() && league.currentWeek <= league.gamesPerSeason {
        league.currentWeek = league.playoffStartWeek
        print("All games played. Set to playoff week: (league.currentWeek)")
        }
        }
        }

        func simulateToWeek(_ targetWeekInclusive: Int) {
        print("Simulating up to week (targetWeekInclusive)...")
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
                    if currentProcessingWeek <= league.gamesPerSeason {
                        league.currentWeek = currentProcessingWeek
                    }
                    continue // Added continue to advance the while loop properly
                } else {
                    if allGamesPlayed() { league.currentWeek = league.playoffStartWeek }
                    break
                }
            } // This brace was missing, potentially causing the "Expected '}' at end of brace statement" later
            
            simulateGamesForWeek(currentProcessingWeek)
            
            if allGamesPlayed() {
                 print("All regular season games simulated after processing week \(currentProcessingWeek).")
                 league.currentWeek = league.playoffStartWeek
                 break
            }
            
            if league.currentWeek > currentProcessingWeek {
                currentProcessingWeek = league.currentWeek
            } else {
                currentProcessingWeek += 1
                if currentProcessingWeek <= league.gamesPerSeason {
                    league.currentWeek = currentProcessingWeek
                } else if allGamesPlayed() {
                    league.currentWeek = league.playoffStartWeek
                    break;
                }
            }
        }

        if allGamesPlayed() && league.currentWeek <= league.gamesPerSeason {
            league.currentWeek = league.playoffStartWeek
        } else if !allGamesPlayed() && league.currentWeek > league.gamesPerSeason {
            league.currentWeek = nextUnplayedWeek() ?? league.playoffStartWeek
        }
        print("Finished simulating to target \(targetWeekInclusive). League current week: \(league.currentWeek)")
        }

        func resetSchedule() {
        print("Resetting schedule and team stats...")
        for i in league.schedule.indices {
        var gameToReset = league.schedule[i]
        gameToReset.homeScore = nil
        gameToReset.awayScore = nil
        league.schedule[i] = gameToReset
        }
        for i in league.teams.indices {
        league.teams[i].resetSeasonStats()
        }
        league.currentWeek = 1
        }


        }

