//
//  EventAPIManager.swift
//  EventApp
//
//  Created by Bekarys on 07.05.2024.
//

import Foundation

class EventAPIManager {
    static let shared = EventAPIManager()
    let baseURL = "http://localhost:8000/api/events/"
    var selectedEvent = 0
    
    func fetchEvents(type: String, search: String, completion: @escaping ([EventModel]?, Error?) -> Void) {
        let urll = "\(baseURL)?event_type=\(type)&title=\(search)"
        
        guard let url = URL(string: urll) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: 0, userInfo: nil))
                return
            }
            
            do {
                let events = try JSONDecoder().decode([EventModel].self, from: data)
                completion(events, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func fetchEvent(id: Int, completion: @escaping (EventModel?, Error?) -> Void) {
        var urll = "\(baseURL)\(selectedEvent)/"
        if id != 0 {
            urll = "\(baseURL)\(id)/"
        }
        
        guard let url = URL(string: urll) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: 0, userInfo: nil))
                return
            }
            
            do {
                let event = try JSONDecoder().decode(EventModel.self, from: data)
                completion(event, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
