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
    
    func fetchData() {
        // Установите URL для запроса
        let url = URL(string: baseUrl)!

        // Создайте URLRequest с указанием типа запроса
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Установите заголовки для авторизации с токеном
        let token = String(UserAPIManager.shared.getToken() ?? "") // Замените на ваш токен

        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        // Создайте сессию URLSession
        let session = URLSession.shared

        // Создайте задачу для выполнения запроса
        let task = session.dataTask(with: request) { (data, response, error) in
            print(token)
            // Проверка на наличие ошибок
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Проверка наличия данных
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Преобразуйте данные в формат JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }

        // Запуск задачи
        task.resume()
    }
}
