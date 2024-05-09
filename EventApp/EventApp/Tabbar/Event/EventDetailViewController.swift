//
//  EventDetailViewController.swift
//  EventApp
//
//  Created by Bekarys on 09.05.2024.
//

import UIKit

class EventDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var ticketsView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var aboutLabel: UILabel!
    private var selected = 0
    
    var event: EventModel = EventModel(id: 0, title: "", description: "", date: "", location: "", image: "", tickets_available: 0, duration: 0, event_type: "", price: 0);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEvent()
        ticketsView.isHidden = false
        aboutView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        print("Selected segment index: \(selectedIndex)")
        selected = selectedIndex
        if(selected == 0){
            ticketsView.isHidden = false
            aboutView.isHidden = true
        } else if(selected == 1){
            ticketsView.isHidden = true
            aboutView.isHidden = false
        }
    }
    
    @objc private func fetchEvent() {
        EventAPIManager.shared.fetchEvent(id: 0) { event, error in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }
            
            guard let event = event else {
                print("No events received")
                return
            }
            
            self.event = event
            DispatchQueue.main.async {
                self.titleLabel.text = event.title
                self.eventTypeLabel.text = event.event_type
                if let url = URL(string: self.event.image) {
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
                                self.eventImage.image = image
                            }
                        } else {
                            print("Unable to create image from data")
                        }
                    }.resume()
                } else {
                    print("Invalid URL")
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                
                if let date = dateFormatter.date(from: event.date) {
                    dateFormatter.dateFormat = "dd MMMM"
                    dateFormatter.locale = Locale(identifier: "ru_RU")
                    let dayAndMonthString = dateFormatter.string(from: date)
                    self.dateLabel.text = dayAndMonthString
                } else {
                    print("Невозможно преобразовать строку в дату")
                }
                
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                if let date = dateFormatter.date(from: event.date) {
                    dateFormatter.dateFormat = "HH:mm"
                    dateFormatter.locale = Locale(identifier: "ru_RU")
                    let time = dateFormatter.string(from: date)
                    self.timeLabel.text = time
                } else {
                    print("Невозможно преобразовать строку в дату")
                }
                self.aboutLabel.text = event.description
            }
        }
    }
    
    @IBAction func buyButton(_ sender: Any) {
        BookingAPIManager.shared.createBook(userId: UserAPIManager.shared.user.id,eventId: event.id) { success, error in
            if success {
                print("Книга успешно создана")
            } else {
                
                print("Ошибка при создании книги: \(error?.localizedDescription ?? "Неизвестная ошибка")")
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
