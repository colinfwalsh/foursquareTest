//
//  FoursquarePhotoAPIRepository.swift
//  foursquareTest
//
//  Created by Colin Walsh on 10/20/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import Foundation

struct FoursquarePhotoAPIRepository {
    var photoPrefix : String!
    var photoSuffix : String!
    var photoWidth : Int!
    var photoHeight : Int!
    
    init(photoDictionary: NSDictionary) {
        guard let prefix = photoDictionary["prefix"] as? String
            else {print("Could not get prefix")
                  return}
        
        guard let suffix = photoDictionary["suffix"] as? String
            else {print("Could not get suffix")
                  return}
        
        guard let width = photoDictionary["width"] as? Int
            else {print("Could not get photo width")
                  return}
        
        guard let height = photoDictionary["height"] as? Int
            else {print("Could not get photo height")
                  return}
        
        photoPrefix = prefix
        photoSuffix = suffix
        photoWidth = width
        photoHeight = height
        
    }
}
