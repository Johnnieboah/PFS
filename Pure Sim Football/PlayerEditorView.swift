// PlayerEditorView.swift

import SwiftUI

struct PlayerEditorView: View {
    @Binding var player: Player
    @Environment(\.dismiss) var dismiss // For a potential Done button if not in a NavigationView managed by RosterView

    // Available positions - consider making this a global constant or part of your data model config
    let allPositions = ["QB", "RB", "WR", "TE", "LT", "LG", "C", "RG", "RT", "DE", "DT", "LB", "CB", "S", "K", "P", "LS"]


    var body: some View {
        // If RosterView presents this as a sheet, and RosterView is in a NavigationView,
        // this might not need its own NavigationView unless you want a separate nav bar style for it.
        // However, for self-contained editing sheets, NavigationView is common for the title.
        NavigationView {
            Form {
                Section(header: Text("Player Details")) { // Changed header
                    TextField("Name", text: $player.name)
                    
                    Picker("Position", selection: $player.position) {
                        ForEach(allPositions, id: \.self) { pos in
                            Text(pos).tag(pos)
                        }
                    }

                    Stepper(value: $player.overall, in: 0...99) {
                        Text("Overall: \(player.overall)") // Corrected
                    }
                    Stepper(value: $player.age, in: 18...45) { // Increased max age slightly
                        Text("Age: \(player.age)") // Corrected
                    }
                    Stepper(value: $player.potential, in: player.overall...99) { // Potential shouldn't be less than current overall
                        Text("Potential: \(player.potential)") // Corrected
                    }
                    .onChange(of: player.overall) { newOverall in // Ensure potential is always >= overall
                        if player.potential < newOverall {
                            player.potential = newOverall
                        }
                    }
                }
            }
            .navigationTitle("Edit \(player.name)") // Corrected
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
