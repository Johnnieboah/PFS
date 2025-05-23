//
//  LocalFileHelper.swift
//  Pure Sim Football
//
//  Created by Jay Estep on 5/22/25.
//

import Foundation
import UIKit

struct LocalFileHelper {

    static let numberOfSaveSlots = 3 // Let's start with 3 slots, can be adjusted
    private static let saveSlotsMetadataFileName = "save_slots_metadata.json"

    // MARK: - File Path Helper (No change)
    static func getDocumentsDirectory(for fileName: String) -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
    }

    // MARK: - Generic JSON Codable Save / Load (No change in signature)
    // These will be used with slot-specific filenames passed by the caller.
    static func saveCodable<T: Codable>(_ object: T, to fileName: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = getDocumentsDirectory(for: fileName) else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            do {
                let data = try JSONEncoder().encode(object)
                try data.write(to: url)
                DispatchQueue.main.async { completion(true) }
            } catch {
                print("Error saving file \(fileName): \(error)")
                DispatchQueue.main.async { completion(false) }
            }
        }
    }

    static func loadCodable<T: Codable>(_ type: T.Type, from fileName: String, completion: @escaping (T?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = getDocumentsDirectory(for: fileName),
                  FileManager.default.fileExists(atPath: url.path) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let object = try JSONDecoder().decode(type, from: data)
                DispatchQueue.main.async { completion(object) }
            } catch {
                print("Error loading file \(fileName): \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }
    }

    // MARK: - Generic UIImage Save / Load (No change in signature)
    // These will be used with slot-specific filenames.
    static func saveImage(_ image: UIImage, fileName: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = getDocumentsDirectory(for: fileName),
                  let data = image.pngData() else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            do {
                try data.write(to: url)
                DispatchQueue.main.async { completion(true) }
            } catch {
                print("Error saving image \(fileName): \(error)")
                DispatchQueue.main.async { completion(false) }
            }
        }
    }

    static func loadImage(fileName: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = getDocumentsDirectory(for: fileName),
                  FileManager.default.fileExists(atPath: url.path) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            let image = UIImage(contentsOfFile: url.path)
            DispatchQueue.main.async { completion(image) }
        }
    }

    // MARK: - Save Slot Metadata Management
    
    /**
     Loads the array of save slot metadata. If none exists, it initializes them.
     */
    static func loadAndInitializeSaveSlots(completion: @escaping ([SaveSlot]) -> Void) {
        loadCodable([SaveSlot].self, from: saveSlotsMetadataFileName) { loadedSlots in
            if let slots = loadedSlots, slots.count == numberOfSaveSlots {
                completion(slots)
            } else {
                // Initialize new slots if file doesn't exist, is corrupt, or slot count changed
                var newSlots: [SaveSlot] = []
                for i in 0..<numberOfSaveSlots {
                    newSlots.append(SaveSlot(id: i)) // Slot IDs 0, 1, 2 for 3 slots
                }
                saveSaveSlotsMetadata(newSlots) { success in
                    if success {
                        completion(newSlots)
                    } else {
                        // If saving initial slots fails, return empty or handle error
                        print("Failed to save initial slot metadata!")
                        completion([]) // Or a default set of empty slots not persisted
                    }
                }
            }
        }
    }

    /**
     Saves the array of save slot metadata.
     */
    static func saveSaveSlotsMetadata(_ slots: [SaveSlot], completion: @escaping (Bool) -> Void) {
        saveCodable(slots, to: saveSlotsMetadataFileName, completion: completion)
    }
    
    /**
    Updates a specific save slot's metadata and saves all metadata.
    */
    static func updateSaveSlot(id: Int, leagueName: String?, lastModified: Date?, completion: @escaping (Bool) -> Void) {
        loadAndInitializeSaveSlots { currentSlots in
            var mutableSlots = currentSlots
            if let index = mutableSlots.firstIndex(where: { $0.id == id }) {
                mutableSlots[index].leagueName = leagueName
                mutableSlots[index].lastModified = lastModified
                saveSaveSlotsMetadata(mutableSlots, completion: completion)
            } else {
                print("Error: Could not find slot with id \(id) to update.")
                completion(false)
            }
        }
    }
    
    /**
     Deletes the league and logo files for a specific slot.
     Does not clear the metadata name/date, that should be done via `updateSaveSlot`.
     */
    static func deleteFilesInSlot(slotId: Int, completion: @escaping (Bool) -> Void) {
        let slot = SaveSlot(id: slotId) // Create a temporary slot just to get filenames
        let leagueFile = slot.leagueFileName
        let logoFile = slot.logoFileName
        var leagueDeleted = false
        var logoDeleted = false
        var attempts = 0
        let totalAttempts = 2 // one for league, one for logo

        let checkCompletion = {
            attempts += 1
            if attempts == totalAttempts {
                completion(leagueDeleted && logoDeleted) // True if both successfully deleted (or didn't exist)
            }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            if let leagueUrl = getDocumentsDirectory(for: leagueFile), FileManager.default.fileExists(atPath: leagueUrl.path) {
                do {
                    try FileManager.default.removeItem(at: leagueUrl)
                    leagueDeleted = true
                } catch {
                    print("Error deleting league file \(leagueFile): \(error)")
                    leagueDeleted = false
                }
            } else {
                leagueDeleted = true // File didn't exist, consider it "deleted"
            }
            DispatchQueue.main.async { checkCompletion() }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let logoUrl = getDocumentsDirectory(for: logoFile), FileManager.default.fileExists(atPath: logoUrl.path) {
                do {
                    try FileManager.default.removeItem(at: logoUrl)
                    logoDeleted = true
                } catch {
                    print("Error deleting logo file \(logoFile): \(error)")
                    logoDeleted = false
                }
            } else {
                logoDeleted = true // File didn't exist, consider it "deleted"
            }
            DispatchQueue.main.async { checkCompletion() }
        }
    }
}
//test comment
