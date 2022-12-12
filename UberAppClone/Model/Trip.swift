//
//  Trip.swift
//  UberAppClone
//
//  Created by Wallace Santos on 02/12/22.
//

import CoreLocation

enum TripState:Int{
    case requested
    case accepted
    case driverArrived
    case inProgress
    case arrivedAtDestination
    case completed
}

struct Trip {
    
    var pickupCoordinates:CLLocationCoordinate2D!
    var destinationCoordinates:CLLocationCoordinate2D!
    let passengerUId:String!
    var driverUid:String?
    var state:TripState!
    
    init(passengerUid:String, dictionary:[String:Any]){
        self.passengerUId = passengerUid
        self.driverUid = dictionary["driverUid"] as? String ?? ""
        
        if let pickupCoordinates = dictionary["pickupCoordinates"] as? NSArray{
            if let lat = pickupCoordinates[0] as? CLLocationDegrees, let long = pickupCoordinates[1] as? CLLocationDegrees{
                self.pickupCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
            }
            
        }
        if let destinationCoordinates = dictionary["destinationCoordinates"] as? NSArray{
            if let lat = destinationCoordinates[0] as? CLLocationDegrees, let long = destinationCoordinates[1] as? CLLocationDegrees{
                self.destinationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
            }
            
            if let state = dictionary["state"] as? Int {
                self.state = TripState(rawValue: state)
            }
        }
    }
    
}
