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
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    private var events: [EventModel] = []
    private var eventType: [String] = ["","cinema","concert","theater","sport"]
    private var selectedType = ""
    private var search = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchEvents()
    }
    
    
    @objc private func fetchEvents() {
        EventAPIManager.shared.fetchEvents(type: selectedType, search: search) { events, error in
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
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        print("Selected segment index: \(selectedIndex)")
        if selectedIndex == 0 {
            selectedType = eventType[0]
            fetchEvents()
        } else if selectedIndex == 1 {
            selectedType = eventType[1]
            fetchEvents()
        } else if selectedIndex == 2 {
            selectedType = eventType[2]
            fetchEvents()
        } else if selectedIndex == 3 {
            selectedType = eventType[3]
            fetchEvents()
        } else if selectedIndex == 4 {
            selectedType = eventType[4]
            fetchEvents()
        }
    }
}

extension EventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UISearchBarDelegate {
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            search = ""
            searchBar.resignFirstResponder()
            print(search)
            fetchEvents()
            return
        }
        search = text
        searchBar.resignFirstResponder()
        print(text)
        fetchEvents()
    }
}

