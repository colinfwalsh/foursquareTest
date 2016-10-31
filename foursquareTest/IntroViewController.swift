//
//  IntroViewController.swift
//  foursquareTest
//
//  Created by Colin Walsh on 10/18/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit
import CoreLocation

class IntroViewController: UIViewController, CLLocationManagerDelegate {
    
    /*******************************
     
     This class takes a NSDictionary of JSON data for photo data received from the FourSquare API and stores all necessary/relevant data into properties
     
     *******************************/
    
    // MARK: - Properties
    
    @IBOutlet var getCurrentLocationButton: UIBarButtonItem!
    @IBOutlet var queryTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    let store = FoursquareAPIDataStore.sharedInstance
    
    let alert = UIAlertController.init(title: "Invalid Entry",
                                       message: "",
                                       preferredStyle: .alert)
    
    let locationManager = CLLocationManager()
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.color = UIColor.gray
        activityIndicator.center = view.center
        
        view.addSubview(activityIndicator)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IntroViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func getCurrentLocationPressed(_ sender: AnyObject) {
        self.findMyLocation()
        
        let currentLocation = self.locationManager.location
        
        if currentLocation != nil {
            
            self.activityIndicator.startAnimating()
            
            self.store.getRepositoriesWithCompletion((currentLocation?.coordinate.latitude)!, long: (currentLocation?.coordinate.longitude)!, completion: {[weak self] in
                
                if self?.store.repositories.count == 0 {
                   
                    
                    OperationQueue.main.addOperation {
                        self?.cannotFindLocaitonAlert()
                        self?.activityIndicator.stopAnimating()
                    }
                    
                    print("*****************GETTING NO DATA***************")} else {
                    
                    OperationQueue.main.addOperation({
                        self?.activityIndicator.stopAnimating()
                        self?.performSegue(withIdentifier: "introToVenueDisplay", sender: self)
                        
                    })
                }
                })
            
        } else {
            alert.title = "Location not found"
            alert.message = "Location services not enabled.  Please enable them, or try again."
            
            if alert.actions.count == 0 {
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))}
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func cannotFindLocaitonAlert() {
        alert.title = "Invalid Entry"
        alert.message = "Oops!  We couldn't find that location! Please enter another location and try again."
        
        if alert.actions.count == 0 {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func findMyLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func submitButtonPressed(_ sender: AnyObject) {
        
        if let queryTextField = self.queryTextField.text {
            
            CLGeocoder().geocodeAddressString(queryTextField, completionHandler: {[weak self] (placemarks, error) in
                
                if error != nil {
                    OperationQueue.main.addOperation({
                        self?.cannotFindLocaitonAlert()
                    })
                    print("CANNOT FIND LOCATION")
                }
                
                let placemark = placemarks?.last
                
                if let placemarkLat = placemark?.location?.coordinate.latitude {
                    self?.latitude = placemarkLat as Double
                }
                
                if let placemarkLong = placemark?.location?.coordinate.longitude {
                    self?.longitude = placemarkLong as Double
                }
                
                self?.activityIndicator.startAnimating()
                
                self?.store.getRepositoriesWithCompletion((self?.latitude)!, long: (self?.longitude)!, completion: {
                    if self?.store.repositories.count == 0 {
                        
                        
                        OperationQueue.main.addOperation {
                            self?.cannotFindLocaitonAlert()
                            self?.activityIndicator.stopAnimating()
                        }
                        
                        print("*****************GETTING NO DATA***************")} else {
                        
                        OperationQueue.main.addOperation({
                            self?.activityIndicator.stopAnimating()
                            self?.performSegue(withIdentifier: "introToVenueDisplay", sender: self)
                            
                        })
                        
                    }
                })
                })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
