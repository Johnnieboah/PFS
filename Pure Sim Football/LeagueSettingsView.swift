// LeagueSettingsView.swift

import SwiftUI
import UIKit

struct LeagueSettingsView: View {
    // Bindings
    @Binding var useDefaultTeams: Bool
    @Binding var leagueName: String
    @Binding var leagueLogo: UIImage?
    @Binding var isCommissionerMode: Bool
    
    @Binding var numberOfConferences: Int
    @Binding var numberOfDivisions: Int // This is divisions PER CONFERENCE
    @Binding var teamsPerDivision: Int
    @Binding var gamesPerSeason: Int

    @Binding var maxPlayoffTeamsPerConference: Int
    @Binding var wildcardRoundByes: Int
    @Binding var divisionWinnersTopSeeds: Bool
    @Binding var bracketReseedAfterRoundOne: Bool

    var onDone: () -> Void

    @State private var localLeagueName: String // Initialize in onAppear
    @State private var showingImagePicker = false
    @FocusState private var isLeagueNameFieldFocused: Bool

    // Constants for ranges
    let minConferences = 1
    let maxConferences = 4
    let minDivisionsPerConference = 1
    let maxDivisionsPerConference = 8
    let minTeamsPerDivision = 2
    let maxTeamsPerDivision = 8
    let minGamesPerSeason = 1 // Allowing 1 for very short testing
    let maxGamesPerSeason = 34 // Expanded for more flexibility
    let minPlayoffTeamsPerConference = 2
    let wildcardByesOptions = [0, 1, 2, 4] // Ensure these are sensible

    init(
        useDefaultTeams: Binding<Bool>,
        leagueName: Binding<String>,
        leagueLogo: Binding<UIImage?>,
        isCommissionerMode: Binding<Bool>,
        numberOfConferences: Binding<Int>,
        numberOfDivisions: Binding<Int>,
        teamsPerDivision: Binding<Int>,
        gamesPerSeason: Binding<Int>,
        maxPlayoffTeamsPerConference: Binding<Int>,
        wildcardRoundByes: Binding<Int>,
        divisionWinnersTopSeeds: Binding<Bool>,
        bracketReseedAfterRoundOne: Binding<Bool>,
        onDone: @escaping () -> Void
    ) {
        self._useDefaultTeams = useDefaultTeams
        self._leagueName = leagueName
        self._leagueLogo = leagueLogo
        self._isCommissionerMode = isCommissionerMode
        self._numberOfConferences = numberOfConferences
        self._numberOfDivisions = numberOfDivisions
        self._teamsPerDivision = teamsPerDivision
        self._gamesPerSeason = gamesPerSeason
        self._maxPlayoffTeamsPerConference = maxPlayoffTeamsPerConference
        self._wildcardRoundByes = wildcardRoundByes
        self._divisionWinnersTopSeeds = divisionWinnersTopSeeds
        self._bracketReseedAfterRoundOne = bracketReseedAfterRoundOne
        self.onDone = onDone
        self._localLeagueName = State(initialValue: leagueName.wrappedValue)
    }

    var body: some View {
        // Sheets that contain forms and their own "Done" or "Confirm" actions
        // often benefit from their own NavigationView for a title bar.
        NavigationView {
            Form {
                Section(header: Text("Game Mode")) {
                    Toggle("Commissioner Mode (Control All Teams)", isOn: $isCommissionerMode)
                    Text(isCommissionerMode ? "You will manage all teams." : "You will choose one team to control.")
                        .font(.caption).foregroundColor(.gray)
                }

                Section(header: Text("League Identity")) {
                    TextField("League Name", text: $localLeagueName)
                        .focused($isLeagueNameFieldFocused)
                        .onSubmit {
                            leagueName = localLeagueName // Update binding on submit
                            isLeagueNameFieldFocused = false
                        }
                    // Consider updating leagueName onChange as well if preferred,
                    // but onSubmit or onDone is often sufficient.
                    
                    HStack {
                        Text("League Logo")
                        Spacer()
                        if let logo = leagueLogo {
                            Image(uiImage: logo).resizable().scaledToFit().frame(width: 40, height: 40).clipShape(RoundedRectangle(cornerRadius: 5))
                        } else {
                            Image(systemName: "photo.on.rectangle.angled").resizable().scaledToFit().frame(width: 40, height: 40).foregroundColor(.gray)
                        }
                        Button(leagueLogo == nil ? "Add Logo" : "Change Logo") { showingImagePicker = true }
                            .buttonStyle(.borderless) // Keep UI clean
                    }
                }

                Section(header: Text("Team Source")) {
                    Toggle("Use Default NFL-Style Teams", isOn: $useDefaultTeams)
                        .onChange(of: useDefaultTeams) { newValue in
                            if newValue {
                                numberOfConferences = 2
                                numberOfDivisions = 4 // per conference
                                teamsPerDivision = 4
                                // gamesPerSeason = 17 // Consider if this should also reset
                            }
                            // Ensure dependent settings are re-validated
                            validateAndUpdateMaxPlayoffTeams()
                            validateAndUpdateWildcardByes()
                        }
                }
                
                Section(header: Text("League Structure")) {
                    Stepper(value: $numberOfConferences, in: minConferences...maxConferences, step: 1) { // Added step
                        Text("Conferences: \(numberOfConferences)")
                    }.disabled(useDefaultTeams)

                    Stepper(value: $numberOfDivisions, in: minDivisionsPerConference...maxDivisionsPerConference, step: 1) {
                        Text("Divisions per Conference: \(numberOfDivisions)")
                    }.disabled(useDefaultTeams)

                    Stepper(value: $teamsPerDivision, in: minTeamsPerDivision...maxTeamsPerDivision, step: 1) {
                        Text("Teams per Division: \(teamsPerDivision)")
                    }.disabled(useDefaultTeams)
                    
                    Text(useDefaultTeams ? "Total Teams: 32 (Fixed)" : "Total Teams: \(totalTeamsInLeague)")
                        .font(.caption).foregroundColor(.gray)

                    Stepper(value: $gamesPerSeason, in: minGamesPerSeason...maxGamesPerSeason, step: 1) {
                        Text("Games per Regular Season: \(gamesPerSeason)")
                    }
                }
                .onChange(of: [numberOfConferences.description, numberOfDivisions.description, teamsPerDivision.description].joined()) { _ in // More robust onChange trigger
                    validateAndUpdateMaxPlayoffTeams()
                    validateAndUpdateWildcardByes()
                }

                Section(header: Text("Playoff Settings")) {
                    Stepper(value: $maxPlayoffTeamsPerConference, in: minPlayoffTeamsPerConference...maxPossiblePlayoffTeamsPerConference, step: 1) {
                        Text("Playoff Teams per Conf: \(maxPlayoffTeamsPerConference)")
                    }
                    .onChange(of: maxPlayoffTeamsPerConference) { _ in
                        validateAndUpdateWildcardByes()
                    }

                    VStack(alignment: .leading) {
                        Text("Wildcard Round Byes per Conf:").font(.subheadline) // Use .subheadline for consistency
                        Picker("Wildcard Round Byes", selection: $wildcardRoundByes) {
                            ForEach(validWildcardByesOptions, id: \.self) { value in
                                Text("\(value) Bye\(value == 1 ? "" : "s")").tag(value)
                            }
                        }
                        .pickerStyle(.segmented) // SegmentedPickerStyle is usually good here
                        Text("Byes require at least 2 teams playing in the wildcard round of that conference.")
                            .font(.caption2).foregroundColor(.gray)
                    }
                    .padding(.vertical, 5) // Add some padding

                    Toggle("Division Winners are Top Seeds", isOn: $divisionWinnersTopSeeds)
                    Toggle("Reseed Bracket After Wildcard", isOn: $bracketReseedAfterRoundOne)
                }
            }
            .navigationTitle("League Settings")
            .navigationBarTitleDisplayMode(.inline) // Common for sheets
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm") { // "Confirm" or "Done"
                        if isLeagueNameFieldFocused { isLeagueNameFieldFocused = false } // Dismiss focus
                        leagueName = localLeagueName // Ensure leagueName is updated from local state
                        
                        if useDefaultTeams { // Ensure structure is NFL default if toggled
                            numberOfConferences = 2
                            numberOfDivisions = 4
                            teamsPerDivision = 4
                        }
                        print("LeagueSettingsView Confirm: Name='\(leagueName)', Total Teams=\(totalTeamsInLeague)")
                        onDone()
                    }
                }
                // Optionally, a "Cancel" button if this sheet can be dismissed without saving
                // ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } // Requires @Environment(\.dismiss) var dismiss
            }
            .onAppear {
                localLeagueName = leagueName // Initialize local state when view appears
                print("LeagueSettingsView appeared. Name: '\(localLeagueName)', Total Teams: \(totalTeamsInLeague)")
                validateAndUpdateMaxPlayoffTeams()
                validateAndUpdateWildcardByes()
            }
            .sheet(isPresented: $showingImagePicker) {
                LeagueImagePicker(image: $leagueLogo) // Assumes LeagueImagePicker is correctly defined
            }
        }
    }
    
    var teamsPerConference: Int {
        useDefaultTeams ? 16 : (numberOfDivisions * teamsPerDivision)
    }

    var totalTeamsInLeague: Int {
        useDefaultTeams ? 32 : (numberOfConferences * teamsPerConference) // Corrected: use teamsPerConference
    }
        
    var maxPossiblePlayoffTeamsPerConference: Int {
        let teamsInConf = useDefaultTeams ? 16 : (numberOfDivisions * teamsPerDivision)
        return max(minPlayoffTeamsPerConference, teamsInConf)
    }

    var validWildcardByesOptions: [Int] {
        wildcardByesOptions.filter { byeOption in
            let teamsPlayingAfterByes = maxPlayoffTeamsPerConference - byeOption
            return byeOption < maxPlayoffTeamsPerConference && teamsPlayingAfterByes >= 2
        }
    }

    private func validateAndUpdateMaxPlayoffTeams() {
        let maxPossible = maxPossiblePlayoffTeamsPerConference // Cache to avoid recomputing
        if maxPlayoffTeamsPerConference > maxPossible {
            maxPlayoffTeamsPerConference = maxPossible
        }
        if maxPlayoffTeamsPerConference < minPlayoffTeamsPerConference {
            maxPlayoffTeamsPerConference = minPlayoffTeamsPerConference
        }
    }
    
    private func validateAndUpdateWildcardByes() {
        if !validWildcardByesOptions.contains(wildcardRoundByes) {
            wildcardRoundByes = validWildcardByesOptions.first ?? 0
        }
         // Ensure byes don't exceed sensible limits based on playoff teams
        if wildcardRoundByes >= maxPlayoffTeamsPerConference / 2 && maxPlayoffTeamsPerConference > 2 {
            // This condition means too many byes, not enough teams playing.
            // Example: 4 playoff teams, 2 byes means 2 teams play. Max 1 bye for 4 teams if you want a game.
            // If 2 byes are selected for 4 teams, it implies only 2 teams play in the wildcard round, which is one game.
            // The validWildcardByesOptions filter should handle this, but an extra check can be useful.
            // For simplicity, relying on validWildcardByesOptions logic for now.
        }
    }
}
