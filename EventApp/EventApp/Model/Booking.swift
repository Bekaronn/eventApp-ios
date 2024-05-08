//
//  BookingModel.swift
//  EventApp
//
//  Created by Bekarys on 07.05.2024.
//

import Foundation

struct BookingModel: Codable {
    let id: Int
    let user: User
    let event: EventModel
    let booked_at: String
}
