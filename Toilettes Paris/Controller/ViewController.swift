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
    
    // Paris Capital of France to center the map
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
    
    // function to change the style of the map
    @IBAction func ChangeMapTypeButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : mapView.mapType = MKMapType.standard
        case 1 : mapView.mapType = .satellite
        case 2 : mapView.mapType = .hybrid
        default: break
        }
    }
//    function to find yourself on the map
    @IBAction func getPosition(_ sender: Any) {
        print("getPosition")
        if userPosition != nil {
            setupMap(coordinates: userPosition!.coordinate, myLat: 0.02, myLong: 0.02)
        } else {
            print("nil in getPosition")
        }
    }
    
    
}

extension ViewController: MKMapViewDelegate {
    func setup() {
        setupMap(coordinates: coordinateInit, myLat: 0.2, myLong: 0.2)
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.isRotateEnabled = true
        mapView.addAnnotations(Location.allLocation)
        
        let toiletsArea = MKCircle(center: coordinateInit, radius: 1000) // toilets within a radius of one kilometer
        mapView.addOverlay(toiletsArea)
    }
    
    // called by the "locate me" button
    func setupMap(coordinates: CLLocationCoordinate2D, myLat: Double, myLong: Double) {
        let span = MKCoordinateSpan(latitudeDelta: myLat , longitudeDelta: myLong)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    // place title and pin info in alert
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let pin = view.annotation as? Pin else { return }
        let placeName = pin.title
        let placeInfo = pin.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    // function to define a radius of one kilometer around the user
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let toiletsAreaRenderer = MKCircleRenderer(circle: overlay as! MKCircle)
        toiletsAreaRenderer.strokeColor = UIColor.lightGray
        return toiletsAreaRenderer
    }
}

extension ViewController: CLLocationManagerDelegate {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
//    function to make the application point in the same direction as the user
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        mapView.camera.heading = newHeading.magneticHeading
        mapView.setCamera(mapView.camera, animated: true)
    }
    
    // if location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if let maPosition = locations.last {
                userPosition = maPosition
            }
        }
    }
    
} // end
