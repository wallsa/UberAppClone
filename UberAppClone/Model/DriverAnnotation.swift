//
//  DriverAnnotation.swift
//  UberAppClone
//
//  Created by Wallace Santos on 27/11/22.
//

import MapKit


class DriverAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var uid:String
    
    init (uid: String, coordinate:CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
    }  
}
