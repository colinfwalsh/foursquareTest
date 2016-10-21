//
//  VenueDetailViewController.swift
//  foursquareTest
//
//  Created by Colin Walsh on 10/19/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class VenueDetailViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var photoArray : [UIImage] = []
    var name = ""
    var categoryName = ""
    var checkinCount = ""
    var address = ""
    var venueCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.allowsSelection = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? VenueDetailImageViewCell
            
            if self.photoArray.count != 0 {
                
                cell?.imagesToDisplay.animationImages = self.photoArray
                
                cell?.imagesToDisplay.animationDuration = 100
                
                cell?.imagesToDisplay.animationRepeatCount = 10
                
                cell?.imagesToDisplay.startAnimating()
                
            } else {
                
                let notFoundImage = UIImage.init(named: "no-img-1")
                cell?.imagesToDisplay.image = notFoundImage
            }
            
            return cell!
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell") as? VenueDetailContentTableViewCell
            
            cell?.titleLabel.text = self.name
            cell?.categoryLabel.text = self.categoryName
            cell?.supplementaryLabel.text = "Total Check Ins: \(self.checkinCount)"
            
            return cell!
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell") as? VenueDetailAddressTableViewCell
            
            cell?.addressLabel.text = self.address
            return cell!
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell") as? VenueDetailMapViewTableViewCell
            
            print(self.venueCoordinate)
            
            print("latitude: \(self.venueCoordinate.latitude)")
            print("longitude: \(self.venueCoordinate.longitude)")

            
            cell?.showLocation(coordinate: self.venueCoordinate, name: self.name)
            
            return cell!
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
