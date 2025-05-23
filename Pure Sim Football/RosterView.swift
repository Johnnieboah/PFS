//
//  RosterView.swift
//  Pure Sim Football
//
//  Created by Jay Estep on 5/23/25.
//


import SwiftUI

struct RosterView: View {
    @Binding var team: Team
    @State private var selectedPlayer: Player? = nil
    @State private var showingPlayerEditor = false

    var body: some View {
        List {
            ForEach(team.players) { player in
                Button {
                    selectedPlayer = player
                    showingPlayerEditor = true
                } label: {
                    VStack(alignment: .leading) {
                        Text(player.name).font(.headline)
                        Text("\(player.position) | Overall: \(player.overall)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onDelete(perform: deletePlayer)

            Button("Add Player") {
                let newPlayer = Player(name: "New Player", position: "QB", overall: 50, age: 22, potential: 60)
                team.players.append(newPlayer)
            }
        }
        .navigationTitle("\(team.location) \(team.name) Roster")
        .sheet(item: $selectedPlayer) { player in
            PlayerEditorView(player: binding(for: player))
        }
    }

    func deletePlayer(at offsets: IndexSet) {
        team.players.remove(atOffsets: offsets)
    }

    func binding(for player: Player) -> Binding<Player> {
        guard let index = team.players.firstIndex(where: { $0.id == player.id }) else {
            fatalError("Player not found")
        }
        return $team.players[index]
    }
}
//Test
