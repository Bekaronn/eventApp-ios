//
//  EventModel.swift
//  EventApp
//
//  Created by Bekarys on 07.05.2024.
//

import Foundation

struct EventModel: Codable {
    let id: Int
    let title: String
    let description: String
    let date: String
    let location: String
    let image: String
    let tickets_available: Int
    let duration: Int
    let event_type: String
    let price: Int
}
