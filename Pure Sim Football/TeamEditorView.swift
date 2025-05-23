//
//  TeamEditorView.swift
//  Pure Sim Football
//
//  Created by Jay Estep on 5/22/25.
//

import SwiftUI

struct TeamEditorView: View {
    @Binding var team: Team
    @State private var selectedColor: Color
    @Environment(\.dismiss) var dismiss // Used to dismiss the sheet

    init(team: Binding<Team>) {
        self._team = team
        // Initialize selectedColor from the team's current colorHex
        self._selectedColor = State(initialValue: Color(hex: team.wrappedValue.colorHex) ?? .gray)
    }

    var body: some View {
        // NavigationView to enable the toolbar for the Done button
        NavigationView {
            Form {
                Section(header: Text("Team Info")) {
                    TextField("Location", text: $team.location)
                    TextField("Name", text: $team.name)
                    ColorPicker("Team Color", selection: $selectedColor)
                        .onChange(of: selectedColor) { newColor in
                            team.colorHex = newColor.toHex() ?? "#808080" // Update hex on color change
                        }
                }

                Section {
                    NavigationLink("Edit Roster") {
                        // RosterView should also be wrapped in a NavigationView if it needs its own toolbar,
                        // or ensure it works correctly when pushed in this context.
                        RosterView(team: $team)
                    }
                }
            }
            .navigationTitle("Edit Team")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss() // Dismiss the sheet
                    }
                }
            }
        }
    }
}

// Helper extension for Color to Hex (make sure this is also in your Models.swift or a shared utility file if not already)
// If it's in Models.swift and accessible, you might not need it duplicated here.
// For now, keeping it as per your provided file structure.

    // If this init(hex:) is not already in a shared place (like Models.swift),
    // ensure TeamEditorView can access it for initializing selectedColor.
    // It IS in Models.swift based on previous context.
    /*
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r, g, b: Double
        switch hexSanitized.count {
        case 6:
            r = Double((rgb & 0xFF0000) >> 16) / 255
            g = Double((rgb & 0x00FF00) >> 8) / 255
            b = Double(rgb & 0x0000FF) / 255
        default:
            return nil
        }
        self.init(red: r, green: g, blue: b)
    }
    */

