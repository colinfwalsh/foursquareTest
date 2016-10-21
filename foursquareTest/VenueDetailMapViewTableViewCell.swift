//
//  VenueDetailMapViewTableViewCell.swift
//  foursquareTest
//
//  Created by Colin Walsh on 10/21/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit
import MapKit

class VenueDetailMapViewTableViewCell: UITableViewCell, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let mapView = self.mapView {
            mapView.delegate = self
        }
    }
    
    func showLocation(coordinate: CLLocationCoordinate2D, name: String) {
        
        let regionRadius : CLLocationDistance = 1000
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate,
                                                                  regionRadius * 2.0,
                                                                  regionRadius * 2.0)
        
        self.mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
