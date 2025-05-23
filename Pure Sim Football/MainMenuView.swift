// MainMenuView.swift

import SwiftUI
import UIKit // For UIImage

// Helper struct for navigation destination data
struct DynastyHubDestination: Hashable, Identifiable {
    let id: UUID // Use league's ID for identity
    let league: League // Pass the whole league

    init(league: League) {
        self.id = league.id
        self.league = league
    }

    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Hash based on league ID
    }

    // Equatable conformance
    static func == (lhs: DynastyHubDestination, rhs: DynastyHubDestination) -> Bool {
        lhs.id == rhs.id
    }
}

// Helper struct for the Load Game sheet
struct LoadGameSheetView: View {
    @Binding var slots: [SaveSlot]
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
                                            .imageScale(.large)
                                    }
                                    .buttonStyle(.borderless)
                                    
                                    Button {
                                        self.slotForDeleteConfirmation = slot
                                    } label: {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.red)
                                            .imageScale(.large)
                                    }
                                    .buttonStyle(.borderless)
                                    .padding(.leading, 5)
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

// Main View struct
struct MainMenuView: View {
    @State private var showNewLeagueSheet = false
    @State private var showLoadGameSheet = false
    @State private var navigationPath = NavigationPath()
    
    @State private var activeLeague: League? = nil
    @State private var activeLeagueLogo: UIImage? = nil
    @State private var activeSlotId: Int? = nil
    
    @State private var saveSlots: [SaveSlot] = []
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 24) {
                Text("Pure Sim Football")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .padding(.top, 40)

                Button {
                    print("MainMenuView: 'New League' button tapped. Resetting activeLeague and showing sheet.")
                    self.activeLeague = nil
                    self.activeLeagueLogo = nil
                    self.activeSlotId = nil
                    self.showNewLeagueSheet = true
                } label: {
                    Label("New League", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button {
                    loadSaveSlotMetadata()
                    self.showLoadGameSheet = true
                } label: {
                    Label("Load Saved League", systemImage: "arrow.down.doc.fill")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
                Text("Version 1.0.1") // Updated version example
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }
            .navigationTitle("Main Menu")
            .navigationBarHidden(true)
            .onAppear {
                loadSaveSlotMetadata()
            }
            .navigationDestination(for: DynastyHubDestination.self) { hubDestinationData in
                DynastyHubView(league: hubDestinationData.league, leagueLogo: self.activeLeagueLogo, loadedFromSlotId: self.activeSlotId)
            }
            .sheet(isPresented: $showNewLeagueSheet) {
                NewLeagueView( // NewLeagueView will manage its own state internally
                    onLeagueCreatedAndReadyToNavigate: { newlyCreatedLeague, newlyCreatedLogo, savedToSlotId in
                        print("MainMenuView: onLeagueCreatedAndReadyToNavigate called.")
                        print("MainMenuView: League Name: \(newlyCreatedLeague.name), UserTeamID: \(newlyCreatedLeague.userTeamId?.uuidString ?? "nil")")
                        
                        self.activeLeague = newlyCreatedLeague
                        self.activeLeagueLogo = newlyCreatedLogo
                        self.activeSlotId = savedToSlotId
                        
                        self.showNewLeagueSheet = false
                        
                        let destination = DynastyHubDestination(league: newlyCreatedLeague)
                        DispatchQueue.main.async {
                            self.navigationPath.append(destination)
                            print("MainMenuView: DynastyHubDestination appended to navigationPath.")
                        }
                    }
                )
            }
            .sheet(isPresented: $showLoadGameSheet) {
                LoadGameSheetView(
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
        LocalFileHelper.loadAndInitializeSaveSlots { loadedSlotsData in
            self.saveSlots = loadedSlotsData
            print("MainMenuView: Save slots loaded. Count: \(loadedSlotsData.count)")
        }
    }

    func loadLeagueFromSlot(_ slot: SaveSlot) {
        guard !slot.isEmpty else {
            self.errorMessage = "This slot (ID: \(slot.id + 1)) is empty and cannot be loaded."
            return
        }
        print("MainMenuView: Loading league from Slot \(slot.id + 1)")
        
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
                        print("MainMenuView: League '\(league.name)' loaded. Navigating to DynastyHub.")
                    }
                }
            } else {
                self.errorMessage = "Failed to load league data from Slot \(slot.id + 1). The file might be corrupted or missing."
                print("MainMenuView: Error loading league from file \(slot.leagueFileName)")
            }
        }
    }

    func deleteLeagueInSlot(_ slot: SaveSlot) {
        print("MainMenuView: Deleting league in Slot \(slot.id + 1)")
        LocalFileHelper.deleteFilesInSlot(slotId: slot.id) { success in
            if success {
                LocalFileHelper.updateSaveSlot(id: slot.id, leagueName: nil, lastModified: nil) { metadataUpdated in
                    if metadataUpdated {
                        self.loadSaveSlotMetadata()
                        print("MainMenuView: Slot \(slot.id + 1) deleted and metadata updated.")
                    } else {
                        self.errorMessage = "Could not update slot metadata after deletion (Slot ID: \(slot.id + 1)). Files may be deleted, but slot info remains."
                        print("MainMenuView: Error updating metadata for slot \(slot.id + 1) after deletion.")
                    }
                }
            } else {
                self.errorMessage = "Failed to delete league files for Slot \(slot.id + 1)."
                print("MainMenuView: Error deleting files for slot \(slot.id + 1).")
            }
        }
    }
}
