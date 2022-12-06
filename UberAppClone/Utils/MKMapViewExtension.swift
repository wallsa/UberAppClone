//
//  MKMapViewExtension.swift
//  UberAppClone
//
//  Created by Wallace Santos on 02/12/22.
//

import Foundation
import MapKit

extension MKMapView {
    func zoomToFit(annotations: [MKAnnotation]){
        var zoomRect = MKMapRect.null
        
        annotations.forEach { annotation in
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            zoomRect = zoomRect.union(pointRect)
        }
        
        let insets = UIEdgeInsets(top: 100, left: 100, bottom: 250, right: 100)
        setVisibleMapRect(zoomRect, edgePadding: insets, animated: true)
    }
    
}
