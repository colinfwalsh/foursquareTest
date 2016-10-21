//
//  VenueTableViewController.swift
//  foursquareTest
//
//  Created by Colin Walsh on 10/18/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit
import CoreLocation

class VenueTableViewController: UITableViewController {
    
    let store = FoursquareAPIDataStore.sharedInstance
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var nameToPass = ""
    var categoryNameToPass = ""
    var checkinCountToPass = ""
    var formattedAddressToPass = ""
    var arrayOfImagesToPass : [UIImage] = []
    var coordinatesToPass: CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.color = UIColor.gray
        activityIndicator.center = view.center
        
        view.addSubview(activityIndicator)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "venueDisplayCell", for: indexPath) as? VenueTableViewCell
        
        let repository: FoursquareAPIRepository = self.store.repositories[indexPath.row]
        
        if let distance = repository.venueDistance {
            
            let metersToMiles = Double(distance) * 0.00062137
            
            let metersToFeet = Double(distance) * 3.28084
            
            let formatForMiles = String(format: "%.1f", metersToMiles) + " miles"
            
            let formatForFeet = String(format: "%.0f", metersToFeet) + " feet"
            
            if formatForMiles == "0.0 miles" {
                cell?.venueDistanceLabel.text = formatForFeet
            } else {
                cell?.venueDistanceLabel.text = formatForMiles
            }
        }
        
        let iconDictionary = repository.venueCategories["icon"] as? NSDictionary
        
        var iconURLString : String = ""
        
        if let prefix = iconDictionary?["prefix"] {
            if let suffix = iconDictionary?["suffix"] {
                iconURLString = "\(prefix)88\(suffix)"
                
                
            }
        }
        
        var image = UIImage.init()
        var tempData : Data!
        
        let stringToUrl = URL(string: iconURLString)
        
        if let url = stringToUrl {
            tempData = try! Data(contentsOf: url)
        }
        
        if let data = tempData {
            if let requestedImage = UIImage(data: data) {
                image = requestedImage
            }
        }
        
        cell?.venueTitle.text = repository.venueName
        cell?.venueIcon.image = image
        
        if let categoryName = repository.venueCategories["name"] {
            cell?.venueCategoryLabel.text = categoryName as? String
        }
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = self.store.repositories[indexPath.row]
        
        self.nameToPass = repository.venueName
        
        if let categoryName = repository.venueCategories["name"] {
            self.categoryNameToPass = categoryName as! String
        }
        
        if let checkinCount = repository.venueStats["checkinsCount"] {
            self.checkinCountToPass = String.init(describing: checkinCount)
        }
        
        if let address = repository.venueLocation["formattedAddress"] as? NSArray {
            for items in address {
                let formattedItems = "\(items)\n"
                    self.formattedAddressToPass.append(formattedItems)
            }
            
            print(self.formattedAddressToPass)
        }
        
        if let repositoryLatitude = repository.venueLocation["lat"] as? Double {
            if let repositoryLongitude = repository.venueLocation["lng"] as? Double {
                let latitudeLocationDegrees: CLLocationDegrees = repositoryLatitude
                let longitudeLocationDegrees: CLLocationDegrees = repositoryLongitude
                
                self.coordinatesToPass = CLLocationCoordinate2D.init(latitude: latitudeLocationDegrees, longitude: longitudeLocationDegrees)
                
                print(self.coordinatesToPass)
            }
        }
        
        self.activityIndicator.startAnimating()
        
        self.store.getPhotoRepositoriesWithCompletion(venueId: repository.venueId, completion: {
            
            self.arrayOfImagesToPass.removeAll()
            
            var photoStringRepository : [String] = []
            
            
            for items in self.store.photoArray {
                if let prefix = items.photoPrefix {
                    if let suffix = items.photoSuffix {
                        let photoString = "\(prefix)cap500\(suffix)"
                        photoStringRepository.append(photoString)
                    }
                }
            }
            
            
            
            
            var tempData : Data!
            
            for string in photoStringRepository {
                let stringToUrl = URL(string: string)
                
                if let url = stringToUrl {
                    tempData = try? Data(contentsOf: url)
                }
                
                if let data = tempData {
                    if let requestedImage = UIImage(data: data) {
                        self.arrayOfImagesToPass.append(requestedImage)
                        print(self.arrayOfImagesToPass)
                    }
                }
                
            }
            
            
            OperationQueue.main.addOperation({
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "tableViewToDetailView", sender: self)
            })
            
        })
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tableViewToDetailView" {
            let destinationVC = segue.destination as? VenueDetailViewController
            
            destinationVC?.address = self.formattedAddressToPass
            destinationVC?.venueCoordinate = self.coordinatesToPass
            destinationVC?.photoArray = self.arrayOfImagesToPass
            destinationVC?.name = self.nameToPass
            destinationVC?.categoryName = self.categoryNameToPass
            destinationVC?.checkinCount = self.checkinCountToPass
        }
        
    }
    
    
    
}
