// NewLeagueView.swift

import SwiftUI
import UIKit

struct NewLeagueView: View {
    @State private var league: League = League(id: UUID(), name: "", teams: [], isCommissionerMode: false, userTeamId: nil, schedule: [], gamesPerSeason: 17, currentSeasonYear: 2025, numberOfConferences: 2, divisionsPerConference: 4)
    
    @State private var leagueLogo: UIImage? = nil
    @State private var selectedTeamForEditing: Team? = nil
    @State private var showingSettingsSheet = false
    
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
    
    @State private var hasCompletedInitialSettings = false

    @State private var saveSlots: [SaveSlot] = []
    private let defaultSlotIdForNewLeague = 0

    @State private var showingStatusAlert = false
    @State private var statusMessage = ""

    var onLeagueCreatedAndReadyToNavigate: ((_ newLeague: League, _ newLogo: UIImage?, _ savedToSlotId: Int) -> Void)?
    @Environment(\.dismiss) var dismissNewLeagueView

    private func presentSettingsSheet() {
        print("NewLeagueView: presentSettingsSheet called. Initializing temp vars for settings sub-sheet.")
        tempLeagueName = league.name.isEmpty ? "My Sim League" : league.name
        tempIsCommissionerMode = league.isCommissionerMode
        tempUseDefaultTeams = true
        
        tempNumberOfConferences = 2
        tempNumberOfDivisions = 4
        tempTeamsPerDivision = 4
        tempGamesPerSeason = 17
        
        tempMaxPlayoffTeamsPerConference = 7
        tempWildcardRoundByes = 1
        tempDivisionWinnersTopSeeds = true
        tempBracketReseedAfterRoundOne = false
        
        showingSettingsSheet = true
    }

    var body: some View {
        NavigationView {
            VStack {
                 // let _ = print("NewLeagueView BODY re-eval. League Name: '\(league.name)', Teams: \(league.teams.count), Commish: \(league.isCommissionerMode), UserTeam: \(league.userTeamId?.uuidString ?? "nil"), CompletedSettings: \(hasCompletedInitialSettings), League ID: \(league.id)")
                if !hasCompletedInitialSettings {
                    initialSettingsPromptView
                } else if !league.isCommissionerMode && league.userTeamId == nil && !league.teams.isEmpty { // This is teamSelectionView
                    teamSelectionView
                } else {  // This is reviewAndSaveView (Commissioner mode, or Player mode with team selected)
                    reviewAndSaveView
                }
            }
            .navigationTitle(league.name.isEmpty ? "New League Setup" : league.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismissNewLeagueView() }
                }
            }
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
                 TeamEditorView( // This is the sheet that needs the fix for team selection
                    team: binding(for: teamToEdit),
                    onTeamSelectedAsUserTeam: { selectedTeamID in
                        self.league.userTeamId = selectedTeamID
                        print("NewLeagueView: User team ID set in @State league to: \(selectedTeamID) for league ID \(self.league.id)")
                        self.selectedTeamForEditing = nil // This dismisses TeamEditorView
                    },
                    isBeingUsedForInitialSelection: !self.league.isCommissionerMode && self.league.userTeamId == nil
                 )
            }
            .onAppear {
                print("NewLeagueView: .onAppear. League ID: \(league.id) (Should be new ID if re-presented). Teams: \(league.teams.count). hasCompletedInitialSettings: \(hasCompletedInitialSettings)")
                LocalFileHelper.loadAndInitializeSaveSlots { loadedSlots in self.saveSlots = loadedSlots }
                
                if !hasCompletedInitialSettings {
                    presentSettingsSheet()
                }
            }
            .alert("Status", isPresented: $showingStatusAlert) { Button("OK"){} } message: { Text(statusMessage) }
        }
    }
    
    var initialSettingsPromptView: some View {
        VStack {
            Spacer()
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
                .padding(.bottom)
            Text("Welcome to Pure Sim Football!").font(.title2.bold()).padding(.bottom, 5)
            Text("Let's set up your new football dynasty. First, configure the basic league settings.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 30)
                .padding(.bottom)
            Button {
                presentSettingsSheet()
            } label: {
                Label("Configure League Settings", systemImage: "gearshape.fill")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            Spacer()
        }
    }

    var teamSelectionView: some View {
        VStack {
            Text("League Settings Applied!").font(.title2).padding(.top)
            Text("You're in Player Mode. Please select your team from the list below.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding([.horizontal, .bottom])

            List { teamsSection(teams: league.teams) }
            
            Button {
                print("NewLeagueView: 'Confirm Team & Start League' (teamSelectionView) button tapped.")
                saveLeagueToDefaultSlotAndProceed()
            } label: {
                Label("Confirm Team & Start League", systemImage: "arrow.right.circle.fill")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(league.userTeamId == nil) // This should now become enabled after correct team selection
            .padding()
        }
    }

    var reviewAndSaveView: some View {
        VStack {
            if league.isCommissionerMode {
                Text("Commissioner Mode").font(.title2.bold()).foregroundColor(.orange).padding(.top)
                Text("All teams are under your control. Review the generated teams and save to begin.")
                    .font(.subheadline).foregroundColor(.gray).multilineTextAlignment(.center).padding([.horizontal, .bottom])
            } else if let teamId = league.userTeamId, let team = league.teams.first(where: {$0.id == teamId}) {
                Text("Your Team: \(team.location) \(team.name)").font(.title2.bold()).foregroundColor(.blue).padding(.top)
                Text("Review the league structure and your team. Save to begin your career!")
                    .font(.subheadline).foregroundColor(.gray).multilineTextAlignment(.center).padding([.horizontal, .bottom])
            } else if !league.teams.isEmpty {
                 Text("Review Generated Teams").font(.title2.bold()).padding(.top)
                 Text("Please select your team from the list, then save to start.")
                    .font(.subheadline).foregroundColor(.gray).multilineTextAlignment(.center).padding([.horizontal, .bottom])
            } else {
                 Text("Team Generation Needed").font(.title2.bold()).padding(.top)
                 Text("Please (re)configure league settings to generate teams.")
                    .font(.subheadline).foregroundColor(.gray).multilineTextAlignment(.center).padding([.horizontal, .bottom])
                 Button("Re-Configure Settings") { presentSettingsSheet() }
                    .buttonStyle(.bordered)
                    .padding()
            }
            
            List { teamsSection(teams: league.teams) }
            
            if !league.teams.isEmpty {
                Button {
                    print("NewLeagueView: 'Save/Start League' (reviewAndSaveView) button tapped.")
                    saveLeagueToDefaultSlotAndProceed()
                } label: {
                    Label(league.isCommissionerMode || league.userTeamId != nil ? "Save & Start League" : "Select Your Team First", systemImage: "play.circle.fill")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!league.isCommissionerMode && league.userTeamId == nil && !league.teams.isEmpty)
                .padding()
            }
        }
    }

    func handleSettingsDone() {
        print("NewLeagueView: handleSettingsDone called from LeagueSettingsView.")
        
        var configuredLeague = League(
            id: UUID(),
            name: self.tempLeagueName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "My Sim League" : self.tempLeagueName.trimmingCharacters(in: .whitespacesAndNewlines),
            teams: [],
            isCommissionerMode: self.tempIsCommissionerMode,
            userTeamId: nil,
            schedule: [],
            gamesPerSeason: self.tempGamesPerSeason,
            currentSeasonYear: 2025,
            numberOfConferences: self.tempUseDefaultTeams ? 2 : self.tempNumberOfConferences,
            divisionsPerConference: self.tempUseDefaultTeams ? 4 : self.tempNumberOfDivisions
        )
        
        let teamsPerDivToUse = self.tempUseDefaultTeams ? 4 : self.tempTeamsPerDivision

        print("NewLeagueView: Generating teams for 'configuredLeague' (NEW ID: \(configuredLeague.id)) with: useDefault=\(tempUseDefaultTeams), name='\(configuredLeague.name)', commish=\(configuredLeague.isCommissionerMode), teams/div=\(teamsPerDivToUse)")

        if self.tempUseDefaultTeams {
            configuredLeague.teams = generateDefaultNFLTeams(
                numberOfConferences: configuredLeague.numberOfConferences,
                divisionsPerConference: configuredLeague.divisionsPerConference,
                teamsPerDivision: teamsPerDivToUse
            )
        } else {
            configuredLeague.teams = generatePlaceholderTeams(
                numberOfConferences: configuredLeague.numberOfConferences,
                divisionsPerConference: configuredLeague.divisionsPerConference,
                teamsPerDivision: teamsPerDivToUse
            )
        }
        print("NewLeagueView: For 'configuredLeague' (ID: \(configuredLeague.id)), generated \(configuredLeague.teams.count) teams.")

        if configuredLeague.teams.isEmpty {
            let errorMsg = self.tempUseDefaultTeams ? "Failed to generate default NFL teams. Check static data in NewLeagueView." : "Failed to generate custom teams. Check structure settings."
            print("NewLeagueView: ERROR - \(errorMsg)")
            statusMessage = errorMsg
            showingStatusAlert = true
            return
        }

        self.league = configuredLeague
        
        print("NewLeagueView: @State self.league ASSIGNED. Name: '\(self.league.name)', Teams: \(self.league.teams.count), Commish: \(self.league.isCommissionerMode), ID: \(self.league.id)")
        
        self.hasCompletedInitialSettings = true
        self.showingSettingsSheet = false
    }

    func teamsSection(teams: [Team]) -> some View {
         Section(header: Text(teams.isEmpty ? "No Teams Generated Yet" : "Teams (\(teams.count))")) {
            if teams.isEmpty {
                Text("Teams will appear here after configuring league settings.").foregroundColor(.gray).padding(.vertical)
            } else {
                ForEach(teams) { team in
                    HStack {
                        TeamRowView(team: team)
                        Spacer()
                        if !league.isCommissionerMode && league.userTeamId == team.id {
                            Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                                .accessibilityLabel("Selected Team: \(team.name)")
                        }
                        Button {
                            print("NewLeagueView: Edit button tapped for team: \(team.name) (ID: \(team.id)) from league \(self.league.id)")
                            self.selectedTeamForEditing = team
                        } label: { Image(systemName: "pencil.circle").imageScale(.large) }
                        .buttonStyle(.borderless)
                        .accessibilityLabel("Edit team \(team.name)")
                    }
                }
            }
        }
    }

    func binding(for team: Team) -> Binding<Team> {
        guard let index = league.teams.firstIndex(where: { $0.id == team.id }) else {
            print("NewLeagueView: FATAL ERROR - Team with ID \(team.id) ('\(team.name)') not found in @State league.teams for binding. Current @State league ID: \(self.league.id). Team count: \(self.league.teams.count)")
            fatalError("Team not found for binding. Inconsistent state.")
        }
        return $league.teams[index]
    }
    
    func saveLeagueToDefaultSlotAndProceed() {
        print("NewLeagueView: saveLeagueToDefaultSlotAndProceed called. Current @State league - Name: '\(league.name)', Teams: \(league.teams.count), Commish: \(league.isCommissionerMode), UserTeamID: \(league.userTeamId?.uuidString ?? "nil"), League ID: \(league.id)")
        
        if league.teams.isEmpty {
            statusMessage = "Cannot save: No teams have been generated for the league."
            showingStatusAlert = true
            print("NewLeagueView: Save PREVENTED - no teams in self.league.")
            return
        }
        
        print("NewLeagueView: Checking Player Mode conditions: isCommissionerMode=\(league.isCommissionerMode), userTeamId=\(league.userTeamId?.uuidString ?? "nil")")
        if !league.isCommissionerMode && league.userTeamId == nil {
            statusMessage = "Please select your team before starting the league. Tap a team's edit (✏️) icon, then 'Select this Team' from the editor."
            showingStatusAlert = true
            print("NewLeagueView: Save PREVENTED - Player mode but no userTeamId in self.league.")
            return
        }
        
        print("NewLeagueView: Save conditions met. Proceeding with save.")
        var leagueToSave = self.league
        if leagueToSave.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            leagueToSave.name = "My Sim League"
        }

        if leagueToSave.schedule.isEmpty {
            print("NewLeagueView: Generating schedule for league '\(leagueToSave.name)' (ID: \(leagueToSave.id)) before final save...")
            let isLikelyDefaultStructure = leagueToSave.numberOfConferences == 2 && leagueToSave.divisionsPerConference == 4 && leagueToSave.teams.count == 32
            let intentWasDefault = self.tempUseDefaultTeams
            let useDefaultTeamsForSchedule = isLikelyDefaultStructure || intentWasDefault

            print("NewLeagueView: Schedule generation using useDefaultTeamsForSchedule: \(useDefaultTeamsForSchedule) (isLikelyDefault: \(isLikelyDefaultStructure), intentWasDefault: \(intentWasDefault))")

            leagueToSave.schedule = SimulationEngine.generateSchedule(
                for: leagueToSave.teams,
                gamesToPlayPerTeamTarget: leagueToSave.gamesPerSeason,
                isFirstSeason: true,
                isUsingDefaultTeams: useDefaultTeamsForSchedule,
                leagueStructure: (conferences: leagueToSave.numberOfConferences, divisionsPerConference: leagueToSave.divisionsPerConference)
            )
            self.league.schedule = leagueToSave.schedule
            print("NewLeagueView: Schedule generated with \(leagueToSave.schedule.count) games.")
            if leagueToSave.schedule.isEmpty && !leagueToSave.teams.isEmpty {
                statusMessage = "Warning: Failed to generate a schedule. The league will be saved without one. Check SimulationEngine logic."
                showingStatusAlert = true
                print("NewLeagueView: Schedule generation resulted in empty schedule.")
            }
        }
        
        let targetSlotId = findTargetSlotForNewLeague()
        guard let chosenSlot = self.saveSlots.first(where: { $0.id == targetSlotId }) else {
            statusMessage = "Error: Could not find a valid save slot for ID \(targetSlotId).";
            showingStatusAlert = true
            print("NewLeagueView: Save failed - no valid save slot found.")
            return
        }
        
        print("NewLeagueView: Saving league '\(leagueToSave.name)' (ID: \(leagueToSave.id)) to slot \(chosenSlot.id + 1) (File Slot ID: \(chosenSlot.id))")
        
        LocalFileHelper.saveCodable(leagueToSave, to: chosenSlot.leagueFileName) { success in
            if success {
                print("NewLeagueView: League data saved successfully to \(chosenSlot.leagueFileName).")
                if let logo = self.leagueLogo {
                    LocalFileHelper.saveImage(logo, fileName: chosenSlot.logoFileName) { imageSaveSuccess in
                        if !imageSaveSuccess { print("NewLeagueView: Warning - Failed to save league logo to \(chosenSlot.logoFileName).") }
                        self.updateMetadataAndNavigate(slotId: chosenSlot.id, leagueToSave: leagueToSave)
                    }
                } else {
                    self.updateMetadataAndNavigate(slotId: chosenSlot.id, leagueToSave: leagueToSave)
                }
            } else {
                statusMessage = "Failed to save league data to slot \(chosenSlot.id + 1).";
                showingStatusAlert = true
                print("NewLeagueView: Save failed - LocalFileHelper.saveCodable returned false for \(chosenSlot.leagueFileName).")
            }
        }
    }
    
    func findTargetSlotForNewLeague() -> Int {
        if let emptySlot = saveSlots.first(where: { $0.isEmpty }) {
            print("NewLeagueView: Found empty save slot: ID \(emptySlot.id)")
            return emptySlot.id
        }
        print("NewLeagueView: No empty slots found. Using default slot ID: \(defaultSlotIdForNewLeague)")
        return defaultSlotIdForNewLeague
    }

    func updateMetadataAndNavigate(slotId: Int, leagueToSave: League) {
        LocalFileHelper.updateSaveSlot(id: slotId, leagueName: leagueToSave.name, lastModified: Date()) { metaSuccess in
            if metaSuccess {
                print("NewLeagueView: Meta updated for slot ID \(slotId). Calling onLeagueCreatedAndReadyToNavigate.")
                print("NewLeagueView: League being passed to DynastyHub: Name: '\(leagueToSave.name)', UserTeamID: \(leagueToSave.userTeamId?.uuidString ?? "nil"), Team Count: \(leagueToSave.teams.count), Schedule Count: \(leagueToSave.schedule.count), League ID: \(leagueToSave.id)")
                self.onLeagueCreatedAndReadyToNavigate?(leagueToSave, self.leagueLogo, slotId)
            } else {
                statusMessage = "League data saved to slot \(slotId + 1), but failed to update save slot metadata."
                showingStatusAlert = true
                print("NewLeagueView: Metadata update failed for slot ID \(slotId). Navigating anyway.")
                self.onLeagueCreatedAndReadyToNavigate?(leagueToSave, self.leagueLogo, slotId)
            }
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
            print("NewLeagueView: CRITICAL ERROR in generateDefaultNFLTeams - Not enough raw team data (\(rawTeamData.count)) for expected \(expectedTotalTeams) teams.")
            return []
        }
        
        for confIdx in 0..<numberOfConferences {
            for divIdx in 0..<divisionsPerConference {
                for _ in 0..<teamsPerDivision {
                    if teamCounter < rawTeamData.count {
                        let data = rawTeamData[teamCounter]
                        teams.append(Team(id: UUID(), name: data.1, location: data.0,
                                          players: generateStandardPlayers(), colorHex: data.2,
                                          conferenceId: confIdx, divisionId: divIdx))
                        teamCounter += 1
                    } else { break }
                }
                if teamCounter >= expectedTotalTeams { break }
            }
            if teamCounter >= expectedTotalTeams { break }
        }
        print("NewLeagueView: Generated \(teams.count) default teams successfully.")
        return teams
    }

    func generatePlaceholderTeams(numberOfConferences: Int, divisionsPerConference: Int, teamsPerDivision: Int) -> [Team] {
        var placeholderTeams: [Team] = []
        var teamNumber = 1
        print("NewLeagueView: Generating \(numberOfConferences * divisionsPerConference * teamsPerDivision) placeholder teams.")
        guard numberOfConferences > 0, divisionsPerConference > 0, teamsPerDivision >= 2 else {
            print("NewLeagueView: Invalid custom league structure. Confs: \(numberOfConferences), Divs/Conf: \(divisionsPerConference), Teams/Div: \(teamsPerDivision)")
            return []
        }
        for confIdx in 0..<numberOfConferences {
            for divIdx in 0..<divisionsPerConference {
                for _ in 0..<teamsPerDivision {
                    placeholderTeams.append(
                        Team(id: UUID(), name: "Team \(teamNumber)", location: "City \(teamNumber)",
                             players: generateStandardPlayers(),
                             colorHex: String(format: "#%02X%02X%02X", Int.random(in:0...255), Int.random(in:0...255), Int.random(in:0...255)),
                             conferenceId: confIdx, divisionId: divIdx)
                    )
                    teamNumber += 1
                }
            }
        }
        print("NewLeagueView: Generated \(placeholderTeams.count) placeholder teams successfully.")
        return placeholderTeams
    }

    func generateStandardPlayers(count: Int = 53) -> [Player] {
        var players: [Player] = []
        let firstNames = ["Alex","Chris","Jordan","Taylor","Morgan","Jamie","Casey","Drew","Blake","Cameron","Riley","Jesse","Dakota","Skyler","Hayden", "Pat", "Sam", "Terry", "Devon"]
        let lastNames = ["Smith","Johnson","Williams","Brown","Jones","Miller","Davis","Garcia","Rodriguez","Wilson","Martinez","Anderson","Thomas","Hernandez","Moore","Martin","Jackson","Thompson","White","Lopez","Lee","Gonzalez","Harris","Clark","Lewis","Robinson","Walker","Perez","Hall","Young","Allen","Sanchez","Wright","King","Scott","Green","Baker","Adams","Nelson","Hill","Campbell","Mitchell","Roberts","Carter","Phillips","Evans","Turner","Torres"]
        
        let positions: [String: Int] = [
            "QB": 3, "RB": 4, "WR": 6, "TE": 3,
            "LT": 2, "LG": 2, "C": 2, "RG": 2, "RT": 2,
            "DE": 4, "DT": 4,
            "OLB": 4, "MLB": 3,
            "CB": 5, "FS": 2, "SS": 2,
            "K": 1, "P": 1, "LS": 1
        ]

        for (pos, num) in positions {
            for _ in 0..<num {
                let potential = Int.random(in: 55...99)
                let age = Int.random(in: 20...33)
                var overall = Int.random(in: max(40, potential - 25)...potential)
                if age > 28 && age <= 30 { overall = min(overall + Int.random(in: 0...5), potential) }
                else if age > 30 { overall = max(potential - 15 - (age - 30), 40) }
                
                players.append(Player(id:UUID(),
                                      name:"\(firstNames.randomElement()!) \(lastNames.randomElement()!)",
                                      position: pos,
                                      overall: overall,
                                      age: age,
                                      potential: potential))
            }
        }
        while players.count < count {
            let genericPos = ["WR", "CB", "LB", "OL", "DL"].randomElement()!
            let potential = Int.random(in: 50...85)
            players.append(Player(id:UUID(),name:"\(firstNames.randomElement()!) \(lastNames.randomElement()!)",position:genericPos,overall:Int.random(in:40...potential),age:Int.random(in:22...28),potential:potential))
        }
        
        return Array(players.prefix(count))
    }
}

struct TeamRowView: View {
    let team: Team
    var body: some View {
        HStack {
            Circle().fill(team.color).frame(width: 12, height: 12)
            VStack(alignment: .leading) {
                Text("\(team.location) \(team.name)")
                    .font(.headline)
                Text("Conf: \(team.conferenceId != nil ? String(team.conferenceId! + 1) : "N/A"), Div: \(team.divisionId != nil ? String(team.divisionId! + 1) : "N/A") | OVR: \(team.overallRating)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
