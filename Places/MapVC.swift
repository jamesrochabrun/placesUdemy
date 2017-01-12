//
//  MapVC.swift
//  Places
//
//  Created by James Rochabrun on 1/10/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var place: Place!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(place.name)
        self.mapView.delegate = self
        self.mapView.showsTraffic = true
        self.mapView.showsScale = true
        self.mapView.showsCompass = true
        self.mapView.showsUserLocation = true
        self.mapView.showsBuildings = true
        self.mapView.showsPointsOfInterest = true
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(place.location) {[unowned self] (placemarks, error) in
            
            if error ==  nil {
                for placemark in placemarks! {
                    print(placemark)
                    let annotation = MKPointAnnotation()
                    annotation.title = self.place.name
                    annotation.coordinate = (placemark.location?.coordinate)!
                    annotation.subtitle = self.place.type
                    
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
                
            } else {
                print("error founded: \(error?.localizedDescription)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension MapVC : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        //if annotation is user blue dot return
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView: MKPinAnnotationView? = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        //callout will be the imageview
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
        imageView.image = UIImage(data: self.place.image as! Data)
        
        annotationView?.leftCalloutAccessoryView = imageView
        annotationView?.pinTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return annotationView
    }
}







