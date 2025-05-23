// DynastyHubView.swift

import SwiftUI

struct DynastyHubView: View {
    @State var league: League // Make it @State if ScheduleView or other presented views modify it directly
    let leagueLogo: UIImage?
    let loadedFromSlotId: Int?

    var userTeamDisplay: String? {
        if !league.isCommissionerMode, let userTeamId = league.userTeamId {
            if let team = league.teams.first(where: { $0.id == userTeamId }) {
                return "\(team.location) \(team.name)"
            }
        }
        return nil
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        if let image = leagueLogo {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        VStack(alignment: .leading) {
                            if league.isCommissionerMode {
                                Text("Commissioner Mode")
                                    .font(.subheadline)
                                    .foregroundColor(.orange)
                                    .bold()
                            } else if let teamDisplay = userTeamDisplay {
                                Text("Kontrolling: \(teamDisplay)")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .bold()
                            } else if !league.isCommissionerMode && league.userTeamId == nil {
                                Text("User Team Not Selected")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .bold()
                            }
                            Text("Teams: \(league.teams.count)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Season: \(league.currentSeasonYear)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if let slotId = loadedFromSlotId {
                                Text("Slot: \(slotId + 1)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                Section(header: Text("League Navigation")) {
                    NavigationLink(destination: ScheduleView(league: $league)) {
                        Label("Schedule", systemImage: "calendar")
                    }
                    NavigationLink(destination: StandingsView(league: league)) {
                        Label("Standings", systemImage: "list.number")
                    }
                    NavigationLink(destination: LeagueTeamsListView(league: $league)) {
                        Label("Rosters", systemImage: "person.3.fill")
                    }
                    NavigationLink(destination: LeagueStatsViewPlaceholder()) {
                        Label("Stats & Leaders", systemImage: "chart.bar.fill")
                    }
                    NavigationLink(destination: SettingsViewPlaceholder()) {
                        Label("League Options", systemImage: "gearshape.fill")
                    }
                }
                Section {
                    Button("Save Progress (Slot \(loadedFromSlotId != nil ? String(loadedFromSlotId! + 1) : "N/A"))") {
                        saveCurrentLeagueProgress()
                    }
                    .disabled(loadedFromSlotId == nil)
                }
            }
            .navigationTitle(league.name.isEmpty ? "Dynasty Hub" : league.name)
            .navigationBarTitleDisplayMode(.large)
        }
    }

    func saveCurrentLeagueProgress() {
        guard let slotId = loadedFromSlotId else {
            print("DynastyHubView Error: No slot ID.")
            return
        }
        print("DynastyHubView: Saving league '\(league.name)' to slot \(slotId + 1)")
        let leagueFileToSave = SaveSlot(id: slotId).leagueFileName
        let logoFileToSave = SaveSlot(id: slotId).logoFileName

        LocalFileHelper.saveCodable(league, to: leagueFileToSave) { success in
            if success {
                print("DynastyHubView: League data saved.")
                if let logo = self.leagueLogo {
                    LocalFileHelper.saveImage(logo, fileName: logoFileToSave) { _ in // Result of image save not critical for now
                        LocalFileHelper.updateSaveSlot(id: slotId, leagueName: self.league.name, lastModified: Date()) { _ in
                            print("DynastyHubView: Meta updated with logo.")
                        }
                    }
                } else {
                    LocalFileHelper.updateSaveSlot(id: slotId, leagueName: self.league.name, lastModified: Date()) { _ in
                        print("DynastyHubView: Meta updated (no logo).")
                    }
                }
            } else {
                print("DynastyHubView: Failed to save league data.")
                // Consider showing an alert to the user here
            }
        }
    }
}

// Placeholder Views (keep them minimal or move to own files if they grow)
struct LeagueStatsViewPlaceholder: View {
    var body: some View {
        Text("League Stats & Leaders Page (Placeholder)")
            .navigationTitle("Stats & Leaders")
    }
}

struct SettingsViewPlaceholder: View {
    var body: some View {
        Text("Simple League Options Page (Placeholder)")
            .navigationTitle("Settings")
    }
}
