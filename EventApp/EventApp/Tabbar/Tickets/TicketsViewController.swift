//
//  TicketsViewController.swift
//  EventApp
//
//  Created by Bekarys on 08.05.2024.
//

import UIKit

class TicketsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getBookings(_ sender: Any) {
        BookingAPIManager.shared.fetchData()
    }
    
}
