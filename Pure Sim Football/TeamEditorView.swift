import SwiftUI

struct TeamEditorView: View {
    @Binding var team: Team
    @State private var selectedColor: Color
    @Environment(\.dismiss) var dismiss

    // New callback to signal team selection back to NewLeagueView
    var onTeamSelectedAsUserTeam: ((UUID) -> Void)?
    // Flag to know if this view is being used for initial team selection
    var isBeingUsedForInitialSelection: Bool = false

    init(team: Binding<Team>, onTeamSelectedAsUserTeam: ((UUID) -> Void)? = nil, isBeingUsedForInitialSelection: Bool = false) {
        self._team = team
        self._selectedColor = State(initialValue: Color(hex: team.wrappedValue.colorHex) ?? .gray)
        self.onTeamSelectedAsUserTeam = onTeamSelectedAsUserTeam
        self.isBeingUsedForInitialSelection = isBeingUsedForInitialSelection
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Team Info")) {
                    TextField("Location", text: $team.location)
                    TextField("Name", text: $team.name)
                    ColorPicker("Team Color", selection: $selectedColor)
                        .onChange(of: selectedColor) { newColor in // Use newColor for iOS 14+
                            team.colorHex = newColor.toHex() ?? team.colorHex // Fallback to current if hex fails
                        }
                }

                Section {
                    NavigationLink("Edit Roster") {
                        RosterView(team: $team) // Ensure RosterView is defined
                    }
                }

                // New Section for "Select Team" button, if applicable
                if isBeingUsedForInitialSelection && onTeamSelectedAsUserTeam != nil {
                    Section {
                        Button("Select this Team & Confirm") {
                            onTeamSelectedAsUserTeam!(team.id) // Call the callback
                            dismiss() // Dismiss TeamEditorView
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Edit \(team.location) \(team.name)")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done Editing") { // Renamed from "Done" for clarity
                        dismiss()
                    }
                }
            }
        }
    }
}
