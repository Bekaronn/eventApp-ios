//
//  TicketsViewController.swift
//  EventApp
//
//  Created by Bekarys on 08.05.2024.
//

import UIKit

class TicketsViewController: UIViewController {
    var bookings: [BookingModel] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        if(UserAPIManager.shared.isAuthenticated() == true){
            
        }
        getBookings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBookings()
    }
    
    func getBookings() {
        BookingAPIManager.shared.fetchData { bookings, error in
            if let error = error {
                print("Error fetching data: \(error)")
            } else {
                self.bookings = bookings
                print(bookings)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}
extension TicketsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(bookings.count)
        return bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookingCell", for: indexPath) as! TicketsTableViewCell
        let booking = bookings[indexPath.row]
        var event: EventModel = EventModel(id: 0, title: "", description: "", date: "", location: "", image: "", tickets_available: 0, duration: 0, event_type: "", price: 0);
        
        EventAPIManager.shared.fetchEvent(id: booking.event) { eventt, error in
            if let error = error {
                print("Error fetching events: \(error)")
                return
            }
            guard let eventt = eventt else {
                print("No events received")
                return
            }
            DispatchQueue.main.async {
                cell.titleLabel.text = event.title
                cell.idLabel.text = "id \(booking.id)"
                
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
                                cell.cellImage.image = image
                            }
                        } else {
                            print("Unable to create image from data")
                        }
                    }.resume()
                } else {
                    print("Invalid URL")
                }
                print(event.image)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                
                if let date = dateFormatter.date(from: event.date) {
                    dateFormatter.dateFormat = "dd MMMM, HH:mm"
                    dateFormatter.locale = Locale(identifier: "ru_RU")
                    let dayAndMonthString = dateFormatter.string(from: date)
                    cell.dateLabel.text = dayAndMonthString
                } else {
                    print("Невозможно преобразовать строку в дату")
                }

            }
            event = eventt
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 181
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let article = articles[indexPath.row]
//        if let url = article.url {
//            let vc = SFSafariViewController(url: url)
//            present(vc, animated: true)
//        } else {
//            print("URL для данной новости отсутствует")
//        }
//    }
}
