//
//  UserAPIManager.swift
//  EventApp
//
//  Created by Bekarys on 08.05.2024.
//

import Foundation

class UserAPIManager {
    static let shared = UserAPIManager()
    
    private let isAuthenticatedKey = "isAuthenticated"
    private let accessTokenKey = "accessToken"
    
    func authenticateUser(user: User, completion: @escaping (String?, Error?) -> Void) {
        let urlString = "http://localhost:8000/api/login/"
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "username": user.username,
            "password": user.password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("0")
                completion(nil, error)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                    if let accessToken = json["access"] {
                        completion(accessToken, nil)
                    } else {
                        completion(nil, NSError(domain: "AuthenticationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Access token not found in response"]))
                    }
                } else {
                    completion(nil, NSError(domain: "AuthenticationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"]))
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func isAuthenticated() -> Bool {
        return UserDefaults.standard.bool(forKey: isAuthenticatedKey)
    }
    
    func setAuthenticated(_ isAuthenticated: Bool) {
        UserDefaults.standard.set(isAuthenticated, forKey: isAuthenticatedKey)
    }
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: accessTokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
}
