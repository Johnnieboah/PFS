//
//  PlayerEditorView.swift
//  Pure Sim Football
//
//  Created by Jay Estep on 5/23/25.
//


import SwiftUI

struct PlayerEditorView: View {
    @Binding var player: Player
    var body: some View {
        Form {
            Section(header: Text("Player Info")) {
                TextField("Name", text: $player.name)
                TextField("Position", text: $player.position)
                Stepper(value: $player.overall, in: 0...99) {
                    Text("Overall: \(player.overall)")
                }
                Stepper(value: $player.age, in: 18...40) {
                    Text("Age: \(player.age)")
                }
                Stepper(value: $player.potential, in: 0...99) {
                    Text("Potential: \(player.potential)")
                }
            }
        }
        .navigationTitle("Edit Player")
    }
}
