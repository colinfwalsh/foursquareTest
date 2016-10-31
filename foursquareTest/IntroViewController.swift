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
    
    var geocodedCoordinate = CLLocationCoordinate2D()
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createActivityIndicator()
        self.makeGestureRecognizer()
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func makeGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IntroViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func createActivityIndicator() {
        activityIndicator.color = UIColor.gray
        activityIndicator.center = view.center
        
        view.addSubview(activityIndicator)
    }
    
    func noDataRepositoryAction() {
        OperationQueue.main.addOperation {
            self.activityIndicator.stopAnimating()
            self.cannotFindLocaitonAlert()
        }
    }
    
    func dataSuccessRepositoryAction() {
        OperationQueue.main.addOperation({
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "introToVenueDisplay", sender: self)
            
        })
    }
    
    func addAction() {
        if self.alert.actions.count == 0 {
            self.alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))}
        else {
            self.present(self.alert, animated: true, completion: nil)
        }
    }
    
    func locationServicesNotEnabledAlert() {
        self.alert.title = "Location not found"
        self.alert.message = "Location services not enabled.  Please enable them, or try again."
        
        self.addAction()
        
    }
    
    func cannotFindLocaitonAlert() {
        self.alert.title = "Invalid Entry"
        self.alert.message = "Oops!  We couldn't find that location! Please enter another location and try again."
        
        self.addAction()
    }
    
    func callDataStoreWithLocation(location: CLLocationCoordinate2D) {
        
        self.activityIndicator.startAnimating()
        
        self.store.getRepositoriesWithCompletion(location.latitude, long: location.longitude, completion: {[weak self] in
            if self?.store.repositories.count == 0 {
                self?.noDataRepositoryAction()
            } else {
                self?.dataSuccessRepositoryAction()
            }
        })
        
    }
    
    func findMyLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func getCurrentLocationPressed(_ sender: AnyObject) {
        self.findMyLocation()
        
        let currentLocation = self.locationManager.location
        
        if currentLocation != nil {
            if let coordinate = currentLocation?.coordinate {
                self.callDataStoreWithLocation(location: coordinate)
            }
        } else {
            self.locationServicesNotEnabledAlert()
        }
        
    }
    
    @IBAction func submitButtonPressed(_ sender: AnyObject) {
        
        if let queryTextField = self.queryTextField.text {
            
            CLGeocoder().geocodeAddressString(queryTextField, completionHandler: {[weak self] (placemarks, error) in
                
                if error != nil {
                    OperationQueue.main.addOperation({
                        self?.cannotFindLocaitonAlert()
                    })
                }
                
                let placemark = placemarks?.last
                
                if let coordinate = placemark?.location?.coordinate {
                    self?.geocodedCoordinate = coordinate
                }
                
                if let coordinate = self?.geocodedCoordinate {
                    self?.callDataStoreWithLocation(location: coordinate)
                }
                
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
