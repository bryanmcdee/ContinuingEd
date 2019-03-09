//
//  ViewController.swift
//  Project19
//
//  Created by Bryan McDonald on 7/29/15.
//  Copyright (c) 2015 Bryan McDonald. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCapitals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addCapitals(){
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        // 1. Define a reuse identifier. This is a string that will be used to ensure we reuse annotation views as much as possible.
        let identifier = "Capital"
        
        // 2. Check whether the annotation we're creating a view for is one of our Capital objects.
        if annotation.isKindOfClass(Capital.self) {
            // 3. Try to dequeue an annotation view from the map view's pool of unused views.
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                //4. If it isn't able to find a reusable view, create a new one using MKPinAnnotationView and sets its canShowCallout property to be true. This triggers the popup with the city name.
                annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
                annotationView.canShowCallout = true
                
                // 5. Create a new UIButton using the built-in .DetailDisclosure type. This is a small blue "i" symbol with a circle around it.
                let btn = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
                annotationView.rightCalloutAccessoryView = btn
            } else {
                // 6. If it can reuse a view, update that view to use a different annotation.
                annotationView.annotation = annotation
            }
            
            return annotationView
        }
        
        // 7. If the annotation isn't from a capital city, it must return nil so iOS uses a default view.
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let capital = view.annotation as! Capital
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }

}

