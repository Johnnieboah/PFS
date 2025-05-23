//
//  Models.swift
//  Pure Sim Football
//
//  Created by Jay Estep on 5/22/25.
//

import SwiftUI
import Foundation // For Date, if not already imported via SwiftUI

struct Player: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var position: String
    var overall: Int
    var age: Int
    var potential: Int

    // Explicit Hashable conformance (id is usually sufficient for uniqueness)
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Explicit Equatable conformance (often comes with Identifiable if id is Equatable)
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}

struct Team: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var location: String
    var players: [Player] // Player is now Hashable
    var colorHex: String

    var color: Color {
        Color(hex: colorHex) ?? .gray
    }

    // Explicit Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        // For more robust hashing if needed, you could combine other unique properties:
        // hasher.combine(name)
        // hasher.combine(location)
        // hasher.combine(players) // This works because Player is Hashable
    }

    // Explicit Equatable conformance
    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.id == rhs.id
        // Consider if other properties should be part of equality for your logic
    }
}

struct League: Codable, Identifiable, Hashable {
    var id: UUID = UUID() // Ensures each league has a unique ID
    var name: String
    var teams: [Team] // Team is now Hashable

    // Explicit Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Explicit Equatable conformance
    static func == (lhs: League, rhs: League) -> Bool {
        lhs.id == rhs.id
    }
}

// Represents metadata for a single save game slot
struct SaveSlot: Codable, Identifiable, Hashable {
    var id: Int // The slot number (e.g., 0, 1, 2, 3, 4 for 5 slots)
    var leagueName: String?
    var lastModified: Date?
    var isEmpty: Bool { leagueName == nil && lastModified == nil } // More robust check for empty

    // Filenames associated with this slot
    var leagueFileName: String { "league_slot_\(id).json" }
    var logoFileName: String { "logo_slot_\(id).png" }

    init(id: Int, leagueName: String? = nil, lastModified: Date? = nil) {
        self.id = id
        self.leagueName = leagueName
        self.lastModified = lastModified
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: SaveSlot, rhs: SaveSlot) -> Bool {
        lhs.id == rhs.id
    }
}

extension Color {
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
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
        default:
            return nil
        }
        self.init(red: r, green: g, blue: b)
    }

    // It's good to have toHex() here too if it's a general Color utility
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

