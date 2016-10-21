//
//  FoursquareAPIDataStore.swift
//  foursquareTest
//
//  Created by Colin Walsh on 10/18/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import UIKit
import Foundation

class FoursquareAPIDataStore: NSObject {
    
    static let sharedInstance = FoursquareAPIDataStore()
    
    var repositories : [FoursquareAPIRepository] = []
    
    var categoryArray : [String] = []
    
    let callAPI = FoursquareAPIClient()
    
    var photoArray : [FoursquarePhotoAPIRepository] = []
    
    func getPhotoRepositoriesWithCompletion(venueId: String, completion: @escaping () -> ()) {
        
        
        
        self.callAPI.getPhotoData(venueId: venueId, completion: {(responseDictionary) in
            self.photoArray.removeAll()
            
            if let responseDictionary = responseDictionary["response"] as? NSDictionary {
                if let photos = responseDictionary["photos"] as? NSDictionary {
                    if let items = photos["items"] as? NSArray {
                        
                        var i = 0
                        
                        while i < items.count {
                            if let itemsDictionary = items[i] as? NSDictionary {
                                
                                
                                let repository = FoursquarePhotoAPIRepository.init(photoDictionary: itemsDictionary)
                                
                               
                                self.photoArray.append(repository)
                                
                                
                            }
                            
                            i += 1
                        }
                    }
                }
            }
            
            completion()
        })
        
    }
    
    func getRepositoriesWithCompletion(_ lat: Double, long: Double, completion: @escaping () -> ()) {
        
        
        self.callAPI.getAPIData(lat, long: long, completion: {(dictionary) in
            self.repositories.removeAll()
            
            if let responseDictionary = dictionary["response"] as? NSDictionary {
                if let venueArray = responseDictionary["venues"] as? NSArray {
                    for venue in venueArray {
                        if let venueItem = venue as? NSDictionary {
                            
                            
                            let repository = FoursquareAPIRepository.init(venueDictionary: venueItem)
                            
                            let repositoryName = repository.venueCategories["name"] as? String
                            
                            if let repositoryCharacterCount = repositoryName?.characters.count {
                                if repositoryCharacterCount > 0 {
                                    if let repositoryStats = repository.venueStats {
                                        if let repositoryStatsCheckInCount = repositoryStats["checkinsCount"] as? Int {
                                            if repositoryName != "City" && repositoryStatsCheckInCount > 15 {
                                                self.repositories.append(repository)
                                                if let repositoryCategoryName = repositoryName {
                                                    self.categoryArray.append(repositoryCategoryName)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            
            self.repositories.sort{$0.venueDistance < $1.venueDistance}
            
            completion()
            
            
            
        })
    }
    
}




