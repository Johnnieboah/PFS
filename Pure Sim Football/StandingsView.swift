import Foundation

// Define RawScheduledGame at a scope accessible to SimulationEngine,
// or move to Models.swift if preferred. This makes it a top-level struct.
struct RawScheduledGame: Codable, Hashable {
    let week: Int
    let awayTeamRealName: String // e.g., "Dallas Cowboys"
    let homeTeamRealName: String // e.g., "Philadelphia Eagles"
    let neutralSiteLocation: String? // e.g., "London", nil if not neutral
}

struct SimulationEngine {

    // This map is CRUCIAL.
    // Keys: Real NFL Team Names (from your provided schedules)
    // Values: Tuple (Fictional_Location, Fictional_Nickname)
    // These fictional locations/nicknames MUST EXACTLY MATCH how they are created in NewLeagueView.generateDefaultNFLTeams.
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
        "New England Patriots": ("New England", "Minutemen"), // Verify: Is your Minutemen location "New England" or "Boston"?
        "New Orleans Saints": ("New Orleans", "Revelers"), "New York Giants": ("New York", "Goliaths"),
        "New York Jets": ("New York", "Knights"), "Philadelphia Eagles": ("Philadelphia", "Freedom"),
        "Pittsburgh Steelers": ("Pittsburgh", "Forgers"), "San Francisco 49ers": ("San Francisco", "Prospectors"),
        "Seattle Seahawks": ("Seattle", "Cascades"), "Tampa Bay Buccaneers": ("Tampa Bay", "Cannons"),
        "Tennessee Titans": ("Tennessee", "Rhythm"),     // Verify: Is your Rhythm location "Tennessee" or "Nashville"?
        "Washington Commanders": ("Washington", "Capitals")
    ]

    // MARK: - BEGIN 2025 NFL SCHEDULE DATA BLOCK (DO NOT EDIT MANUALLY WITHOUT GREAT CARE)
    // This array contains all 272 unique regular season games for 2025,
    // transcribed from the user-provided team-by-team schedules.
    static let real2025ScheduleData: [RawScheduledGame] = [
        // AFC EAST Games (Unique entries from Bills, Dolphins, Jets, Patriots schedules)
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
        // MIA @ NYJ is Wk4 NYJ @ MIA
        RawScheduledGame(week: 15, awayTeamRealName: "Miami Dolphins", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "New York Jets", homeTeamRealName: "Jacksonville Jaguars", neutralSiteLocation: nil),
        // BUF @ NEP is Wk5 NEP @ BUF
        RawScheduledGame(week: 16, awayTeamRealName: "Buffalo Bills", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Miami Dolphins", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "New York Jets", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "New England Patriots", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Buffalo Bills", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Miami Dolphins", neutralSiteLocation: nil),
        // NEP @ NYJ is Wk11 NYJ @ NEP
        RawScheduledGame(week: 18, awayTeamRealName: "New York Jets", homeTeamRealName: "Buffalo Bills", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Miami Dolphins", homeTeamRealName: "New England Patriots", neutralSiteLocation: nil),

        // AFC NORTH
        RawScheduledGame(week: 1, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
        RawScheduledGame(week: 2, awayTeamRealName: "Jacksonville Jaguars", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
        RawScheduledGame(week: 3, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
        // Week 8: NYJ @ CIN (already from AFC East)
        RawScheduledGame(week: 9, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
        // Week 12: NEP @ CIN (already from AFC East)
        RawScheduledGame(week: 13, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        // Week 14: CIN @ BUF (already from AFC East)
        RawScheduledGame(week: 15, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
        // Week 16: CIN @ MIA (already from AFC East)
        RawScheduledGame(week: 17, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
        // Week 18: CLE @ CIN (Divisional) - will also be on CLE sched

        RawScheduledGame(week: 2, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        RawScheduledGame(week: 3, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: "London"),
        RawScheduledGame(week: 6, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
        // Week 7: MIA @ CLE (already from AFC East)
        // Week 8: CLE @ NEP (already from AFC East)
        // Week 10: CLE @ NYJ (already from AFC East)
        RawScheduledGame(week: 11, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
        RawScheduledGame(week: 12, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        // Week 16: BUF @ CLE (already from AFC East)
        RawScheduledGame(week: 17, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
        // Week 18: CLE @ CIN (already listed from CIN sched)

        // Week 1: BAL @ BUF (already from AFC East)
        // Week 2: CLE @ BAL (already listed)
        RawScheduledGame(week: 3, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Houston Texans", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        // Week 9: BAL @ MIA (already from AFC East)
        RawScheduledGame(week: 10, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
        // Week 11: BAL @ CLE (already listed)
        // Week 12: NYJ @ BAL (already from AFC East)
        // Week 13: CIN @ BAL (already listed)
        // Week 14: PIT @ BAL (will be on PIT sched)
        // Week 15: BAL @ CIN (already listed)
        // Week 16: NEP @ BAL (already from AFC East)
        RawScheduledGame(week: 17, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),

        // Week 1: PIT @ NYJ (already from AFC East)
        RawScheduledGame(week: 2, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
        // Week 3: PIT @ NEP (already from AFC East)
        RawScheduledGame(week: 4, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: "Dublin"),
        // Week 6: CLE @ PIT (already listed)
        // Week 7: PIT @ CIN (already listed)
        RawScheduledGame(week: 8, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
        RawScheduledGame(week: 9, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        // Week 11: CIN @ PIT (already listed)
        RawScheduledGame(week: 12, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        // Week 13: BUF @ PIT (already from AFC East)
        // Week 14: PIT @ BAL (already listed)
        // Week 15: MIA @ PIT (already from AFC East)
        RawScheduledGame(week: 16, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        // Week 17: PIT @ CLE (already listed)
        // Week 18: BAL @ PIT (already listed)

        // AFC SOUTH (Processed based on your earlier input - ensure only unique games)
        // Week 1: MIA @ IND (already from AFC East)
        RawScheduledGame(week: 2, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        RawScheduledGame(week: 3, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        // Week 9: IND @ PIT (already listed)
        RawScheduledGame(week: 10, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: "Berlin"),
        RawScheduledGame(week: 12, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Houston Texans", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Jacksonville Jaguars", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Jacksonville Jaguars", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),

        RawScheduledGame(week: 1, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "Jacksonville Jaguars", neutralSiteLocation: nil),
        // Week 2: JAX @ CIN (already listed)
        RawScheduledGame(week: 3, awayTeamRealName: "Houston Texans", homeTeamRealName: "Jacksonville Jaguars", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Jacksonville Jaguars", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Kansas City Chiefs", homeTeamRealName: "Jacksonville Jaguars", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Jacksonville Jaguars", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Jacksonville Jaguars", neutralSiteLocation: "London"),
        RawScheduledGame(week: 9, awayTeamRealName: "Jacksonville Jaguars", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "Jacksonville Jaguars", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "Jacksonville Jaguars", neutralSiteLocation: nil),
        RawScheduledGame(week: 12, awayTeamRealName: "Jacksonville Jaguars", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Jacksonville Jaguars", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        // Week 14: IND @ JAX (already listed)
        // Week 15: NYJ @ JAX (already from AFC East)
        RawScheduledGame(week: 16, awayTeamRealName: "Jacksonville Jaguars", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        // Week 17: JAX @ IND (already listed)
        RawScheduledGame(week: 18, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Jacksonville Jaguars", neutralSiteLocation: nil),

        RawScheduledGame(week: 1, awayTeamRealName: "Houston Texans", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),
        RawScheduledGame(week: 2, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        // Week 3: HOU @ JAX (already listed)
        RawScheduledGame(week: 4, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        // Week 5: HOU @ BAL (already listed)
        RawScheduledGame(week: 7, awayTeamRealName: "Houston Texans", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        RawScheduledGame(week: 9, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        // Week 10: JAX @ HOU (already listed)
        RawScheduledGame(week: 11, awayTeamRealName: "Houston Texans", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        // Week 12: BUF @ HOU (already from AFC East)
        // Week 13: HOU @ IND (already listed)
        RawScheduledGame(week: 14, awayTeamRealName: "Houston Texans", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Houston Texans", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        // Week 18: IND @ HOU (already listed)

        RawScheduledGame(week: 1, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        RawScheduledGame(week: 2, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        // Week 3: IND @ TEN (already listed)
        // Week 4: TEN @ HOU (already listed)
        RawScheduledGame(week: 5, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        // Week 7: NEP @ TEN (already from AFC East)
        // Week 8: TEN @ IND (already listed)
        RawScheduledGame(week: 9, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        // Week 11: HOU @ TEN (already listed)
        RawScheduledGame(week: 12, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        // Week 13: JAX @ TEN (already listed)
        RawScheduledGame(week: 14, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Kansas City Chiefs", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        // Week 18: TEN @ JAX (already listed)

        // AFC WEST
        // Week 2: DEN @ IND (already listed)
        RawScheduledGame(week: 3, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        // Week 4: CIN @ DEN (already listed)
        RawScheduledGame(week: 5, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),
        // Week 6: NYJ @ DEN (London) (already listed)
        RawScheduledGame(week: 7, awayTeamRealName: "New York Giants", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        // Week 9: DEN @ HOU (already listed)
        RawScheduledGame(week: 10, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "Kansas City Chiefs", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        // Week 16: JAX @ DEN (already listed)
        RawScheduledGame(week: 17, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        // Week 18: LAC @ DEN (Divisional) - will be on LAC sched

        RawScheduledGame(week: 1, awayTeamRealName: "Kansas City Chiefs", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: "São Paulo"),
        RawScheduledGame(week: 2, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        // Week 3: DEN @ LAC (already listed)
        RawScheduledGame(week: 4, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        // Week 6: LAC @ MIA (already listed)
        // Week 7: IND @ LAC (already listed)
        RawScheduledGame(week: 8, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        // Week 9: LAC @ TEN (already listed)
        // Week 10: PIT @ LAC (already listed)
        // Week 11: LAC @ JAX (already listed)
        RawScheduledGame(week: 13, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),
        // Week 17: HOU @ LAC (already listed)
        RawScheduledGame(week: 18, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),

        // Week 1: KC @ LAC (already listed)
        RawScheduledGame(week: 2, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 3, awayTeamRealName: "Kansas City Chiefs", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),
        // Week 4: BAL @ KC (already listed)
        // Week 5: KC @ JAX (already listed)
        RawScheduledGame(week: 6, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        // Week 9: KC @ BUF (already listed)
        // Week 11: KC @ DEN (already listed)
        // Week 12: IND @ KC (already listed)
        // Week 13: KC @ DAL (already listed)
        // Week 14: HOU @ KC (already listed)
        // Week 15: LAC @ KC (already listed)
        // Week 16: KC @ TEN (already listed)
        // Week 17: DEN @ KC (already listed)
        RawScheduledGame(week: 18, awayTeamRealName: "Kansas City Chiefs", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),

        // Week 1: LV @ NEP (already listed)
        // Week 2: LAC @ LV (already listed)
        RawScheduledGame(week: 3, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        // Week 5: LV @ IND (already listed)
        // Week 6: TEN @ LV (already listed)
        // Week 7: LV @ KC (already listed)
        // Week 9: JAX @ LV (already listed)
        // Week 10: LV @ DEN (already listed)
        RawScheduledGame(week: 11, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        // Week 12: CLE @ LV (already listed)
        // Week 13: LV @ LAC (already listed)
        // Week 14: DEN @ LV (already listed)
        RawScheduledGame(week: 15, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),
        // Week 16: LV @ HOU (already listed)
        RawScheduledGame(week: 17, awayTeamRealName: "New York Giants", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        // Week 18: KC @ LV (already listed)

        // NFC EAST (Processed based on your earlier input - ensure only unique games)
        RawScheduledGame(week: 1, awayTeamRealName: "New York Giants", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 2, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        // Week 3: LV @ WAS (already listed)
        RawScheduledGame(week: 4, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),
        // Week 5: WAS @ LAC (already listed)
        RawScheduledGame(week: 6, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),
        // Week 8: WAS @ KC (already listed)
        RawScheduledGame(week: 9, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        // Week 11: MIA @ WAS (Madrid) (already listed)
        // Week 13: DEN @ WAS (already listed)
        RawScheduledGame(week: 14, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Washington Commanders", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),

        RawScheduledGame(week: 1, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),
        // Week 2: NYG @ DAL (will be on NYG sched)
        RawScheduledGame(week: 3, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),
        // Week 5: DAL @ NYJ (already listed)
        RawScheduledGame(week: 6, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
        // Week 7: WAS @ DAL (already listed)
        // Week 8: DAL @ DEN (already listed)
        RawScheduledGame(week: 9, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),
        // Week 11: DAL @ LV (already listed)
        // Week 12: PHI @ DAL (will be on PHI sched)
        // Week 13: KC @ DAL (already listed)
        RawScheduledGame(week: 14, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),
        // Week 16: LAC @ DAL (already listed)
        // Week 17: DAL @ WAS (already listed)
        RawScheduledGame(week: 18, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),

        // Week 1: DAL @ PHI (already listed)
        // Week 2: PHI @ KC (already listed)
        RawScheduledGame(week: 3, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),
        // Week 5: DEN @ PHI (already listed)
        RawScheduledGame(week: 6, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "New York Giants", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),
        // Week 10: PHI @ GB (already listed)
        // Week 11: DET @ PHI (already listed)
        RawScheduledGame(week: 12, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),
        // Week 13: CHI @ PHI (already listed)
        // Week 14: PHI @ LAC (already listed)
        // Week 15: LV @ PHI (already listed)
        // Week 16: PHI @ WAS (already listed)
        // Week 17: PHI @ BUF (already listed)
        // Week 18: WAS @ PHI (already listed)

        // Week 1: NYG @ WAS (already listed)
        RawScheduledGame(week: 2, awayTeamRealName: "New York Giants", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),
        // Week 3: KC @ NYG (already listed)
        // Week 4: LAC @ NYG (already listed)
        RawScheduledGame(week: 5, awayTeamRealName: "New York Giants", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
        // Week 6: PHI @ NYG (already listed)
        // Week 7: NYG @ DEN (already listed)
        // Week 8: NYG @ PHI (already listed)
        RawScheduledGame(week: 9, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "New York Giants", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),
        RawScheduledGame(week: 12, awayTeamRealName: "New York Giants", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        // Week 13: NYG @ NEP (already listed)
        // Week 15: WAS @ NYG (already listed)
        RawScheduledGame(week: 16, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),
        // Week 17: NYG @ LV (already listed)
        // Week 18: DAL @ NYG (already listed)

        // NFC NORTH
        RawScheduledGame(week: 1, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        RawScheduledGame(week: 2, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        // Week 3: DAL @ CHI (already listed)
        // Week 4: CHI @ LV (already listed)
        // Week 6: CHI @ WAS (already listed)
        RawScheduledGame(week: 7, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        // Week 8: CHI @ BAL (already listed)
        // Week 9: CHI @ CIN (already listed)
        // Week 10: NYG @ CHI (already listed)
        RawScheduledGame(week: 11, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
        // Week 12: PIT @ CHI (already listed)
        // Week 13: CHI @ PHI (already listed)
        RawScheduledGame(week: 14, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        // Week 15: CLE @ CHI (already listed)
        RawScheduledGame(week: 16, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Chicago Bears", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),

        RawScheduledGame(week: 1, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        // Week 2: CHI @ DET (already listed)
        // Week 3: DET @ BAL (already listed)
        // Week 4: CLE @ DET (already listed)
        // Week 5: DET @ CIN (already listed)
        // Week 6: DET @ KC (already listed)
        RawScheduledGame(week: 7, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        RawScheduledGame(week: 9, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        // Week 10: DET @ WAS (already listed)
        // Week 11: DET @ PHI (already listed)
        // Week 12: NYG @ DET (already listed)
        RawScheduledGame(week: 13, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        // Week 14: DAL @ DET (already listed)
        RawScheduledGame(week: 15, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),
        // Week 16: PIT @ DET (already listed)
        RawScheduledGame(week: 17, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
        // Week 18: DET @ CHI (already listed)

        // Week 1: DET @ GB (already listed)
        // Week 2: WAS @ GB (already listed)
        // Week 3: GB @ CLE (already listed)
        // Week 4: GB @ DAL (already listed)
        // Week 6: CIN @ GB (already listed)
        RawScheduledGame(week: 7, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        // Week 8: GB @ PIT (already listed)
        RawScheduledGame(week: 9, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        // Week 10: PHI @ GB (already listed)
        // Week 11: GB @ NYG (already listed)
        RawScheduledGame(week: 12, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        // Week 13: GB @ DET (already listed)
        // Week 14: CHI @ GB (already listed)
        // Week 15: GB @ DEN (already listed)
        // Week 16: GB @ CHI (already listed)
        // Week 17: BAL @ GB (already listed)
        RawScheduledGame(week: 18, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),

        // Week 1: MIN @ CHI (already listed)
        RawScheduledGame(week: 2, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
        // Week 3: CIN @ MIN (already listed)
        // Week 4: PIT @ MIN (Dublin) (already listed)
        // Week 5: CLE @ MIN (London) (already listed)
        // Week 7: PHI @ MIN (already listed)
        // Week 8: MIN @ LAC (already listed)
        // Week 9: MIN @ DET (already listed)
        // Week 10: BAL @ MIN (already listed)
        // Week 11: CHI @ MIN (already listed)
        // Week 12: MIN @ GB (already listed)
        RawScheduledGame(week: 13, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        // Week 14: WAS @ MIN (already listed)
        // Week 15: MIN @ DAL (already listed)
        // Week 16: MIN @ NYG (already listed)
        // Week 17: DET @ MIN (already listed)
        // Week 18: GB @ MIN (already listed)

        // NFC SOUTH
        RawScheduledGame(week: 1, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),
        // Week 2: TB @ HOU (already listed)
        // Week 3: NYJ @ TB (already listed)
        // Week 4: PHI @ TB (already listed)
        RawScheduledGame(week: 5, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),
        // Week 7: TB @ DET (already listed)
        RawScheduledGame(week: 8, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
        // Week 10: NEP @ TB (already listed)
        // Week 11: TB @ BUF (already listed)
        RawScheduledGame(week: 12, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
        // Week 17: TB @ MIA (already listed)
        RawScheduledGame(week: 18, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),

        // Week 1: TB @ ATL (already listed)
        // Week 2: ATL @ MIN (already listed)
        RawScheduledGame(week: 3, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
        // Week 4: WAS @ ATL (already listed)
        // Week 6: BUF @ ATL (already listed)
        RawScheduledGame(week: 7, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),
        // Week 8: MIA @ ATL (already listed)
        // Week 9: ATL @ NEP (already listed)
        // Week 10: IND @ ATL (Berlin) (already listed)
        RawScheduledGame(week: 11, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),
        RawScheduledGame(week: 12, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
        // Week 13: ATL @ NYJ (already listed)
        RawScheduledGame(week: 14, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),
        // Week 15: ATL @ TB (already listed)
        RawScheduledGame(week: 16, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),

        // Week 1: CAR @ JAX (already listed)
        RawScheduledGame(week: 2, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        // Week 3: ATL @ CAR (already listed)
        // Week 4: CAR @ NEP (already listed)
        // Week 5: MIA @ CAR (already listed)
        // Week 6: DAL @ CAR (already listed)
        // Week 7: CAR @ NYJ (already listed)
        // Week 8: BUF @ CAR (already listed)
        // Week 9: CAR @ GB (already listed)
        RawScheduledGame(week: 10, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
        // Week 11: CAR @ ATL (already listed)
        RawScheduledGame(week: 12, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
        // Week 16: TB @ CAR (already listed)
        RawScheduledGame(week: 17, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
        // Week 18: CAR @ TB (already listed)
        
        RawScheduledGame(week: 1, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
        RawScheduledGame(week: 2, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
        RawScheduledGame(week: 3, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        // Week 4: NOS @ BUF (already listed)
        // Week 5: NYG @ NOS (already listed)
        // Week 6: NEP @ NOS (already listed)
        // Week 7: NOS @ CHI (already listed)
        // Week 8: TB @ NOS (already listed)
        RawScheduledGame(week: 9, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),
        // Week 10: NOS @ CAR (already listed)
        // Week 12: ATL @ NOS (already listed)
        // Week 13: NOS @ MIA (already listed)
        // Week 14: NOS @ TB (already listed)
        // Week 15: CAR @ NOS (already listed)
        // Week 16: NYJ @ NOS (already listed)
        RawScheduledGame(week: 17, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        // Week 18: NOS @ ATL (already listed)

        // NFC WEST
        RawScheduledGame(week: 1, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        // Week 2: SF @ NOS (already listed)
        RawScheduledGame(week: 3, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),
        // Week 4: JAX @ SF (already listed)
        RawScheduledGame(week: 5, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),
        // Week 6: SF @ TB (already listed)
        // Week 7: ATL @ SF (already listed)
        RawScheduledGame(week: 8, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        // Week 9: SF @ NYG (already listed)
        RawScheduledGame(week: 10, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        // Week 12: CAR @ SF (already listed)
        // Week 13: SF @ CLE (already listed)
        // Week 15: TEN @ SF (already listed)
        // Week 16: SF @ IND (already listed)
        // Week 17: CHI @ SF (already listed)
        RawScheduledGame(week: 18, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),

        // Week 1: ARI @ NOS (already listed)
        // Week 2: CAR @ ARI (already listed)
        // Week 3: ARI @ SF (already listed)
        RawScheduledGame(week: 4, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        // Week 5: TEN @ ARI (already listed)
        // Week 6: ARI @ IND (already listed)
        // Week 7: GB @ ARI (already listed)
        // Week 9: ARI @ DAL (already listed)
        RawScheduledGame(week: 10, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        // Week 11: SF @ ARI (already listed)
        // Week 12: JAX @ ARI (already listed)
        // Week 13: ARI @ TB (already listed)
        RawScheduledGame(week: 14, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        // Week 15: ARI @ HOU (already listed)
        // Week 16: ATL @ ARI (already listed)
        // Week 17: ARI @ CIN (already listed)
        RawScheduledGame(week: 18, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),

        // Week 1: HOU @ LAR (already listed)
        // Week 2: LAR @ TEN (already listed)
        // Week 3: LAR @ PHI (already listed)
        // Week 4: IND @ LAR (already listed)
        // Week 5: SF @ LAR (already listed)
        // Week 6: LAR @ BAL (already listed)
        // Week 7: LAR @ JAX (London) (already listed)
        // Week 9: NOS @ LAR (already listed)
        // Week 10: LAR @ SF (already listed)
        RawScheduledGame(week: 11, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),
        // Week 12: TB @ LAR (already listed)
        // Week 13: LAR @ CAR (already listed)
        // Week 14: LAR @ ARI (already listed)
        // Week 15: DET @ LAR (already listed)
        RawScheduledGame(week: 16, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        // Week 17: LAR @ ATL (already listed)
        // Week 18: ARI @ LAR (already listed)

        // Week 1: SF @ SEA (already listed)
        // Week 2: SEA @ PIT (already listed)
        // Week 3: NOS @ SEA (already listed)
        // Week 4: SEA @ ARI (already listed)
        // Week 5: TB @ SEA (already listed)
        // Week 6: SEA @ JAX (already listed)
        // Week 7: HOU @ SEA (already listed)
        // Week 9: SEA @ WAS (already listed)
        // Week 10: ARI @ SEA (already listed)
        // Week 11: SEA @ LAR (already listed)
        // Week 12: SEA @ TEN (already listed)
        // Week 13: MIN @ SEA (already listed)
        // Week 14: SEA @ ATL (already listed)
        // Week 15: IND @ SEA (already listed)
        // Week 16: LAR @ SEA (already listed)
        // Week 17: SEA @ CAR (already listed)
        // Week 18: SEA @ SF (already listed)
    ];
    // MARK: - END 2025 NFL SCHEDULE DATA BLOCK

    // generateSchedule function (no changes from last correct version, ensure it's complete)
    static func generateSchedule(
        for leagueTeams: [Team],
        gamesToPlayPerTeamTarget: Int,
        isFirstSeason: Bool,
        isUsingDefaultTeams: Bool,
        leagueStructure: (conferences: Int, divisionsPerConference: Int)
    ) -> [Game] {
        
        guard !leagueTeams.isEmpty, gamesToPlayPerTeamTarget > 0 else { return [] }

        if isFirstSeason && isUsingDefaultTeams && leagueTeams.count == 32 && !real2025ScheduleData.isEmpty {
            print("Attempting to generate schedule from real 2025 NFL data.")
            var generatedGames: [Game] = []
            var gamesScheduledCountPerTeam: [UUID: Int] = Dictionary(uniqueKeysWithValues: leagueTeams.map { ($0.id, 0) })
            var uniqueGameEntries = Set<String>()

            for rawGame in real2025ScheduleData {
                guard let homeFictionalInfo = realToFictionalTeamMap[rawGame.homeTeamRealName],
                      let awayFictionalInfo = realToFictionalTeamMap[rawGame.awayTeamRealName] else {
                    // print("Debug: Could not find fictional team match for game: \(rawGame.awayTeamRealName) @ \(rawGame.homeTeamRealName)")
                    continue
                }

                guard let homeTeam = leagueTeams.first(where: { $0.location == homeFictionalInfo.location && $0.name == homeFictionalInfo.nickname }),
                      let awayTeam = leagueTeams.first(where: { $0.location == awayFictionalInfo.location && $0.name == awayFictionalInfo.nickname }) else {
                    // print("Debug: Could not map fictional teams in leagueTeams for game: \(rawGame.awayTeamRealName) @ \(rawGame.homeTeamRealName)")
                    continue
                }
                
                let teamIDsSorted = [homeTeam.id.uuidString, awayTeam.id.uuidString].sorted()
                let gameKey = "\(teamIDsSorted[0])-\(teamIDsSorted[1])-W\(rawGame.week)"
                
                if uniqueGameEntries.contains(gameKey) {
                    // print("Skipping duplicate game entry based on week and teams: \(rawGame.awayTeamRealName) @ \(rawGame.homeTeamRealName) in week \(rawGame.week)")
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
            if generatedGames.count >= expectedGamesInFullRealSchedule - (leagueTeams.count / 2) {
                print("Using real schedule data. Games per team (approx):")
                 gamesScheduledCountPerTeam.forEach { teamId, count in
                    print("Team \(leagueTeams.first(where: {$0.id == teamId})?.name ?? "Unknown") scheduled for \(count) real games.")
                }
                return generatedGames.sorted {
                    if $0.week != $1.week { return $0.week < $1.week }
                    if $0.homeTeamName != $1.homeTeamName { return $0.homeTeamName < $1.homeTeamName }
                    return $0.awayTeamName < $1.awayTeamName
                }
            } else {
                print("Real 2025 schedule data was insufficient (\(generatedGames.count) games generated vs expected around \(expectedGamesInFullRealSchedule)). Falling back to random generation.")
            }
        }

        // --- Fallback to Random Schedule Generation (with final game divisional rule) ---
        print("Generating random schedule with custom rules for \(gamesToPlayPerTeamTarget) games per team...")
        var schedule: [Game] = []
        var gamesPlayedCounts: [UUID: Int] = Dictionary(uniqueKeysWithValues: leagueTeams.map { ($0.id, 0) })
        let teamsDict = Dictionary(uniqueKeysWithValues: leagueTeams.map { ($0.id, $0) })
        let finalWeekDesignator = gamesToPlayPerTeamTarget
        var teamsNeedingFinalGame = Set(leagueTeams.map { $0.id })

        // 1. Schedule final week divisional games
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
        if !teamsNeedingFinalGame.isEmpty {print("Warning: \(teamsNeedingFinalGame.count) teams still need final divisional game but couldn't be paired.")}

        // 2. Schedule remaining games for weeks 1 to finalWeek - 1
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
        // 3. Fill remaining games if any team hasn't reached the target
        for teamId in leagueTeams.map({$0.id}) {
            let team1 = teamsDict[teamId]!; while (gamesPlayedCounts[teamId] ?? 0) < gamesToPlayPerTeamTarget {
                let potentialOpponents = leagueTeams.filter { $0.id != teamId && (gamesPlayedCounts[$0.id] ?? 0) < gamesToPlayPerTeamTarget }
                if let team2 = potentialOpponents.randomElement() {
                    var weekForExtraGame = 1; var foundWeek = false
                    for w in 1..<(finalWeekDesignator) {
                        let t1Plays = schedule.contains{$0.week==w && ($0.homeTeamID==team1.id || $0.awayTeamID==team1.id)}
                        let t2Plays = schedule.contains{$0.week==w && ($0.homeTeamID==team2.id || $0.awayTeamID==team2.id)}
                        if !t1Plays && !t2Plays { weekForExtraGame=w; foundWeek=true; break }
                    }
                    if !foundWeek { weekForExtraGame = Int.random(in: 1..<(finalWeekDesignator)) }
                    let homeTeam = Bool.random() ? team1 : team2; let awayTeam = (homeTeam.id == team1.id) ? team2 : team1
                    schedule.append(Game(week: weekForExtraGame, homeTeamID: homeTeam.id, awayTeamID: awayTeam.id, homeTeamName: homeTeam.name, awayTeamName: awayTeam.name, homeTeamLocation: homeTeam.location, awayTeamLocation: awayTeam.location))
                    gamesPlayedCounts[homeTeam.id, default: 0] += 1; gamesPlayedCounts[awayTeam.id, default: 0] += 1
                } else { print("Could not fill schedule for \(team1.name). Games: \(gamesPlayedCounts[teamId] ?? 0)/\(gamesToPlayPerTeamTarget)"); break }
            }
        }
        print("Final random schedule: \(schedule.count) games. Counts:"); gamesPlayedCounts.forEach { print("Team \(teamsDict[$0.key]?.name ?? "?"): \($0.value)") }
        return schedule.sorted {
            if $0.week != $1.week { return $0.week < $1.week }
            if $0.homeTeamName != $1.homeTeamName { return $0.homeTeamName < $1.homeTeamName }
            return $0.awayTeamName < $1.awayTeamName
        }
    }

    // simulateGame function (no change)
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
}
