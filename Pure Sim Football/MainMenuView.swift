//
//  MainMenuView.swift
//  Pure Sim Football
//
//  Created by Jay Estep on 5/23/25.
//

import SwiftUI

// Define helper structs ONCE.
// If DynastyHubDestination or LoadGameSheetView are needed by other files,
// consider moving them to their own file or Models.swift.
// For now, defined here for MainMenuView's use.
// ENSURE THESE ARE NOT REDEFINED IN NewLeagueView.swift or elsewhere.

struct DynastyHubDestination: Hashable, Identifiable {
    let id: UUID // For Identifiable conformance of the destination value itself
    let league: League // Now holds the actual League object

    // Initializer
    init(league: League) {
        self.id = league.id // Use league's ID for the destination's ID for consistency
        self.league = league
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(league.id) // Hash based on the league's unique ID
    }

    static func == (lhs: DynastyHubDestination, rhs: DynastyHubDestination) -> Bool {
        lhs.league.id == rhs.league.id // Equality based on league's unique ID
    }
}

struct LoadGameSheetView: View { // Ensure this is defined ONLY HERE or in its own file
    @Binding var slots: [SaveSlot] // Ensure SaveSlot is defined (in Models.swift)
    @Binding var showSheet: Bool
    var onSlotSelectedForLoad: (SaveSlot) -> Void
    var onSlotSelectedForDelete: (SaveSlot) -> Void
    
    @State private var slotForDeleteConfirmation: SaveSlot? = nil

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }

    var body: some View {
        NavigationView {
            List {
                if slots.isEmpty {
                    Text("No save slots found. Try creating a new league!")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(slots) { slot in
                        Section(header: Text("SLOT \(slot.id + 1)")) {
                            HStack {
                                VStack(alignment: .leading) {
                                    if slot.isEmpty {
                                        Text("Empty")
                                            .foregroundColor(.gray)
                                            .italic()
                                    } else {
                                        Text(slot.leagueName ?? "Unnamed League")
                                            .font(.headline)
                                        if let date = slot.lastModified {
                                            Text("Saved: \(date, formatter: dateFormatter)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        } else {
                                            Text("No save date")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                Spacer()
                                if !slot.isEmpty {
                                    Button {
                                        onSlotSelectedForLoad(slot)
                                    } label: {
                                        Image(systemName: "arrow.down.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                    .buttonStyle(.borderless)
                                    
                                    Button {
                                        self.slotForDeleteConfirmation = slot
                                    } label: {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.borderless)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Load Game")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showSheet = false
                    }
                }
            }
            .alert(item: $slotForDeleteConfirmation) { slotToDelete in
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete the game in Slot \(slotToDelete.id + 1) (\(slotToDelete.leagueName ?? "Unnamed League"))? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        onSlotSelectedForDelete(slotToDelete)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

// MainMenuView struct definition - ENSURE THIS IS THE ONLY DEFINITION of MainMenuView
struct MainMenuView: View {
    @State private var showNewLeagueSheet = false
    @State private var showLoadGameSheet = false
    @State private var navigationPath = NavigationPath()
    @State private var activeLeague: League? = nil // Ensure League is defined (Models.swift)
    @State private var activeLeagueLogo: UIImage? = nil
    @State private var activeSlotId: Int? = nil
    @State private var saveSlots: [SaveSlot] = [] // Ensure SaveSlot is defined (Models.swift)
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 24) {
                Text("Pure Sim Football")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                Button("New League") {
                    self.activeLeague = nil
                    self.activeLeagueLogo = nil
                    self.activeSlotId = nil
                    self.showNewLeagueSheet = true
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)

                Button("Load Saved League") {
                    loadSaveSlotMetadata()
                    self.showLoadGameSheet = true
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Main Menu")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadSaveSlotMetadata()
            }
            .navigationDestination(for: DynastyHubDestination.self) { hubDestinationData in
                // Ensure DynastyHubView is defined and accessible (in DynastyHubView.swift)
                DynastyHubView(league: hubDestinationData.league, leagueLogo: self.activeLeagueLogo, loadedFromSlotId: self.activeSlotId)
            }
            .sheet(isPresented: $showNewLeagueSheet) {
                // This line requires NewLeagueView to be correctly defined (in NewLeagueView.swift) and accessible
                NewLeagueView(
                    onLeagueCreatedAndReadyToNavigate: { newlyCreatedLeague, newlyCreatedLogo, savedToSlotId in
                        self.activeLeague = newlyCreatedLeague
                        self.activeLeagueLogo = newlyCreatedLogo
                        self.activeSlotId = savedToSlotId
                        self.showNewLeagueSheet = false
                        
                        let destination = DynastyHubDestination(league: newlyCreatedLeague)
                        DispatchQueue.main.async {
                            self.navigationPath.append(destination)
                        }
                    }
                )
            }
            .sheet(isPresented: $showLoadGameSheet) {
                LoadGameSheetView( // This uses the LoadGameSheetView defined above in this file
                    slots: $saveSlots,
                    showSheet: $showLoadGameSheet,
                    onSlotSelectedForLoad: { selectedSlot in
                        loadLeagueFromSlot(selectedSlot)
                    },
                    onSlotSelectedForDelete: { slotToDelete in
                        deleteLeagueInSlot(slotToDelete)
                    }
                )
            }
            .alert("Error", isPresented: Binding<Bool>(
                get: { self.errorMessage != nil },
                set: { if !$0 { self.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(self.errorMessage ?? "An unknown error occurred.")
            }
        }
    }

    func loadSaveSlotMetadata() {
        LocalFileHelper.loadAndInitializeSaveSlots { loadedSlotsData in // Ensure LocalFileHelper is accessible
            self.saveSlots = loadedSlotsData
        }
    }

    func loadLeagueFromSlot(_ slot: SaveSlot) {
        guard !slot.isEmpty else {
            self.errorMessage = "This slot (ID: \(slot.id + 1)) is empty."
            return
        }
        
        LocalFileHelper.loadCodable(League.self, from: slot.leagueFileName) { leagueOptional in
            if let league = leagueOptional {
                self.activeLeague = league
                self.activeSlotId = slot.id
                
                LocalFileHelper.loadImage(fileName: slot.logoFileName) { imageOptional in
                    self.activeLeagueLogo = imageOptional
                    self.showLoadGameSheet = false
                    let destination = DynastyHubDestination(league: league)
                    DispatchQueue.main.async {
                        self.navigationPath.append(destination)
                    }
                }
            } else {
                self.errorMessage = "Failed to load league from Slot \(slot.id + 1)."
            }
        }
    }

    func deleteLeagueInSlot(_ slot: SaveSlot) {
        LocalFileHelper.deleteFilesInSlot(slotId: slot.id) { success in
            if success {
                LocalFileHelper.updateSaveSlot(id: slot.id, leagueName: nil, lastModified: nil) { metadataUpdated in
                    if metadataUpdated {
                        self.loadSaveSlotMetadata()
                    } else {
                        self.errorMessage = "Could not update slot metadata after deletion (Slot ID: \(slot.id + 1))."
                    }
                }
            } else {
                self.errorMessage = "Failed to delete files for Slot \(slot.id + 1)."
            }
        }
    }
}
//test comment
