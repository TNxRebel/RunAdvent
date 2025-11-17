//
//  AdventDay.swift
//  Runvent
//
//  Created by Houssem Farhani on 16.11.25.
//

import Foundation

struct AdventDay: Identifiable, Codable {
    let id: Int
    var km: Int?
    var opened: Bool
    var openedAt: Date?
    
    init(id: Int, km: Int? = nil, opened: Bool = false, openedAt: Date? = nil) {
        self.id = id
        self.km = km
        self.opened = opened
        self.openedAt = openedAt
    }
}

