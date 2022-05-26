//
//  PinAnnotationView.swift
//  Toilettes Paris
//
//  Created by Anthony Laurent on 26/05/2022.
//

import MapKit

class PinAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            if let pin = newValue as? Pin {
                switch pin.pinType {
                case .pmrTrue:
                    markerTintColor = UIColor.red
                    glyphText = "🦽"
                case .pmrFalse:
                    markerTintColor = UIColor.blue
                    glyphText = "🚽"
                }
                canShowCallout = true
                calloutOffset = CGPoint(x: -5, y: 5)
                rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        }
    }
    
}
