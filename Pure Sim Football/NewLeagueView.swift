//
//  NewLeagueView.swift
//  Pure Sim Football
//
//  Created by Jay Estep on 5/22/25.
//

import SwiftUI
import UIKit

struct NewLeagueView: View {
    // League and UI State
    @State private var useDefaultTeams: Bool = true
    @State private var league: League = League(id: UUID(), name: "", teams: [])
    @State private var leagueLogo: UIImage? = nil
    @State private var selectedTeam: Team? = nil

    // Settings Sheet Presentation
    @State private var showingSettingsSheet = true

    // League Structure Settings
    @State private var numberOfConferences: Int = 2
    @State private var numberOfDivisions: Int = 4
    @State private var teamsPerDivision: Int = 4
    @State private var gamesPerSeason: Int = 17

    // Playoff Settings
    @State private var maxPlayoffTeamsPerConference: Int = 7
    @State private var wildcardRoundByes: Int = 1
    @State private var divisionWinnersTopSeeds: Bool = true
    @State private var bracketReseedAfterRoundOne: Bool = false
    
    // Save Slot Management
    @State private var saveSlots: [SaveSlot] = []
    private let defaultSlotIdForNewLeague = 0

    // Alerting
    @State private var showingStatusAlert = false
    @State private var statusMessage = ""

    // Callback to MainMenuView
    var onLeagueCreatedAndReadyToNavigate: ((_ newLeague: League, _ newLogo: UIImage?, _ savedToSlotId: Int) -> Void)?

    var body: some View {
        NavigationView { // This NavigationView provides the context for .navigationTitle and .toolbar
            List {
                teamsSection(teams: league.teams)

                Section {
                    Button("Edit League Settings") {
                        showingSettingsSheet = true
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle(league.name.isEmpty ? "New League Setup" : league.name)
            .toolbar { // This is the toolbar that had the ambiguous use error.
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save & Start League") {
                        saveLeagueToDefaultSlotAndProceed()
                    }
                }
            }
            .sheet(isPresented: $showingSettingsSheet) {
                // This call requires LeagueSettingsView to be defined ONLY in LeaguesSettingsView.swift
                LeagueSettingsView(
                    useDefaultTeams: $useDefaultTeams,
                    leagueName: $league.name,
                    leagueLogo: $leagueLogo,
                    numberOfConferences: $numberOfConferences,
                    numberOfDivisions: $numberOfDivisions,
                    teamsPerDivision: $teamsPerDivision,
                    gamesPerSeason: $gamesPerSeason,
                    maxPlayoffTeamsPerConference: $maxPlayoffTeamsPerConference,
                    wildcardRoundByes: $wildcardRoundByes,
                    divisionWinnersTopSeeds: $divisionWinnersTopSeeds,
                    bracketReseedAfterRoundOne: $bracketReseedAfterRoundOne,
                    onDone: {
                        let viewInstanceCreationID = self.league.id
                        print("-------- LeagueSettingsView.onDone Called (NewLeagueView instance's initial league ID: \(viewInstanceCreationID)) --------")
                        print("Current state before team generation: useDefaultTeams=\(self.useDefaultTeams), name='\(self.league.name)', confs=\(self.numberOfConferences), divs=\(self.numberOfDivisions), teams/div=\(self.teamsPerDivision)")
                        
                        var generatedTeamsArray: [Team] = []
                        if self.useDefaultTeams {
                            print("Condition: useDefaultTeams is TRUE. Generating default NFL teams...")
                            generatedTeamsArray = generateDefaultNFLTeams()
                            print("generateDefaultNFLTeams() produced \(generatedTeamsArray.count) teams.")
                        } else {
                            print("Condition: useDefaultTeams is FALSE. Generating placeholder teams...")
                            generatedTeamsArray = generatePlaceholderTeams(
                                conferences: self.numberOfConferences,
                                divisionsPerConference: self.numberOfDivisions,
                                teamsPerDivision: self.teamsPerDivision
                            )
                            print("generatePlaceholderTeams() produced \(generatedTeamsArray.count) teams.")
                        }
                        
                        let leagueNameFromSettings = self.league.name
                        print("Attempting to set teams. Current self.league.id before creating new League object for state: \(self.league.id)")
                        print("League name from settings binding: '\(leagueNameFromSettings)'")
                        
                        let newLeagueData = League(
                            id: UUID(),
                            name: leagueNameFromSettings,
                            teams: generatedTeamsArray
                        )
                        
                        print("Assigning new League object to self.league. New League object ID: \(newLeagueData.id), teams count: \(newLeagueData.teams.count)")
                        self.league = newLeagueData
                        
                        print("IMMEDIATELY AFTER ASSIGNMENT TO SELF.LEAGUE:")
                        print("self.league.id = \(self.league.id)")
                        print("self.league.name = '\(self.league.name)'")
                        print("self.league.teams.count = \(self.league.teams.count)")

                        if self.league.teams.isEmpty && !generatedTeamsArray.isEmpty {
                            print("CRITICAL FAILURE: self.league.teams IS STILL EMPTY after assigning a brand new League object with \(generatedTeamsArray.count) teams and a new ID.")
                        }
                        
                        print("-------------------------------------------------")
                        self.showingSettingsSheet = false
                    }
                )
            }
            .sheet(item: $selectedTeam) { teamToEdit in
                TeamEditorView(team: binding(for: teamToEdit))
            }
            .onAppear {
                print("NewLeagueView Appeared. Current league ID (from @State init): \(league.id), Initial useDefaultTeams: \(useDefaultTeams), teams count: \(league.teams.count), league name: '\(league.name)'")
                LocalFileHelper.loadAndInitializeSaveSlots { loadedSlots in
                    self.saveSlots = loadedSlots
                }
            }
            .alert("League Status", isPresented: $showingStatusAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(statusMessage)
            }
        } // End of NavigationView
    }

    func teamsSection(teams: [Team]) -> some View {
         Section(header: Text(league.teams.isEmpty ? "Configure Teams in League Settings" : "Teams (\(teams.count))")) {
            if teams.isEmpty {
                Text("Open 'Edit League Settings' to define your league structure and generate teams.")
                    .foregroundColor(.gray)
                    .padding(.vertical)
            } else {
                ForEach(teams) { team in
                    Button(action: { selectedTeam = team }) {
                        TeamRowView(team: team)
                    }
                }
            }
        }
    }

    func binding(for team: Team) -> Binding<Team> {
        guard let index = league.teams.firstIndex(where: { $0.id == team.id }) else {
            fatalError("Team not found for binding in NewLeagueView.")
        }
        return $league.teams[index]
    }

    func saveLeagueToDefaultSlotAndProceed() {
        if self.league.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.league.name = "My New League"
            print("League name was empty, set to default: \(self.league.name)")
        }

        let targetSlotId = findTargetSlotForNewLeague()

        guard let chosenSlot = self.saveSlots.first(where: { $0.id == targetSlotId }) else {
            self.statusMessage = "Error: Could not determine a valid save slot. (Available slots: \(self.saveSlots.map { $0.id }))"
            self.showingStatusAlert = true
            print("Save Error: Could not find target slot \(targetSlotId) in available slots: \(self.saveSlots.map { $0.id })")
            return
        }
        
        print("Attempting to save league '\(self.league.name)' (ID: \(self.league.id)) with \(self.league.teams.count) teams to slot \(chosenSlot.id + 1) (ID: \(chosenSlot.id))")
        let leagueFileToSave = chosenSlot.leagueFileName
        let logoFileToSave = chosenSlot.logoFileName

        LocalFileHelper.saveCodable(self.league, to: leagueFileToSave) { leagueSaveSuccess in
            if leagueSaveSuccess {
                print("Successfully saved league data to \(leagueFileToSave)")
                if let logo = self.leagueLogo {
                    LocalFileHelper.saveImage(logo, fileName: logoFileToSave) { logoSaveSuccess in
                        if logoSaveSuccess {
                            print("Successfully saved logo to \(logoFileToSave)")
                            self.updateMetadataAndNavigate(slotId: chosenSlot.id, leagueName: self.league.name)
                        } else {
                            print("NewLeagueView: League data saved, but logo save failed for \(logoFileToSave). Proceeding with metadata.")
                            self.updateMetadataAndNavigate(slotId: chosenSlot.id, leagueName: self.league.name)
                        }
                    }
                } else {
                    print("No logo to save. Proceeding with metadata update.")
                    self.updateMetadataAndNavigate(slotId: chosenSlot.id, leagueName: self.league.name)
                }
            } else {
                self.statusMessage = "Failed to save league data to slot \(chosenSlot.id + 1)."
                self.showingStatusAlert = true
                print("Failed to save league data to \(leagueFileToSave)")
            }
        }
    }
    
    func findTargetSlotForNewLeague() -> Int {
        if saveSlots.isEmpty {
             print("findTargetSlotForNewLeague: saveSlots is empty initially.")
        }

        if let emptySlot = saveSlots.first(where: { $0.isEmpty }) {
            print("Found empty slot: \(emptySlot.id + 1) (ID: \(emptySlot.id))")
            return emptySlot.id
        }
        print("Warning: No empty save slots found. Defaulting to slot \(defaultSlotIdForNewLeague + 1) (ID: \(defaultSlotIdForNewLeague)) for new league. User should ideally be prompted.")
        return defaultSlotIdForNewLeague
    }

    func updateMetadataAndNavigate(slotId: Int, leagueName: String) {
        LocalFileHelper.updateSaveSlot(id: slotId, leagueName: leagueName, lastModified: Date()) { metadataSuccess in
            if metadataSuccess {
                print("NewLeagueView: Metadata updated for slot \(slotId + 1). Navigating.")
                self.onLeagueCreatedAndReadyToNavigate?(self.league, self.leagueLogo, slotId)
            } else {
                self.statusMessage = "League data saved, but failed to update save slot metadata for slot \(slotId + 1)."
                self.showingStatusAlert = true
                print("Failed to update metadata for slot \(slotId + 1)")
            }
        }
    }

    func generateDefaultNFLTeams() -> [Team] {
        let citiesAndNamesAndColors: [(String, String, String)] = [
            ("Arizona", "Firehawks", "#FF0000"), ("Atlanta", "Scorchers", "#FFA500"),
            ("Baltimore", "Ironclads", "#800080"), ("Buffalo", "Blizzard", "#0000FF"),
            ("Carolina", "Sentinels", "#808080"), ("Chicago", "Windstorm", "#008000"),
            ("Cincinnati", "Kingsmen", "#FFA500"), ("Cleveland", "Guardians", "#A52A2A"),
            ("Dallas", "Rangers", "#000080"), ("Denver", "Mountaineers", "#FF4500"),
            ("Detroit", "Motors", "#00BFFF"), ("Green Bay", "Icebreakers", "#20B2AA"),
            ("Houston", "Apollos", "#DC143C"), ("Indianapolis", "Speedways", "#1E90FF"),
            ("Jacksonville", "Sharks", "#008080"), ("Kansas City", "Stampede", "#E60000"),
            ("Las Vegas", "Barracudas", "#A9A9A9"), ("Los Angeles", "Comets", "#FFD700"),
            ("Miami", "Revolution", "#00FFFF"), ("Minnesota", "Vikings", "#4B0082"),
            ("New England", "Empire", "#0000CD"), ("New Orleans", "Legends", "#D4AF37"),
            ("New York", "Giants", "#001E4D"), ("New York", "Jets", "#003F2D"),
            ("Philadelphia", "Eagles", "#004C54"), ("Pittsburgh", "Steelers", "#FFB612"),
            ("San Francisco", "Miners", "#AA0000"), ("Seattle", "Seahawks", "#69BE28"),
            ("Tampa Bay", "Buccaneers", "#D50A0A"), ("Tennessee", "Titans", "#4B92DB"),
            ("Los Angeles", "Rams", "#003594"), ("Washington", "Commanders", "#5A1414")
        ]
        if citiesAndNamesAndColors.count != 32 {
             print("CRITICAL WARNING: generateDefaultNFLTeams citiesAndNamesAndColors array does not have 32 teams! It has \(citiesAndNamesAndColors.count). This will cause issues.")
        }
        return citiesAndNamesAndColors.map { city, name, hexColor in
            Team(id: UUID(), name: name, location: city, players: generatePlayers(), colorHex: hexColor)
        }
    }

    func generatePlaceholderTeams(conferences: Int, divisionsPerConference: Int, teamsPerDivision: Int) -> [Team] {
        var placeholderTeams: [Team] = []
        let totalTeams = conferences * divisionsPerConference * teamsPerDivision
        guard totalTeams > 0 else {
            print("generatePlaceholderTeams: Total teams calculated to 0 based on C:\(conferences) D:\(divisionsPerConference) T:\(teamsPerDivision). Returning empty array.")
            return []
        }
        for i in 0..<totalTeams {
            placeholderTeams.append(
                Team(id: UUID(),
                     name: "Custom Team \(i + 1)",
                     location: "City \(i + 1)",
                     players: [],
                     colorHex: String(format: "#%02X%02X%02X", Int.random(in:0...255), Int.random(in:0...255), Int.random(in:0...255)))
            )
        }
        return placeholderTeams
    }

    func generatePlayers() -> [Player] {
        let positions = ["QB", "RB", "WR", "TE", "OL", "DL", "LB", "CB", "S", "K", "P"]
        let firstNames = ["Alex", "Chris", "Jordan", "Taylor", "Morgan", "Jamie", "Casey", "Drew", "Blake", "Cameron"]
        let lastNames = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Miller", "Davis", "Wilson", "Moore", "Taylor"]
        var players: [Player] = []
        for _ in 1...53 {
             let potential = Int.random(in: 50...99)
             let overall = Int.random(in: 50...potential)
             players.append(Player(id: UUID(),
                name: "\(firstNames.randomElement()!) \(lastNames.randomElement()!)",
                position: positions.randomElement()!,
                overall: overall, age: Int.random(in: 20...35), potential: potential ))
        }
        return players
    }
}
 
struct TeamRowView: View {
    let team: Team
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(team.location) \(team.name)")
                .font(.headline)
                .foregroundColor(team.color)
        }
    }
}
//test comment
