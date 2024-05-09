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
    
    func registerUser(username: String, email: String, password: String, completion: @escaping (Bool, String?, Error?) -> Void) {
        let url = URL(string: "http://localhost:8000/api/register/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let userData = ["username": username, "email": email, "password": password]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else {
            print("Error encoding user data into JSON")
            completion(false, nil, nil)
            return
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        let session = URLSession.shared

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false, nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("No HTTP response received")
                completion(false, nil, nil)
                return
            }
            
            if httpResponse.statusCode == 201 {
                let message = "User registered successfully"
                completion(true, message, nil)
            } else {
                completion(false, nil, nil)
            }
        }
        task.resume()
    }
    
    func authenticateUser(username: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        let urlString = "http://localhost:8000/api/login/"
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
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
    
    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:8000/api/user/") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(getToken() ?? "")", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Server error", code: 0, userInfo: nil)))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let userProfile = try JSONDecoder().decode(UserProfile.self, from: data)
                completion(.success(userProfile))
            } catch {
                completion(.failure(error))
            }
        }.resume()
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
