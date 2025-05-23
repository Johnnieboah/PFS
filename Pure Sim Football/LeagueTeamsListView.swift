//
//  LeagueTeamsListView.swift
//  Pure Sim Football
//
//  Created by Jay Estep on 5/23/25.
//


import SwiftUI

struct LeagueTeamsListView: View {
    @Binding var league: League // Pass the league to access teams
    // If RosterView needs loadedFromSlotId, pass it through here too
    // let loadedFromSlotId: Int? 

    var body: some View {
        List {
            ForEach($league.teams) { $team_in_binding in // Iterate with binding for RosterView
                NavigationLink(destination: RosterView(team: $team_in_binding)) {
                    Text("\(team_in_binding.location) \(team_in_binding.name)")
                }
            }
        }
        .navigationTitle("Team Rosters")
    }
}