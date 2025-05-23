//
//  DynastyHubView 2.swift
//  Pure Sim Football
//
//  Created by Jay Estep on 5/23/25.
//


import SwiftUI

struct DynastyHubView: View {
@State var league: League
let leagueLogo: UIImage?
let loadedFromSlotId: Int?

var userTeamDisplay: String? {
if !league.isCommissionerMode, let userTeamId = league.userTeamId {
if let team = league.teams.first(where: { $0.id == userTeamId }) {
return "(team.location) (team.name)"
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
Image(uiImage: image).resizable().scaledToFit().frame(width:60,height:60).clipShape(RoundedRectangle(cornerRadius:8))
}
VStack(alignment: .leading) {
if league.isCommissionerMode {
Text("Commissioner Mode").font(.subheadline).foregroundColor(.orange).bold()
} else if let teamDisplay = userTeamDisplay {
Text("Kontrolling: (teamDisplay)").font(.subheadline).foregroundColor(.blue).bold()
} else if !league.isCommissionerMode && league.userTeamId == nil {
Text("User Team Not Selected").font(.subheadline).foregroundColor(.red).bold()
}
Text("Teams: (league.teams.count)").font(.caption).foregroundColor(.secondary)
Text("Season: (league.currentSeasonYear)")
.font(.caption).foregroundColor(.secondary)
if let slotId = loadedFromSlotId {
Text("Slot: (slotId + 1)").font(.caption).foregroundColor(.gray)
}
}
}
}
Section(header: Text("League Navigation")) {
NavigationLink(destination: ScheduleView(league: $league)) { Label("Schedule", systemImage: "calendar") }
// Calling the placeholder defined below. If you have StandingsView.swift, delete placeholder & fix call.
NavigationLink(destination: StandingsViewPlaceholder(league: league)) { Label("Standings", systemImage: "list.number") }
NavigationLink(destination: LeagueTeamsListView(league: $league)) { Label("Rosters", systemImage: "person.3.fill") }
NavigationLink(destination: LeagueStatsViewPlaceholder()) { Label("Stats & Leaders", systemImage: "chart.bar.fill") }
NavigationLink(destination: SettingsViewPlaceholder()) { Label("League Options", systemImage: "gearshape.fill") }

}
Section {
Button("Save Progress (Slot (loadedFromSlotId != nil ? String(loadedFromSlotId!+1) : "N/A"))") { saveCurrentLeagueProgress() }.disabled(loadedFromSlotId == nil)
}
}
.navigationTitle(league.name.isEmpty ? "Dynasty Hub" : league.name)
.navigationBarTitleDisplayMode(.large)
}
}

 func saveCurrentLeagueProgress() {
guard let slotId = loadedFromSlotId else { print("DynastyHubView Error: No slot ID."); return }
print("DynastyHubView: Saving league '(league.name)' to slot (slotId + 1)")
let leagueFileToSave = SaveSlot(id: slotId).leagueFileName
let logoFileToSave = SaveSlot(id: slotId).logoFileName

LocalFileHelper.saveCodable(league, to: leagueFileToSave) { success in
    if success {
        print("DynastyHubView: League data saved.")
        if let logo = self.leagueLogo {
            LocalFileHelper.saveImage(logo,fileName:logoFileToSave) { _ in
                LocalFileHelper.updateSaveSlot(id:slotId,leagueName:self.league.name,lastModified:Date()) { _ in print("DynastyHubView: Meta updated.")}
            }
        } else { LocalFileHelper.updateSaveSlot(id:slotId,leagueName:self.league.name,lastModified:Date()) { _ in print("DynastyHubView: Meta updated (no logo).")}}
    } else { print("DynastyHubView: Failed to save league data.") }
}
}


}

// MARK: - Placeholder Views for DynastyHubView
// These are simple placeholders. If you have actual separate files for these views
// (e.g., StandingsView.swift), DELETE these placeholders from this file
// and ensure the NavigationLinks in DynastyHubView's body call your actual views correctly.

struct StandingsViewPlaceholder: View {
let league: League // Added to match the call `StandingsViewPlaceholder(league: league)`
var body: some View {
Text("Standings for (league.name) (Placeholder)")
.navigationTitle("Standings")
}
}

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
