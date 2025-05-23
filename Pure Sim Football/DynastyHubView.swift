import SwiftUI
import UIKit

struct LeagueSettingsView: View {
    // Bindings from NewLeagueView
    @Binding var useDefaultTeams: Bool
    @Binding var leagueName: String // This is the "source of truth" from NewLeagueView
    @Binding var leagueLogo: UIImage?
    
    @Binding var numberOfConferences: Int
    @Binding var numberOfDivisions: Int
    @Binding var teamsPerDivision: Int
    @Binding var gamesPerSeason: Int

    @Binding var maxPlayoffTeamsPerConference: Int
    @Binding var wildcardRoundByes: Int
    @Binding var divisionWinnersTopSeeds: Bool
    @Binding var bracketReseedAfterRoundOne: Bool

    var onDone: () -> Void

    // Local state for the TextField
    @State private var localLeagueName: String = ""
    
    @State private var showingImagePicker = false
    let wildcardByesOptions = [0, 1, 2, 4]
    @FocusState private var isLeagueNameFieldFocused: Bool

    var body: some View {
        VStack {
            Form {
                Section(header: Text("League Identity")) {
                    TextField("League Name", text: $localLeagueName) // Bind to localLeagueName
                        .focused($isLeagueNameFieldFocused)
                        .onSubmit {
                            // When Return key is pressed, dismiss keyboard.
                            // The text in localLeagueName will be preserved.
                            isLeagueNameFieldFocused = false
                        }
                        .onChange(of: isLeagueNameFieldFocused) { focused in
                            if !focused {
                                // When TextField loses focus (e.g., user taps outside, or Return key was pressed)
                                // update the actual binding.
                                print("League Name TextField lost focus. Updating binding with: '\(localLeagueName)'")
                                leagueName = localLeagueName
                            }
                        }
                    
                    HStack {
                        Text("League Logo")
                        Spacer()
                        if let logo = leagueLogo {
                            Image(uiImage: logo)
                                .resizable().scaledToFit().frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        } else {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable().scaledToFit().frame(width: 40, height: 40).foregroundColor(.gray)
                        }
                        Button(leagueLogo == nil ? "Add Logo" : "Change Logo") { showingImagePicker = true }
                        .buttonStyle(.borderless)
                    }
                }

                Section(header: Text("Team Source")) {
                    Toggle("Use Default NFL-Style Teams", isOn: $useDefaultTeams)
                }

                Section(header: Text("League Structure")) {
                    Stepper(value: $numberOfConferences, in: 1...4) { Text("Conferences: \(numberOfConferences)") }
                    Stepper(value: $numberOfDivisions, in: 1...8) { Text("Divisions per Conference: \(numberOfDivisions)") }
                    Stepper(value: $teamsPerDivision, in: 2...8) { Text("Teams per Division: \(teamsPerDivision)") }
                    Stepper(value: $gamesPerSeason, in: 1...25) { Text("Games per Regular Season: \(gamesPerSeason)") }
                    Text("Total Teams: \(totalTeamsInLeague)").font(.caption).foregroundColor(.gray)
                }

                Section(header: Text("Playoff Settings")) {
                    Stepper(value: $maxPlayoffTeamsPerConference, in: 2...maxPossiblePlayoffTeamsPerConference) {
                        Text("Playoff Teams per Conf: \(maxPlayoffTeamsPerConference)")
                    }
                    VStack(alignment: .leading) {
                        Text("Wildcard Round Byes per Conf:").font(.subheadline)
                        Picker("Wildcard Round Byes", selection: $wildcardRoundByes) {
                            ForEach(validWildcardByesOptions, id: \.self) { value in
                                Text("\(value) Bye\(value == 1 ? "" : "s")").tag(value)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: maxPlayoffTeamsPerConference) { newValue in // Corrected onChange
                            validateAndUpdateWildcardByes()
                        }
                        Text("Note: Max byes cannot exceed (Playoff Teams / 2) - 1, and must leave at least 2 teams playing.")
                            .font(.caption2).foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                    Toggle("Division Winners are Top Seeds", isOn: $divisionWinnersTopSeeds)
                    Toggle("Reseed Bracket After Wildcard", isOn: $bracketReseedAfterRoundOne)
                }
            }
            
            Button(action: {
                // Ensure localLeagueName is committed to the binding before calling onDone
                if isLeagueNameFieldFocused {
                    isLeagueNameFieldFocused = false // This will trigger the .onChange above
                }
                // If not focused, explicitly update binding from local state
                leagueName = localLeagueName
                print("Continue button tapped. Final leagueName binding set to: '\(leagueName)'")
                onDone()
            }) {
                Text("Continue")
                    .font(.headline).frame(maxWidth: .infinity).padding()
                    .background(Color.accentColor).foregroundColor(.white).cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            // When the view appears, initialize localLeagueName from the binding
            localLeagueName = leagueName
            print("LeagueSettingsView appeared. Initial localLeagueName set to: '\(localLeagueName)' from binding.")
            validateAndUpdateWildcardByes()
        }
        .sheet(isPresented: $showingImagePicker) {
            LeagueImagePicker(image: $leagueLogo)
        }
    }
    
    var totalTeamsInLeague: Int { numberOfConferences * numberOfDivisions * teamsPerDivision }
    var maxTeamsPerConference: Int { (numberOfDivisions * teamsPerDivision) }
    var maxPossiblePlayoffTeamsPerConference: Int { max(2, maxTeamsPerConference) }
    var validWildcardByesOptions: [Int] {
        wildcardByesOptions.filter { byeOption in
            let teamsPlayingIfByes = maxPlayoffTeamsPerConference - (byeOption * 2)
            return byeOption * 2 < maxPlayoffTeamsPerConference && teamsPlayingIfByes >= 2 && byeOption <= 4
        }
    }
    private func validateAndUpdateWildcardByes() {
        // If current selection is invalid due to other changes, reset it
        if !validWildcardByesOptions.contains(wildcardRoundByes) {
             // Prefer to keep it if possible, otherwise reset to smallest valid or 0
            wildcardRoundByes = validWildcardByesOptions.first ?? 0
        }
    }
}
//test comment
