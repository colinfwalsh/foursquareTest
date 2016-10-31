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
    
    // MARK: - Properties
    
    static let sharedInstance = FoursquareAPIDataStore()
    
    var repositories : [FoursquareAPIRepository] = []
    
    var categoryArray : [String] = []
    
    let callAPI = FoursquareAPIClient()
    
    var photoArray : [FoursquarePhotoAPIRepository] = []
    
    
    //MARK: - Functions
    
    //Calls the API in order to get the path for the photos of the venues
    
    func getPhotoRepositoriesWithCompletion(venueId: String, completion: @escaping () -> ()) {
        
        //Starts the API call method from the FoursquareAPIClient class
        self.callAPI.getPhotoData(venueId: venueId, completion: {(responseDictionary) in
            //Removes all data from the photoArray in the singleton
            self.photoArray.removeAll()
            
            //Starts optional chaining
            if let responseDictionary = responseDictionary["response"] as? NSDictionary {
                if let photos = responseDictionary["photos"] as? NSDictionary {
                    if let items = photos["items"] as? NSArray {
                        
                        var i = 0
                        
                        //This while loop takes each individual photo, passes it into the Foursquare Repository Object and appends it to the photoArray
                        
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
    
    //Calls the API in order to get the bullk of the data needed
    
    func getRepositoriesWithCompletion(_ lat: Double, long: Double, completion: @escaping () -> ()) {
        
        //Starts the API call method from the FoursquareAPIClient class
        self.callAPI.getAPIData(lat, long: long, completion: {(dictionary) in
            //Clears out the singleton of all data in order to make sure there are not duplicate/extra data displaying in the table
            self.repositories.removeAll()
            
            //Start optional chaining
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
                                                    
                                                    //If all chains succeed, append the data recieved into the categoryArray
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
            
            //Higher order funciton that sorts the repository by the venueDistance property - sorts from smallest to highest
            self.repositories.sort{$0.venueDistance < $1.venueDistance}
            
            //Returns nothing upon completion
            completion()
            
        })
    }
    
}




