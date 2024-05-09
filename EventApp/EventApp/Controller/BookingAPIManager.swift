//
//  BookingAPIManager.swift
//  EventApp
//
//  Created by Bekarys on 08.05.2024.
//

import Foundation

class BookingAPIManager {
    static let shared = BookingAPIManager()
    let baseUrl = "http://localhost:8000/api/bookings/"
    
    func fetchData(completion: @escaping ([BookingModel], Error?) -> Void) {
        let url = URL(string: baseUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let token = String(UserAPIManager.shared.getToken() ?? "")

        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion([], error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion([], nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let bookings = try decoder.decode([BookingModel].self, from: data)
                completion(bookings, nil)
            } catch {
                print("Error parsing JSON: \(error)")
                completion([], error)
            }
        }
        task.resume()
    }
    
    func createBook(userId: Int, eventId: Int, completion: @escaping (Bool, Error?) -> Void) {
        let url = URL(string: baseUrl)!
        
        let bookData: [String: Any] = [
            "user": userId,
            "event": eventId
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: bookData) else {
            print("Error encoding book data into JSON")
            completion(false, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let token = String(UserAPIManager.shared.getToken() ?? "")
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                print("Error: Invalid HTTP response")
                completion(false, nil)
                return
            }
            completion(true, nil)
        }
        task.resume()
    }

}
