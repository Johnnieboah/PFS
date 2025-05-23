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
    @State private var league: League = League(id: UUID(), name: "", teams: [], isCommissionerMode: false, userTeamId: nil, schedule: [], gamesPerSeason: 17, currentSeasonYear: 2025, numberOfConferences: 2, divisionsPerConference: 4)
    @State private var leagueLogo: UIImage? = nil
    
    // CORRECTED: Ensure this @State variable is declared
    @State private var selectedTeamForEditing: Team? = nil

    // Settings Sheet Presentation & State
    @State private var showingSettingsSheet = true
    
    // Temporary state vars for settings sheet to bind to
    @State private var tempLeagueName: String = ""
    @State private var tempIsCommissionerMode: Bool = false
    @State private var tempUseDefaultTeams: Bool = true
    @State private var tempNumberOfConferences: Int = 2
    @State private var tempNumberOfDivisions: Int = 4
    @State private var tempTeamsPerDivision: Int = 4
    @State private var tempGamesPerSeason: Int = 17
    @State private var tempMaxPlayoffTeamsPerConference: Int = 7
    @State private var tempWildcardRoundByes: Int = 1
    @State private var tempDivisionWinnersTopSeeds: Bool = true
    @State private var tempBracketReseedAfterRoundOne: Bool = false
    
    @State private var hasCompletedSettingsAndTeamGeneration = false

    // Save Slot Management
    @State private var saveSlots: [SaveSlot] = []
    private let defaultSlotIdForNewLeague = 0

    // Alerting
    @State private var showingStatusAlert = false
    @State private var statusMessage = ""

    // Callback to MainMenuView
    var onLeagueCreatedAndReadyToNavigate: ((_ newLeague: League, _ newLogo: UIImage?, _ savedToSlotId: Int) -> Void)?

    var body: some View {
        NavigationView {
            VStack {
                if !hasCompletedSettingsAndTeamGeneration {
                    VStack {
                        Spacer(); Text("Welcome!").font(.title2).padding(.bottom)
                        Text("Configure your league.").multilineTextAlignment(.center).padding(.horizontal)
                        Button("Configure League Settings") {
                            tempLeagueName = league.name; tempIsCommissionerMode = league.isCommissionerMode
                            tempUseDefaultTeams = useDefaultTeams
                            tempNumberOfConferences = league.numberOfConferences; tempNumberOfDivisions = league.divisionsPerConference
                            if league.numberOfConferences > 0 && league.divisionsPerConference > 0 && !league.teams.isEmpty {
                                tempTeamsPerDivision = league.teams.count / (league.numberOfConferences * league.divisionsPerConference)
                                if tempTeamsPerDivision < 2 { tempTeamsPerDivision = 4 }
                            } else { tempTeamsPerDivision = 4 }
                            tempGamesPerSeason = league.gamesPerSeason
                            // TODO: Initialize temp playoff settings from league state if they are added to League struct
                            // tempMaxPlayoffTeamsPerConference = league.maxPlayoffTeamsPerConference (example)
                            // tempWildcardRoundByes = league.wildcardRoundByes (example)
                            showingSettingsSheet = true
                        }.buttonStyle(.borderedProminent).padding(); Spacer()
                    }
                } else if !league.isCommissionerMode && league.userTeamId == nil {
                    Text("Settings done. Select your team:").padding()
                    List {
                        // Pass the teams array directly
                        teamsSection(teams: league.teams)
                    }
                    Button("Confirm Team & Save") { saveLeagueToDefaultSlotAndProceed() }
                        .buttonStyle(.borderedProminent).disabled(league.userTeamId == nil).padding()
                } else {
                    VStack {
                        if league.isCommissionerMode { Text("Commissioner Mode").font(.headline).foregroundColor(.orange).padding(.top) }
                        else if let team = league.teams.first(where: {$0.id == league.userTeamId}) { Text("Your Team: \(team.location) \(team.name)").font(.headline).foregroundColor(.blue).padding(.top) }
                        Text(league.schedule.isEmpty ? "Review teams or save to create schedule." : "Review teams or save.").font(.caption).foregroundColor(.gray).padding(.bottom, 5)
                        List {
                            // Pass the teams array directly
                            teamsSection(teams: league.teams)
                        }
                    }
                    Button("Save & Start League") { saveLeagueToDefaultSlotAndProceed() }.buttonStyle(.borderedProminent).padding()
                }
            }
            .navigationTitle(league.name.isEmpty ? "New League Setup" : league.name)
            .sheet(isPresented: $showingSettingsSheet) {
                LeagueSettingsView(
                    useDefaultTeams: $tempUseDefaultTeams,
                    leagueName: $tempLeagueName,
                    leagueLogo: $leagueLogo,
                    isCommissionerMode: $tempIsCommissionerMode,
                    numberOfConferences: $tempNumberOfConferences,
                    numberOfDivisions: $tempNumberOfDivisions,
                    teamsPerDivision: $tempTeamsPerDivision,
                    gamesPerSeason: $tempGamesPerSeason,
                    maxPlayoffTeamsPerConference: $tempMaxPlayoffTeamsPerConference,
                    wildcardRoundByes: $tempWildcardRoundByes,
                    divisionWinnersTopSeeds: $tempDivisionWinnersTopSeeds,
                    bracketReseedAfterRoundOne: $tempBracketReseedAfterRoundOne,
                    onDone: { handleSettingsDone() }
                )
            }
            .sheet(item: $selectedTeamForEditing) { teamToEdit in
                 TeamEditorView(team: binding(for: teamToEdit),
                    onTeamSelectedAsUserTeam: { selectedTeamID in
                        var updatedLeague = self.league; updatedLeague.userTeamId = selectedTeamID; self.league = updatedLeague
                        self.selectedTeamForEditing = nil
                    }, isBeingUsedForInitialSelection: !self.league.isCommissionerMode )
            }
            .onAppear {
                print("NewLeagueView Appeared. League ID: \(league.id), Commish: \(league.isCommissionerMode), UserTeam: \(league.userTeamId?.uuidString ?? "nil")")
                LocalFileHelper.loadAndInitializeSaveSlots { loadedSlots in self.saveSlots = loadedSlots }
                if !hasCompletedSettingsAndTeamGeneration { showingSettingsSheet = true }
            }
            .alert("Status", isPresented: $showingStatusAlert) { Button("OK"){}} message: { Text(statusMessage) }
        }
    }
    
    func handleSettingsDone() {
        var workingLeague = League(
            id: self.league.id,
            name: self.tempLeagueName, teams: [],
            isCommissionerMode: self.tempIsCommissionerMode, userTeamId: nil,
            schedule: [], gamesPerSeason: self.tempGamesPerSeason,
            currentSeasonYear: 2025,
            numberOfConferences: self.tempNumberOfConferences,
            divisionsPerConference: self.tempNumberOfDivisions
        )
        let teamsPerDivisionToUse = tempUseDefaultTeams ? 4 : self.tempTeamsPerDivision
        print("handleSettingsDone: useDefault=\(tempUseDefaultTeams), name='\(workingLeague.name)', commish=\(workingLeague.isCommissionerMode), games=\(workingLeague.gamesPerSeason), confs=\(workingLeague.numberOfConferences), divs/conf=\(workingLeague.divisionsPerConference), teams/div=\(teamsPerDivisionToUse)")

        var generatedTeamsArray: [Team] = []
        if self.tempUseDefaultTeams {
            workingLeague.numberOfConferences = 2
            workingLeague.divisionsPerConference = 4
            generatedTeamsArray = generateDefaultNFLTeams(numberOfConferences: 2, divisionsPerConference: 4, teamsPerDivision: 4 )
        } else {
            generatedTeamsArray = generatePlaceholderTeams(
                numberOfConferences: workingLeague.numberOfConferences,
                divisionsPerConference: workingLeague.divisionsPerConference,
                teamsPerDivision: teamsPerDivisionToUse
            )
        }
        workingLeague.teams = generatedTeamsArray
        print("Teams generated. Count: \(workingLeague.teams.count)")
        
        if !workingLeague.teams.isEmpty {
            workingLeague.schedule = SimulationEngine.generateSchedule(
                for: workingLeague.teams,
                gamesToPlayPerTeamTarget: workingLeague.gamesPerSeason,
                isFirstSeason: true,
                isUsingDefaultTeams: self.tempUseDefaultTeams,
                leagueStructure: (conferences: workingLeague.numberOfConferences, divisionsPerConference: workingLeague.divisionsPerConference)
            )
            print("Schedule generated with \(workingLeague.schedule.count) games.")
        } else { workingLeague.schedule = [] }
        
        self.league = workingLeague
        print("Final league state: ID=\(self.league.id), Name='\(self.league.name)', Teams=\(self.league.teams.count), Commish=\(self.league.isCommissionerMode), Schedule=\(self.league.schedule.count), Games/Season=\(self.league.gamesPerSeason)")
        
        self.hasCompletedSettingsAndTeamGeneration = true
        self.showingSettingsSheet = false
        if !self.league.isCommissionerMode && self.league.teams.isEmpty {
             statusMessage = "No teams generated. Check settings."; showingStatusAlert = true
        }
    }

    // CORRECTED teamsSection
    func teamsSection(teams: [Team]) -> some View {
         Section(header: Text(teams.isEmpty ? "No Teams Generated Yet" : "Teams (\(teams.count))")) {
            if teams.isEmpty {
                Text("Configure league settings to generate teams.").foregroundColor(.gray).padding(.vertical)
            } else {
                // Corrected ForEach: Iterates directly over the 'teams' array.
                // 'Team' conforms to Identifiable, so no 'id:' parameter is needed for ForEach.
                ForEach(teams) { team in
                    HStack {
                        TeamRowView(team: team)
                        Spacer()
                        // Logic for showing checkmark or edit button
                        if !league.isCommissionerMode && league.userTeamId == team.id {
                            Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                        }
                        // Edit button now uses selectedTeamForEditing
                        Button {
                            self.selectedTeamForEditing = team
                            print("Editing team: \(team.name)")
                        } label: {
                            Image(systemName: "pencil.circle")
                        }
                        .buttonStyle(.borderless)
                    }
                    // The .onTapGesture for direct row selection was removed in the previous step
                    // as selection is now meant to happen via TeamEditorView's callback.
                    // If you want direct row tap selection, that logic would be re-added here.
                }
            }
        }
    }

    func binding(for team: Team) -> Binding<Team> {
        guard let index = league.teams.firstIndex(where: { $0.id == team.id }) else { fatalError("Team not found.") }
        return $league.teams[index]
    }
    func saveLeagueToDefaultSlotAndProceed() {
        if !league.isCommissionerMode && league.userTeamId == nil && !league.teams.isEmpty {
            self.statusMessage = "Please select your team via the edit (✏️) icon."; self.showingStatusAlert = true; return
        }
        if self.league.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { self.league.name = "My Sim League" }
        let leagueToSave = self.league
        let targetSlotId = findTargetSlotForNewLeague()
        guard let chosenSlot = self.saveSlots.first(where: { $0.id == targetSlotId }) else {
            self.statusMessage = "Error: Could not find valid save slot."; self.showingStatusAlert = true; return
        }
        print("Saving league '\(leagueToSave.name)' to slot \(chosenSlot.id + 1)")
        LocalFileHelper.saveCodable(leagueToSave, to: chosenSlot.leagueFileName) { success in
            if success {
                if let logo = self.leagueLogo {
                    LocalFileHelper.saveImage(logo, fileName: chosenSlot.logoFileName) { _ in
                        self.updateMetadataAndNavigate(slotId: chosenSlot.id, leagueToSave: leagueToSave)
                    }
                } else { self.updateMetadataAndNavigate(slotId: chosenSlot.id, leagueToSave: leagueToSave) }
            } else { self.statusMessage = "Failed to save league data."; self.showingStatusAlert = true }
        }
    }
    func findTargetSlotForNewLeague() -> Int {
        if let emptySlot = saveSlots.first(where: { $0.isEmpty }) { return emptySlot.id }
        return defaultSlotIdForNewLeague
    }
    func updateMetadataAndNavigate(slotId: Int, leagueToSave: League) {
        LocalFileHelper.updateSaveSlot(id: slotId, leagueName: leagueToSave.name, lastModified: Date()) { success in
            if success { self.onLeagueCreatedAndReadyToNavigate?(leagueToSave, self.leagueLogo, slotId) }
            else { self.statusMessage = "Saved data, but metadata update failed."; self.showingStatusAlert = true }
        }
    }

    func generateDefaultNFLTeams(numberOfConferences: Int, divisionsPerConference: Int, teamsPerDivision: Int) -> [Team] {
        let rawTeamData: [(String, String, String)] = [
            ("Arizona", "Inferno", "#97233F"), ("Atlanta", "Aviators", "#A71930"),
            ("Charlotte", "Prowlers", "#0085CA"), ("Chicago", "Bruisers", "#0B162A"),
            ("Dallas", "Stars", "#002244"), ("Detroit", "Automata", "#0076B6"),
            ("Green Bay", "Voyageurs", "#203731"), ("Los Angeles", "Stags", "#003594"),
            ("Minnesota", "Norsemen", "#4F2683"), ("New Orleans", "Revelers", "#D3BC8D"),
            ("New York", "Goliaths", "#0B2265"), ("Philadelphia", "Freedom", "#004C54"),
            ("San Francisco", "Prospectors", "#AA0000"), ("Seattle", "Cascades", "#002244"),
            ("Tampa Bay", "Cannons", "#D50A0A"), ("Washington", "Capitals", "#5A1414"),
            ("Baltimore", "Nightwings", "#241773"), ("Buffalo", "Stallions", "#00338D"),
            ("Cincinnati", "Stripes", "#FB4F14"), ("Cleveland", "Rockers", "#311D00"),
            ("Denver", "Peaks", "#FB4F14"), ("Houston", "Comets", "#03202F"),
            ("Indianapolis", "Racers", "#002C5F"), ("Jacksonville", "Current", "#006778"),
            ("Kansas City", "Scouts", "#E31837"), ("Las Vegas", "Aces", "#A5ACAF"),
            ("Los Angeles", "Thunderbolts", "#0080C6"),("Miami", "Tides", "#008E97"),
            ("New England", "Minutemen", "#002244"), ("New York", "Knights", "#125740"),
            ("Pittsburgh", "Forgers", "#101820"), ("Tennessee", "Rhythm", "#0C2340")
        ]
        var teams: [Team] = []
        var teamCounter = 0
        let expectedTotalTeams = numberOfConferences * divisionsPerConference * teamsPerDivision
        guard rawTeamData.count >= expectedTotalTeams else {
            print("CRITICAL ERROR: Not enough raw team data for structure."); return []
        }
        for confIdx in 0..<numberOfConferences {
            for divIdx in 0..<divisionsPerConference {
                for _ in 0..<teamsPerDivision {
                    let data = rawTeamData[teamCounter]
                    teams.append(Team(id: UUID(), name: data.1, location: data.0,
                                      players: generatePlayers(), colorHex: data.2,
                                      conferenceId: confIdx, divisionId: divIdx))
                    teamCounter += 1
                }
            }
        }
        return teams
    }

    func generatePlaceholderTeams(numberOfConferences: Int, divisionsPerConference: Int, teamsPerDivision: Int) -> [Team] {
        var placeholderTeams: [Team] = []
        var teamNumber = 1
        for confIdx in 0..<numberOfConferences {
            for divIdx in 0..<divisionsPerConference {
                for _ in 0..<teamsPerDivision {
                    placeholderTeams.append(
                        Team(id: UUID(), name: "Custom Team \(teamNumber)", location: "City \(teamNumber)",
                             players: generatePlayers(),
                             colorHex: String(format: "#%02X%02X%02X", Int.random(in:0...255), Int.random(in:0...255), Int.random(in:0...255)),
                             conferenceId: confIdx, divisionId: divIdx)
                    )
                    teamNumber += 1
                }
            }
        }
        return placeholderTeams
    }
    func generatePlayers() -> [Player] {
        var P: [Player] = []; let pos = ["QB","RB","WR","TE","OL","DL","LB","CB","S","K","P"]; let fn = ["Alex","Chris","Jordan","Taylor","Morgan","Jamie","Casey","Drew","Blake","Cameron"]; let ln = ["Smith","Johnson","Williams","Brown","Jones","Miller","Davis","Wilson","Moore","Taylor"]
        for _ in 1...53 { let pot = Int.random(in:50...99); P.append(Player(id:UUID(),name:"\(fn.randomElement()!) \(ln.randomElement()!)",position:pos.randomElement()!,overall:Int.random(in:50...pot),age:Int.random(in:20...35),potential:pot))}
        return P
    }
}
 
struct TeamRowView: View {
    let team: Team
    var body: some View { VStack(alignment: .leading) { Text("\(team.location) \(team.name)").font(.headline).foregroundColor(team.color) } }
}
