//
//  FoursquareAPIClient.swift
//  foursquareTest
//
//  Created by Colin Walsh on 10/18/16.
//  Copyright © 2016 Colin Walsh. All rights reserved.
//

import Foundation

struct FoursquareAPIClient {
    
    /*******************************
     
     This class handles the communication with the FourSquare API, along with parsing the data into usable objects
     
     *******************************/
    
    func getCurrentDate () -> String{
        
        /*******************************
         
         The Foursquare API takes a date formatted as YYYYMMDD as an argument, so this function finds the current date and formats it according to how the argument requires it to be
         
         ********************************/
        
        let date = Date()
        
        let dayTimePeriodFormatter = DateFormatter()
        
        dayTimePeriodFormatter.dateFormat = "yyyyMMdd"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        
        return dateString
        
    }
    
    func getPhotoData (venueId: String, completion: @escaping (NSDictionary) -> ()) {
        
        /*******************************
 
        Pulls data from the FourSquare API for photos in a given venue.  Takes a venue ID String as an argument to pass into the request
 
        *******************************/
        
        let tempOATH = "4A4ZTW0LI5PCZAO0VMCDZQQUAABD52FDLPGEGB4HKUQRMFNO"
        
        guard let url = URL(string: "https://api.foursquare.com/v2/venues/\(venueId)/photos?oauth_token=\(tempOATH)&v=\(self.getCurrentDate())") else {print("Couldn't reach photo URL, try again")
            return}
        
        self.taskForSession(url: url) {(returnedDictionary) in
            completion(returnedDictionary)
        }
        
        
    }
    
    func getAPIData (_ lat: Double, long: Double, completion: @escaping (NSDictionary) -> ()) {
        
        /*******************************
         
         Pulls data from the FourSquare API and passes a NSDictionary if data is able to be received.  Takes lat/long Doubles as arguments
         
         *******************************/
        
        guard let url = URL(string: "https://api.foursquare.com/v2/venues/search?ll=\(lat),\(long)&client_id=\(Secrets().fourSquareClientID)&client_secret=\(Secrets().fourSquareClientSecret)&v=\(self.getCurrentDate())") else {
            print("URL NOT VALID")
            return}
        
        taskForSession(url: url) {(returnedDictionary) in
            completion(returnedDictionary)
        }
        
        
    }
    
    func taskForSession (url: URL, completion: @escaping (NSDictionary) -> ()) {
        
        /*******************************
         
         This method is mainly for reducing redundency.  Takes a URL as an argument and then handles all the heavy lifting in regards to communication with the API, parsing into JSON and returning a readable NSDictionary
         
         *******************************/
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                if let responseDictionary = responseDictionary {
                    completion(responseDictionary)
                }
            }
        }
        
        task.resume()
        
    }
}
