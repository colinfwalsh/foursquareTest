//
//  FoursquareAPIRepository.swift
//  foursquareTest
//
//  Created by Colin Walsh on 10/18/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import Foundation
import CoreLocation

struct FoursquareAPIRepository {
    
    var venueName: String!
    var venueId : String!
    var venueCategories: NSDictionary!
    var venueLocation: NSDictionary!
    var venueDistance: Int!
    var venueStats: NSDictionary!
    
    init(venueDictionary: NSDictionary) {
        guard let name = venueDictionary["name"] as? String
            else {print("couldn't get name")
                return}
        
        guard let id = venueDictionary["id"] as? String
            else {print("Couldn't get venue ID")
                return}
        
        guard let categoriesArray = venueDictionary["categories"] as? NSArray
            else {print("Couldn't get categories")
                return}
        
        
        if categoriesArray.count != 0 {
            guard let categoriesDictionary = categoriesArray[0] as? NSDictionary
                else{print("Couldn't convert value")
                    return}
            venueCategories = categoriesDictionary
        } else {
            venueCategories = [:]
        }
        
        guard let location = venueDictionary["location"] as? NSDictionary
            else {print("Couldn't get location")
                return}
        
        if location.count != 0 {
            guard let distance = location["distance"] as? Int
                else {print("Couldn't go the distance")
                    return}
            
            venueDistance = distance
        } else {
            venueDistance = 0}
        
        guard let stats = venueDictionary["stats"] as? NSDictionary
            else {print("Couldn't get stats")
                return}
        
        
        venueName = name
        venueId = id
        venueLocation = location
        venueStats = stats
        
    }
}
