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
                clusteringIdentifier = "Pin"
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
                leftCalloutAccessoryView = setupLeft()
            }
        }
    }
    
    func setupLeft() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setImage(UIImage(named: "distance"), for: .normal)
        button.addTarget(self, action: #selector(gps), for: .touchUpInside)
        return button
    }
    
    @objc func gps() {
        guard let anno = annotation as? Pin else { return }
        let placemark = MKPlacemark(coordinate: anno.coordinate)
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let map = MKMapItem(placemark: placemark)
        map.openInMaps(launchOptions: options)
    }
    
}
