// SimulationEngine.swift

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
    // This array contains all 272 unique regular season games for 2025
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

        // AFC NORTH
        RawScheduledGame(week: 1, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
        RawScheduledGame(week: 2, awayTeamRealName: "Jacksonville Jaguars", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
        RawScheduledGame(week: 3, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
        RawScheduledGame(week: 9, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Cincinnati Bengals", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Cincinnati Bengals", neutralSiteLocation: nil), // Divisional
        
        RawScheduledGame(week: 2, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        RawScheduledGame(week: 3, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: "London"),
        RawScheduledGame(week: 6, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
        RawScheduledGame(week: 12, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Cleveland Browns", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Cleveland Browns", neutralSiteLocation: nil),

        RawScheduledGame(week: 3, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Houston Texans", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Baltimore Ravens", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Baltimore Ravens", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
        
        RawScheduledGame(week: 2, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: "Dublin"),
        RawScheduledGame(week: 8, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
        RawScheduledGame(week: 9, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Pittsburgh Steelers", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        RawScheduledGame(week: 12, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Pittsburgh Steelers", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),

        // AFC SOUTH
        RawScheduledGame(week: 2, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        RawScheduledGame(week: 3, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: "Berlin"),
        RawScheduledGame(week: 12, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Houston Texans", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Jacksonville Jaguars", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Jacksonville Jaguars", homeTeamRealName: "Indianapolis Colts", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Indianapolis Colts", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),

        RawScheduledGame(week: 1, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "Jacksonville Jaguars", neutralSiteLocation: nil),
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
        RawScheduledGame(week: 16, awayTeamRealName: "Jacksonville Jaguars", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Jacksonville Jaguars", neutralSiteLocation: nil),

        RawScheduledGame(week: 1, awayTeamRealName: "Houston Texans", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),
        RawScheduledGame(week: 2, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Houston Texans", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        RawScheduledGame(week: 9, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "Houston Texans", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Houston Texans", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Houston Texans", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Houston Texans", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),

        RawScheduledGame(week: 1, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        RawScheduledGame(week: 2, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        RawScheduledGame(week: 9, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        RawScheduledGame(week: 12, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Tennessee Titans", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Kansas City Chiefs", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Tennessee Titans", neutralSiteLocation: nil),

        // AFC WEST
        RawScheduledGame(week: 3, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "New York Giants", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "Kansas City Chiefs", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Denver Broncos", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "Denver Broncos", neutralSiteLocation: nil),

        RawScheduledGame(week: 1, awayTeamRealName: "Kansas City Chiefs", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: "São Paulo"),
        RawScheduledGame(week: 2, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Los Angeles Chargers", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Los Angeles Chargers", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),

        RawScheduledGame(week: 2, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 3, awayTeamRealName: "Kansas City Chiefs", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Kansas City Chiefs", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Kansas City Chiefs", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),

        RawScheduledGame(week: 3, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Las Vegas Raiders", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "New York Giants", homeTeamRealName: "Las Vegas Raiders", neutralSiteLocation: nil),

        // NFC EAST
        RawScheduledGame(week: 1, awayTeamRealName: "New York Giants", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 2, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),
        RawScheduledGame(week: 9, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Washington Commanders", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Washington Commanders", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Washington Commanders", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),

        RawScheduledGame(week: 1, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),
        RawScheduledGame(week: 3, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
        RawScheduledGame(week: 9, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),
        RawScheduledGame(week: 12, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Dallas Cowboys", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),

        RawScheduledGame(week: 3, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),
        RawScheduledGame(week: 4, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "New York Giants", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "Philadelphia Eagles", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Philadelphia Eagles", neutralSiteLocation: nil),

        RawScheduledGame(week: 2, awayTeamRealName: "New York Giants", homeTeamRealName: "Dallas Cowboys", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "New York Giants", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
        RawScheduledGame(week: 9, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "New York Giants", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),
        RawScheduledGame(week: 12, awayTeamRealName: "New York Giants", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "New York Giants", neutralSiteLocation: nil),

        // NFC NORTH
        RawScheduledGame(week: 1, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        RawScheduledGame(week: 2, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Chicago Bears", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Chicago Bears", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Chicago Bears", neutralSiteLocation: nil),

        RawScheduledGame(week: 1, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        RawScheduledGame(week: 9, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Detroit Lions", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Detroit Lions", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),

        RawScheduledGame(week: 7, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        RawScheduledGame(week: 9, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        RawScheduledGame(week: 12, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Green Bay Packers", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Green Bay Packers", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),

        RawScheduledGame(week: 2, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "Minnesota Vikings", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Minnesota Vikings", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),

        // NFC SOUTH
        RawScheduledGame(week: 1, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        RawScheduledGame(week: 6, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),
        RawScheduledGame(week: 8, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
        RawScheduledGame(week: 12, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Tampa Bay Buccaneers", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "Tampa Bay Buccaneers", neutralSiteLocation: nil),

        RawScheduledGame(week: 3, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
        RawScheduledGame(week: 7, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),
        RawScheduledGame(week: 12, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Atlanta Falcons", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Atlanta Falcons", neutralSiteLocation: nil),

        RawScheduledGame(week: 2, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
        RawScheduledGame(week: 12, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),
        RawScheduledGame(week: 13, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
        RawScheduledGame(week: 15, awayTeamRealName: "Carolina Panthers", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
        RawScheduledGame(week: 17, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Carolina Panthers", neutralSiteLocation: nil),
        
        RawScheduledGame(week: 1, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
        RawScheduledGame(week: 2, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "New Orleans Saints", neutralSiteLocation: nil),
        RawScheduledGame(week: 3, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        RawScheduledGame(week: 9, awayTeamRealName: "New Orleans Saints", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),

        // NFC WEST
        RawScheduledGame(week: 1, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        RawScheduledGame(week: 3, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),
        RawScheduledGame(week: 5, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),
        RawScheduledGame(week: 11, awayTeamRealName: "San Francisco 49ers", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "San Francisco 49ers", neutralSiteLocation: nil),

        RawScheduledGame(week: 4, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        RawScheduledGame(week: 10, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil),
        RawScheduledGame(week: 14, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Arizona Cardinals", neutralSiteLocation: nil),
        RawScheduledGame(week: 18, awayTeamRealName: "Arizona Cardinals", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),

        RawScheduledGame(week: 11, awayTeamRealName: "Seattle Seahawks", homeTeamRealName: "Los Angeles Rams", neutralSiteLocation: nil),
        RawScheduledGame(week: 16, awayTeamRealName: "Los Angeles Rams", homeTeamRealName: "Seattle Seahawks", neutralSiteLocation: nil)
    ];

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
             var uniqueGameEntries = Set<String>() // To track unique games by team pair + week

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
                     if let team = leagueTeams.first(where: {$0.id == teamId}) {
                         print("Team \(team.location) \(team.name) scheduled for \(count) real games.")
                     }
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

         print("Generating random schedule for \(gamesToPlayPerTeamTarget) games per team...")
         var schedule: [Game] = []
         var gamesPlayedCounts: [UUID: Int] = Dictionary(uniqueKeysWithValues: leagueTeams.map { ($0.id, 0) })
         let teamsDict = Dictionary(uniqueKeysWithValues: leagueTeams.map { ($0.id, $0) })
         let finalWeekDesignator = gamesToPlayPerTeamTarget
         var teamsNeedingFinalGame = Set(leagueTeams.map { $0.id })

         if finalWeekDesignator > 0 {
             for team1Id in teamsNeedingFinalGame.shuffled() {
                 guard teamsNeedingFinalGame.contains(team1Id), let team1 = teamsDict[team1Id] else { continue }
                 if (gamesPlayedCounts[team1Id] ?? 0) >= gamesToPlayPerTeamTarget {
                     teamsNeedingFinalGame.remove(team1Id)
                     continue
                 }
                 let potentialOpponents = leagueTeams.filter { team2 in
                     team1.id != team2.id &&
                     team1.conferenceId == team2.conferenceId && team1.divisionId == team2.divisionId &&
                     teamsNeedingFinalGame.contains(team2.id) &&
                     (gamesPlayedCounts[team2.id] ?? 0) < gamesToPlayPerTeamTarget
                 }
                 if let team2 = potentialOpponents.shuffled().first {
                     let homeTeam = Bool.random() ? team1 : team2
                     let awayTeam = (homeTeam.id == team1.id) ? team2 : team1
                     schedule.append(Game(week: finalWeekDesignator, homeTeamID: homeTeam.id, awayTeamID: awayTeam.id, homeTeamName: homeTeam.name, awayTeamName: awayTeam.name, homeTeamLocation: homeTeam.location, awayTeamLocation: awayTeam.location))
                     gamesPlayedCounts[homeTeam.id, default: 0] += 1
                     gamesPlayedCounts[awayTeam.id, default: 0] += 1
                     teamsNeedingFinalGame.remove(homeTeam.id)
                     teamsNeedingFinalGame.remove(awayTeam.id)
                 }
             }
             if !teamsNeedingFinalGame.isEmpty {
                 print("Warning: \(teamsNeedingFinalGame.count) teams still need final divisional game but couldn't be paired.")
             }
         }

         // ***** THIS IS THE CORRECTED LINE *****
         let regularWeeksRange = finalWeekDesignator > 1 ? (1...(finalWeekDesignator - 1)) : (1...1) // Corrected: both are ClosedRange<Int>
         // ***** END OF CORRECTION *****
         
         if finalWeekDesignator > 0 { // Ensure there's a season to iterate through
             // If finalWeekDesignator is 1, regularWeeksRange will be 1...1.
             // If finalWeekDesignator is, say, 2, regularWeeksRange will be 1...1.
             // The loop 'for week in 1...1' will execute for week = 1.
             // The loop 'for week in 1...(finalWeekDesignator-1)' will execute for weeks leading up to the final week.
             for week in regularWeeksRange {
                  // Ensure we don't try to schedule for week 0 if finalWeekDesignator was 1 (making range 1...0)
                 if finalWeekDesignator == 1 && week > 1 { continue } // Should not happen with 1...1 range

                 var teamsAvailableThisWeek = Set(leagueTeams.map{$0.id}).filter {
                     (gamesPlayedCounts[$0] ?? 0) < (gamesToPlayPerTeamTarget - (week == finalWeekDesignator && finalWeekDesignator > 0 ? 0 : 1))
                 }
                 let shuffledTeamsForWeek = leagueTeams.filter{ teamsAvailableThisWeek.contains($0.id) }.shuffled()
                 var scheduledInThisLoopPass: Set<UUID> = []

                 for team1 in shuffledTeamsForWeek {
                     guard teamsAvailableThisWeek.contains(team1.id), !scheduledInThisLoopPass.contains(team1.id) else { continue }
                     
                     let potentialOpponents = shuffledTeamsForWeek.filter { team2 in
                         team1.id != team2.id &&
                         teamsAvailableThisWeek.contains(team2.id) && !scheduledInThisLoopPass.contains(team2.id) &&
                         !schedule.contains(where: {
                             (($0.homeTeamID == team1.id && $0.awayTeamID == team2.id) || ($0.homeTeamID == team2.id && $0.awayTeamID == team1.id)) &&
                             ($0.week == week - 1 || $0.week == week - 2)
                         })
                     }
                     if let team2 = potentialOpponents.first {
                         let homeTeam = Bool.random() ? team1 : team2
                         let awayTeam = (homeTeam.id == team1.id) ? team2 : team1
                         schedule.append(Game(week: week, homeTeamID: homeTeam.id, awayTeamID: awayTeam.id, homeTeamName: homeTeam.name, awayTeamName: awayTeam.name, homeTeamLocation: homeTeam.location, awayTeamLocation: awayTeam.location))
                         gamesPlayedCounts[homeTeam.id, default: 0] += 1
                         gamesPlayedCounts[awayTeam.id, default: 0] += 1
                         scheduledInThisLoopPass.insert(homeTeam.id)
                         scheduledInThisLoopPass.insert(awayTeam.id)
                     }
                 }
             }
         }

         for teamId in leagueTeams.map({$0.id}) {
             guard let team1 = teamsDict[teamId] else { continue }
             while (gamesPlayedCounts[teamId] ?? 0) < gamesToPlayPerTeamTarget {
                 let potentialOpponents = leagueTeams.filter { $0.id != teamId && (gamesPlayedCounts[$0.id] ?? 0) < gamesToPlayPerTeamTarget }
                 
                 if let team2 = potentialOpponents.randomElement() {
                     var weekForExtraGame = 1
                     var foundWeek = false
                     
                     let weeksToConsider = finalWeekDesignator > 0 ? Array(1...finalWeekDesignator) : [1]
                     if finalWeekDesignator > 0 {
                         for w in weeksToConsider.shuffled() {
                             let t1PlaysThisWeek = schedule.contains { $0.week == w && ($0.homeTeamID == team1.id || $0.awayTeamID == team1.id) }
                             let t2PlaysThisWeek = schedule.contains { $0.week == w && ($0.homeTeamID == team2.id || $0.awayTeamID == team2.id) }
                             if !t1PlaysThisWeek && !t2PlaysThisWeek {
                                 weekForExtraGame = w
                                 foundWeek = true
                                 break
                             }
                         }
                         if !foundWeek {
                             weekForExtraGame = weeksToConsider.randomElement() ?? 1
                         }
                     }

                     let homeTeam = Bool.random() ? team1 : team2
                     let awayTeam = (homeTeam.id == team1.id) ? team2 : team1
                     
                     schedule.append(Game(week: weekForExtraGame, homeTeamID: homeTeam.id, awayTeamID: awayTeam.id, homeTeamName: homeTeam.name, awayTeamName: awayTeam.name, homeTeamLocation: homeTeam.location, awayTeamLocation: awayTeam.location))
                     gamesPlayedCounts[homeTeam.id, default: 0] += 1
                     gamesPlayedCounts[awayTeam.id, default: 0] += 1
                 } else {
                     print("Could not fill schedule for \(team1.name). Games: \(gamesPlayedCounts[teamId] ?? 0)/\(gamesToPlayPerTeamTarget)")
                     break
                 }
             }
         }
         
         print("Final random schedule: \(schedule.count) games. Counts:")
         gamesPlayedCounts.forEach { teamId, count in
             if let team = teamsDict[teamId] {
                 print("Team \(team.location) \(team.name): \(count)")
             }
         }
         
         return schedule.sorted {
             if $0.week != $1.week { return $0.week < $1.week }
             if $0.homeTeamName != $1.homeTeamName { return $0.homeTeamName < $1.homeTeamName }
             return $0.awayTeamName < $1.awayTeamName
         }
     }

     // ... (simulateGame function remains the same) ...
     static func simulateGame(homeTeam: Team, awayTeam: Team) -> (homeScore: Int, awayScore: Int, isTie: Bool) {
         let homeBaseStrength = homeTeam.overallRating
         let awayBaseStrength = awayTeam.overallRating
         let homeAdvantage = 5 // Points advantage for home team
         let skillDifference = homeBaseStrength + homeAdvantage - awayBaseStrength

         var homeScore = Int.random(in: 0...40) // Base score
         var awayScore = Int.random(in: 0...40) // Base score

         if skillDifference > 0 {
             homeScore += Int(Double(skillDifference) * 0.3 + Double(Int.random(in: 0...6)))
             awayScore -= Int(Double(skillDifference) * 0.1)
         } else {
             awayScore += Int(Double(abs(skillDifference)) * 0.3 + Double(Int.random(in: 0...6)))
             homeScore -= Int(Double(abs(skillDifference)) * 0.1)
         }
         
         homeScore = max(0, homeScore)
         awayScore = max(0, awayScore)
         
         var isTieGame = homeScore == awayScore
         if isTieGame {
             if Bool.random() { // 50% chance to break tie
                 if Bool.random() { homeScore += Int.random(in: 1...7) } else { awayScore += Int.random(in: 1...7) }
             }
             isTieGame = homeScore == awayScore
         }
         
         return (homeScore, awayScore, isTieGame)
     }
 }
