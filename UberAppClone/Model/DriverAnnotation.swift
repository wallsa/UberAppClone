//
//  DriverAnnotation.swift
//  UberAppClone
//
//  Created by Wallace Santos on 27/11/22.
//

import MapKit


class DriverAnnotation: NSObject, MKAnnotation{
    //Dynamic keyword usada para que a atualizacao da coordenada seja atualizada a medida que mudamos na Database
    dynamic var coordinate: CLLocationCoordinate2D
    var uid:String
    
    init (uid: String, coordinate:CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
    }
    
    func updateAnnotationPosition(withCoordinate coordinate: CLLocationCoordinate2D){
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
    }
}
