//
//  ViewController.swift
//  MapboxDemo
//
//  Created by RnD on 10/21/20.
//

import UIKit
import Mapbox

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMap()
    }

    func addMap() {
        let url = URL(string: "mapbox://styles/arghh/cknust6o714gr17mw19i8xh9i")
        let latitude = 61.607314
        let longitude = -125.733953
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // Add a map
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setCenter(CLLocationCoordinate2D(latitude: latitude, longitude: longitude - 0.005071), zoomLevel: 14.0, animated: false)
        
        view.addSubview(mapView)
        
        // Add point annotation
        let annotation = MGLPointAnnotation()
        annotation.coordinate = location
        annotation.title = "R&D HQ"
        annotation.subtitle = "All things sweet"
        mapView.addAnnotation(annotation)
    }

}

extension ViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 4500, pitch: 15, heading: 180)
        mapView.fly(to: camera, withDuration: 3, peakAltitude: 3000, completionHandler: nil)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        let jsonUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "features", ofType: "geojson")!)
        
        let source = MGLShapeSource(identifier: "trees", url: jsonUrl, options: nil)
        style.addSource(source)
        
        style.addPoints(from: source)
    }
}

extension MGLStyle {
    func addPoints(from source: MGLShapeSource) {
        let circleLayer = MGLCircleStyleLayer(identifier: "trees", source: source)
        circleLayer.circleColor = NSExpression(forConstantValue: UIColor.systemGreen)
        circleLayer.circleStrokeWidth = NSExpression(forConstantValue: 2)
        circleLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.black)
        addLayer(circleLayer)
    }

}
