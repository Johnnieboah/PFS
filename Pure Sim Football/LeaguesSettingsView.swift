import SwiftUI
import UIKit

struct LeagueSettingsView: View {
    // Bindings
    @Binding var useDefaultTeams: Bool
    @Binding var leagueName: String
    @Binding var leagueLogo: UIImage?
    @Binding var isCommissionerMode: Bool
    
    // League Structure - with defined min/max ranges
    @Binding var numberOfConferences: Int
    @Binding var numberOfDivisions: Int
    @Binding var teamsPerDivision: Int
    @Binding var gamesPerSeason: Int

    // Playoff Settings
    @Binding var maxPlayoffTeamsPerConference: Int
    @Binding var wildcardRoundByes: Int
    @Binding var divisionWinnersTopSeeds: Bool
    @Binding var bracketReseedAfterRoundOne: Bool

    var onDone: () -> Void

    // Local state for UI
    @State private var localLeagueName: String = ""
    @State private var showingImagePicker = false
    @FocusState private var isLeagueNameFieldFocused: Bool

    // Constants for ranges (can be defined elsewhere if preferred, e.g., a Config struct)
    let minConferences = 1
    let maxConferences = 4 // Allowing up to 4 conferences

    let minDivisionsPerConference = 1
    let maxDivisionsPerConference = 8 // Max 8 divisions in a conference

    let minTeamsPerDivision = 2
    let maxTeamsPerDivision = 8  // Max 8 teams in a division

    let minGamesPerSeason = 4   // Minimum games for a meaningful season
    let maxGamesPerSeason = 24  // Max games (e.g., about half a year if weekly)

    let minPlayoffTeamsPerConference = 2 // Must have at least 2 for a playoff

    // Available options for wildcard byes
    let wildcardByesOptions = [0, 1, 2, 4]

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Game Mode")) {
                    Toggle("Commissioner Mode (Control All Teams)", isOn: $isCommissionerMode)
                    Text(isCommissionerMode ? "You will manage all teams." : "You will choose one team to control.")
                        .font(.caption).foregroundColor(.gray)
                }

                Section(header: Text("League Identity")) {
                    TextField("League Name", text: $localLeagueName)
                        .focused($isLeagueNameFieldFocused)
                        .onSubmit { isLeagueNameFieldFocused = false }
                        .onChange(of: isLeagueNameFieldFocused) { newFocusState in
                            if !newFocusState { leagueName = localLeagueName }
                        }
                    
                    HStack {
                        Text("League Logo")
                        Spacer()
                        if let logo = leagueLogo {
                            Image(uiImage: logo).resizable().scaledToFit().frame(width: 40, height: 40).clipShape(RoundedRectangle(cornerRadius: 5))
                        } else {
                            Image(systemName: "photo.on.rectangle.angled").resizable().scaledToFit().frame(width: 40, height: 40).foregroundColor(.gray)
                        }
                        Button(leagueLogo == nil ? "Add Logo" : "Change Logo") { showingImagePicker = true }.buttonStyle(.borderless)
                    }
                }

                Section(header: Text("Team Source")) {
                    Toggle("Use Default NFL-Style Teams", isOn: $useDefaultTeams)
                        .onChange(of: useDefaultTeams) { newValue in
                            if newValue { // If switching to default teams
                                // Reset structure to NFL defaults (2 conf, 4 div/conf, 4 teams/div = 32 total)
                                numberOfConferences = 2
                                numberOfDivisions = 4
                                teamsPerDivision = 4
                                // gamesPerSeason = 17 // Optionally reset this too
                            }
                        }
                }
                
                // Disable structure editing if using default teams, as structure is fixed for them (32 teams)
                Section(header: Text("League Structure")) {
                    Stepper(value: $numberOfConferences, in: minConferences...maxConferences) {
                        Text("Conferences: \(numberOfConferences)")
                    }
                    .disabled(useDefaultTeams) // Disable if using default teams

                    Stepper(value: $numberOfDivisions, in: minDivisionsPerConference...maxDivisionsPerConference) {
                        Text("Divisions per Conference: \(numberOfDivisions)")
                    }
                    .disabled(useDefaultTeams)

                    Stepper(value: $teamsPerDivision, in: minTeamsPerDivision...maxTeamsPerDivision) {
                        Text("Teams per Division: \(teamsPerDivision)")
                    }
                    .disabled(useDefaultTeams)
                    
                    // Display total teams and make it clear if it's fixed by default teams
                    if useDefaultTeams {
                        Text("Total Teams: 32 (Fixed for Default NFL-Style)")
                            .font(.caption).foregroundColor(.gray)
                    } else {
                        Text("Total Teams: \(totalTeamsInLeague)")
                            .font(.caption).foregroundColor(.gray)
                    }

                    Stepper(value: $gamesPerSeason, in: minGamesPerSeason...maxGamesPerSeason) {
                        Text("Games per Regular Season: \(gamesPerSeason)")
                    }
                }
                .onChange(of: [numberOfConferences, numberOfDivisions, teamsPerDivision].description) { _ in
                    // Re-validate playoff teams and byes if league structure changes
                    validateAndUpdateMaxPlayoffTeams()
                    validateAndUpdateWildcardByes()
                }


                Section(header: Text("Playoff Settings")) {
                    Stepper(value: $maxPlayoffTeamsPerConference, in: minPlayoffTeamsPerConference...maxPossiblePlayoffTeamsPerConference) {
                        Text("Playoff Teams per Conf: \(maxPlayoffTeamsPerConference)")
                    }
                    .onChange(of: maxPlayoffTeamsPerConference) { _ in
                         // When max playoff teams changes, re-validate byes
                        validateAndUpdateWildcardByes()
                    }


                    VStack(alignment: .leading) {
                        Text("Wildcard Round Byes per Conf:").font(.subheadline)
                        Picker("Wildcard Round Byes", selection: $wildcardRoundByes) {
                            ForEach(validWildcardByesOptions, id: \.self) { value in
                                Text("\(value) Bye\(value == 1 ? "" : "s")").tag(value)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        // onChange for maxPlayoffTeamsPerConference already handles revalidating byes
                        Text("Note: Total byes cannot exceed (Playoff Teams / 2) - 1, and must leave at least 2 teams playing.")
                            .font(.caption2).foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                    Toggle("Division Winners are Top Seeds", isOn: $divisionWinnersTopSeeds)
                    Toggle("Reseed Bracket After Wildcard", isOn: $bracketReseedAfterRoundOne)
                }
            }
            
            Button(action: {
                if isLeagueNameFieldFocused { isLeagueNameFieldFocused = false }
                leagueName = localLeagueName
                // Before calling onDone, ensure structural integrity if using default teams
                if useDefaultTeams {
                    numberOfConferences = 2
                    numberOfDivisions = 4
                    teamsPerDivision = 4
                }
                print("Continue button tapped. Final leagueName: '\(leagueName)', Total Teams: \(totalTeamsInLeague)")
                onDone()
            }) {
                Text("Confirm Settings") // Changed button text
                    .font(.headline).frame(maxWidth: .infinity).padding()
                    .background(Color.accentColor).foregroundColor(.white).cornerRadius(10)
            }
            .padding()

        }
        .onAppear {
            localLeagueName = leagueName
            print("LeagueSettingsView appeared. Initial localLeagueName: '\(localLeagueName)', totalTeams: \(totalTeamsInLeague)")
            // Initial validation based on current values
            validateAndUpdateMaxPlayoffTeams() // Important for initial setup
            validateAndUpdateWildcardByes()
        }
        .sheet(isPresented: $showingImagePicker) {
            LeagueImagePicker(image: $leagueLogo)
        }
    }
    
    // Computed properties for dynamic calculations
    var teamsPerConference: Int {
        useDefaultTeams ? 16 : (numberOfDivisions * teamsPerDivision)
    }

    var totalTeamsInLeague: Int {
        useDefaultTeams ? 32 : (numberOfConferences * numberOfDivisions * teamsPerDivision)
    }
        
    var maxPossiblePlayoffTeamsPerConference: Int {
        // Playoff teams cannot exceed total teams in that conference
        // And must be an even number for typical bracket progression if byes are involved, or at least 2.
        let teamsInConf = useDefaultTeams ? 16 : (numberOfDivisions * teamsPerDivision)
        return max(minPlayoffTeamsPerConference, teamsInConf) // Can be up to all teams in conf, min 2
    }

    var validWildcardByesOptions: [Int] {
        wildcardByesOptions.filter { byeOption in
            // Number of teams actually playing in wildcard round if these byes are taken
            let teamsPlayingAfterByes = maxPlayoffTeamsPerConference - byeOption
            // Byes should be less than half the playoff teams to ensure some games
            // And at least 2 teams must be playing if byes are present.
            // If 2 playoff teams, 0 byes. If 3 playoff teams, max 1 bye (leaves 2 playing).
            // If 4 playoff teams, max 1 bye (leaves 3 playing, or 2 if 1 bye per side in a larger bracket concept)
            // The logic here is for byes *per conference*
            // A simpler rule: total byes must be less than total playoff teams, and usually byes are for top seeds.
            // Max byes = (PlayoffTeams / 2) -1 if we want at least one wildcard game.
            // Or, more simply, byes shouldn't leave less than 2 teams to play.
            return byeOption < maxPlayoffTeamsPerConference && (maxPlayoffTeamsPerConference - byeOption >= 2)
        }
    }

    // Function to validate and update dependent settings
    private func validateAndUpdateMaxPlayoffTeams() {
        if maxPlayoffTeamsPerConference > maxPossiblePlayoffTeamsPerConference {
            maxPlayoffTeamsPerConference = maxPossiblePlayoffTeamsPerConference
        }
        if maxPlayoffTeamsPerConference < minPlayoffTeamsPerConference {
            maxPlayoffTeamsPerConference = minPlayoffTeamsPerConference
        }
    }
    
    private func validateAndUpdateWildcardByes() {
        if !validWildcardByesOptions.contains(wildcardRoundByes) {
            wildcardRoundByes = validWildcardByesOptions.first ?? 0 // Default to 0 byes if current is invalid
        }
    }
}
