//
//  File.swift
//  UberAppClone
//
//  Created by Wallace Santos on 28/11/22.
//

import MapKit

extension MKPlacemark {
    
    var fullAdress:String?{
        get{
            guard let subThoroughfare = subThoroughfare else {return nil}
            guard let thoroughfare = thoroughfare else {return nil}
            guard let locality = locality else {return nil}
            guard let administrativeArea = administrativeArea else {return nil}
            
            return "\(thoroughfare), \(subThoroughfare)  \(locality) - \(administrativeArea)"
        }
    }
}
