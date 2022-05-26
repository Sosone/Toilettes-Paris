//
//  ViewController.swift
//  Toilettes Paris
//
//  Created by Anthony Laurent on 24/05/2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    // Paris Capitale de la France pour centrer la carte
    var latitudeInit: Double = 48.856614
    var longitudeInit: Double = 2.3522219
    var coordinateInit :  CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitudeInit, longitude: longitudeInit)
    }
    let locationManager = CLLocationManager()
    var userPosition: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(PinAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(PinClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        setup()
        setupLocationManager()
    }
    
    // action sur le segment
    @IBAction func ChangeMapTypeButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : mapView.mapType = MKMapType.standard
        case 1 : mapView.mapType = .satellite
        case 2 : mapView.mapType = .hybrid
        default: break
        }
    }
    
    @IBAction func getPosition(_ sender: Any) {
        print("getPosition")
        if userPosition != nil {
            setupMap(coordonnees: userPosition!.coordinate, myLat: 1, myLong: 1)
        } else {
            print("nil dans getPosition")
        }
    }
    

}

extension ViewController: MKMapViewDelegate {
    func setup() {
        setupMap(coordonnees: coordinateInit, myLat: 3, myLong: 3)
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isRotateEnabled = true
        mapView.addAnnotations(Location.allLocation)
        
        let capitalArea = MKCircle(center: coordinateInit, radius: 10000) // rayon de 10 km
        mapView.addOverlay(capitalArea)
    }
    
    // appellé par le bouton "localise moi"
    func setupMap(coordonnees: CLLocationCoordinate2D, myLat: Double, myLong: Double) {
        let span = MKCoordinateSpan(latitudeDelta: myLat , longitudeDelta: myLong)
        let region = MKCoordinateRegion(center: coordonnees, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    // enrichir les annotations
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let annotation = annotation as? Pin else { return nil }
//        let identifier = "pin"
//        var view: MKMarkerAnnotationView
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        if annotation.pinType.self == .pmrTrue {
//            view.markerTintColor = .blue
//        } else {
//            view.markerTintColor = .red
//        }
//        return view
//    }
    
    // placer le titre et l'info du Pin dans l'alerte
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let pin = view.annotation as? Pin else { return }
        let placeName = pin.title
        let placeInfo = pin.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // définir un overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let capitalAreaRenderer = MKCircleRenderer(circle: overlay as! MKCircle)
        //capitalAreaRenderer.fillColor = UIColor.lightGray
        capitalAreaRenderer.strokeColor = UIColor.lightGray
        return capitalAreaRenderer
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        mapView.camera.heading = newHeading.magneticHeading
        mapView.setCamera(mapView.camera, animated: true)
    }
    
    // si mise à jour des locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if let maPosition = locations.last {
                userPosition = maPosition
            }
        }
    }
    

} // end
