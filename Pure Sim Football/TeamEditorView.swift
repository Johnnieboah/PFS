// TeamEditorView.swift

import SwiftUI

struct TeamEditorView: View {
    @Binding var team: Team
    @State private var selectedColor: Color
    @Environment(\.dismiss) var dismiss

    var onTeamSelectedAsUserTeam: ((UUID) -> Void)?
    var isBeingUsedForInitialSelection: Bool = false

    init(team: Binding<Team>, onTeamSelectedAsUserTeam: ((UUID) -> Void)? = nil, isBeingUsedForInitialSelection: Bool = false) {
        self._team = team
        self._selectedColor = State(initialValue: Color(hex: team.wrappedValue.colorHex) ?? .gray)
        self.onTeamSelectedAsUserTeam = onTeamSelectedAsUserTeam
        self.isBeingUsedForInitialSelection = isBeingUsedForInitialSelection
        
        // print("TeamEditorView init: Team '(\(team.wrappedValue.name))', isInitialSelection: \(isBeingUsedForInitialSelection)")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Team Info")) {
                    TextField("Location", text: $team.location)
                    TextField("Name", text: $team.name)
                    ColorPicker("Team Color", selection: $selectedColor)
                        .onChange(of: selectedColor) { newColor in
                            team.colorHex = newColor.toHex() ?? team.colorHex
                        }
                }

                Section(header: Text("Roster")) {
                    NavigationLink("Edit Roster (\(team.players.count) players)") {
                        RosterView(team: $team)
                    }
                }

                // "Select this Team" button is only shown if for initial selection
                if isBeingUsedForInitialSelection {
                    Section(header: Text("Confirm Your Choice")) {
                        Button {
                            print("TeamEditorView: 'Select this Team & Confirm' button tapped for team \(team.name) (ID: \(team.id))")
                            if let callback = onTeamSelectedAsUserTeam {
                                callback(team.id) // This sets the userTeamId in NewLeagueView
                            } else {
                                print("TeamEditorView: ERROR - onTeamSelectedAsUserTeam callback is nil.")
                            }
                            // Dismissal is handled by NewLeagueView when selectedTeamForEditing becomes nil
                        } label: {
                            Label("Select this Team & Confirm", systemImage: "checkmark.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .buttonStyle(.borderedProminent) // Make it stand out
                        .tint(.blue) // Ensure it's clearly actionable
                    }
                }
            }
            .navigationTitle(isBeingUsedForInitialSelection ? "Select: \(team.name)" : "Edit \(team.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    // If for initial selection, this button is effectively "Cancel" or "Done with edits but not selecting"
                    // If not for initial selection, it's just "Done"
                    Button(isBeingUsedForInitialSelection ? "Cancel Selection" : "Done Editing") {
                        print("TeamEditorView: Toolbar button tapped ('\(isBeingUsedForInitialSelection ? "Cancel Selection" : "Done Editing")').")
                        // If it's "Cancel Selection", we explicitly do *not* call the onTeamSelectedAsUserTeam callback.
                        dismiss() // Just dismiss the sheet
                    }
                }
            }
        }
    }
}
