//
//  TeamsTypeSelectionView.swift
//  Pure Sim Football
//
//  Created by Jay Estep on 5/22/25.
//

import SwiftUI

struct TeamsTypeSelectionView: View {
    @Binding var useDefaultTeams: Bool
    var onDone: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Choose Team Type")) {
                    Picker("Team Type", selection: $useDefaultTeams) {
                        Text("Default Teams").tag(true)
                        Text("Custom Teams").tag(false)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Select Teams")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onDone()
                    }
                }
            }
        }
    }
}


