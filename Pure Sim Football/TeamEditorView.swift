// TeamEditorView.swift

import SwiftUI

struct TeamEditorView: View {
    @Binding var team: Team
    @State private var selectedColor: Color
    @Environment(\.dismiss) var dismiss

    var onTeamSelectedAsUserTeam: ((UUID) -> Void)?
    var isBeingUsedForInitialSelection: Bool = false

    // Initialize selectedColor from team.colorHex
    init(team: Binding<Team>, onTeamSelectedAsUserTeam: ((UUID) -> Void)? = nil, isBeingUsedForInitialSelection: Bool = false) {
        self._team = team
        // Ensure selectedColor is initialized AFTER team is available
        self._selectedColor = State(initialValue: Color(hex: team.wrappedValue.colorHex) ?? .gray)
        self.onTeamSelectedAsUserTeam = onTeamSelectedAsUserTeam
        self.isBeingUsedForInitialSelection = isBeingUsedForInitialSelection
    }

    var body: some View {
        // This view is presented as a sheet and has its own "Done" button,
        // so NavigationView is appropriate for the title bar.
        NavigationView {
            Form {
                Section(header: Text("Team Info")) {
                    TextField("Location", text: $team.location)
                    TextField("Name", text: $team.name)
                    ColorPicker("Team Color", selection: $selectedColor)
                        .onChange(of: selectedColor) { newValue in
                            team.colorHex = newValue.toHex() ?? team.colorHex
                        }
                }

                Section(header: Text("Roster")) { // Added header for clarity
                    NavigationLink("Edit Roster (\(team.players.count) players)") { // Corrected Text
                        RosterView(team: $team) // Ensure RosterView is correctly defined
                    }
                }

                if isBeingUsedForInitialSelection && onTeamSelectedAsUserTeam != nil {
                    Section {
                        Button("Select this Team & Confirm") {
                            onTeamSelectedAsUserTeam!(team.id)
                            dismiss() // Dismiss TeamEditorView after selection
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.blue) // Make it look like a primary action
                    }
                }
            }
            .navigationTitle("Edit \(team.location) \(team.name)") // Corrected
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(isBeingUsedForInitialSelection ? "Done Editing" : "Done") { // Adjust button text
                        // Color is already updated via onChange
                        dismiss()
                    }
                }
                // If not for initial selection, perhaps a Cancel button could be useful
                // if (onTeamSelectedAsUserTeam == nil) { // Example condition
                //     ToolbarItem(placement: .cancellationAction) {
                //         Button("Cancel") { dismiss() }
                //     }
                // }
            }
        }
    }
}
