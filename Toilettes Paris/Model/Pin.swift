//
//  Pin.swift
//  Toilettes Paris
//
//  Created by Anthony Laurent on 24/05/2022.
//

import MapKit
import UIKit

// class with the description of the points of interest
class Pin: NSObject, MKAnnotation {
    enum PinType: String {
        case pmrTrue = "true"
        case pmrFalse = "false"
    }
    let pinType : PinType
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, pmr: PinType) {
        pinType = pmr
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
