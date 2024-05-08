//
//  EventViewController.swift
//  EventApp
//
//  Created by Bekarys on 07.05.2024.
//

import UIKit

class EventViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var events: [EventModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        categoryScrollView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchEvents()
    }
    
    
    @objc private func fetchEvents() {
        EventAPIManager.shared.fetchEvents { events, error in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }
            
            guard let events = events else {
                print("No events received")
                return
            }
            
            self.events = events
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension EventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(events.count)
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as! EventCollectionViewCell
        let event = events[indexPath.item]
        cell.titleLabel.text = event.title
        cell.eventImage.layer.cornerRadius = 10
        cell.eventImage.clipsToBounds = true

        if let url = URL(string: event.image) {
            URLSession.shared.dataTask(with: url) { data, response, error in               
                if let error = error {
                print("Error downloading image: \(error)")
                return
            }
                guard let imageData = data else {
                    print("No image data received")
                    return
                }
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.eventImage.image = image
                    }
                } else {
                    print("Unable to create image from data")
                }
            }.resume()
        } else {
            print("Invalid URL")
        }

//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//
//        if let date = dateFormatter.date(from: event.date) {
//            dateFormatter.dateFormat = "dd MMMM"
//            dateFormatter.locale = Locale(identifier: "ru_RU")
//            let dayAndMonthString = dateFormatter.string(from: date)
//            cell.dateLabel.text = dayAndMonthString
//        } else {
//            print("Невозможно преобразовать строку в дату")
//        }
        return cell
    }
}
