//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Crispin Lloyd on 19/10/2017.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


    class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {


    //Variable for MKMapView object
    var mapView: MKMapView!

    //Variable to hold Array to hold MKAnnotation objects
    var pinsArray: [MKPointAnnotation]!

    //Create CLLocationCoordinate2D objects
    var homeCordinates: CLLocationCoordinate2D!
    var bornCoordinates: CLLocationCoordinate2D!
    var interestingCoordinates: CLLocationCoordinate2D!

    //Create variables for MKPointAnnotation objects
    var homePointAnnotation: MKPointAnnotation!
    var bornPointAnnotation: MKPointAnnotation!
    var interestingPointAnnotation: MKPointAnnotation!

    //Integer variable to enable cycling through annotations
    var selectAnnotation: Int = 0


    //Create CLLocationManger Object
    let locationManager = CLLocationManager ()

    func CreateAnnotations() {
    //Create CLLocationCoordinate2D objects
     homeCordinates = CLLocationCoordinate2D(latitude: 53.5689, longitude:-2.8851)
     bornCoordinates = CLLocationCoordinate2D(latitude: 53.4084, longitude: -2.9916)
     interestingCoordinates = CLLocationCoordinate2D(latitude: 34.6644, longitude: 32.7068)
        
        

    //Create MKPointAnnotation objects
    homePointAnnotation = MKPointAnnotation()
    bornPointAnnotation = MKPointAnnotation()
    interestingPointAnnotation = MKPointAnnotation()
    homePointAnnotation.coordinate = homeCordinates
    homePointAnnotation.title = "Home Annotation"
    homePointAnnotation.subtitle = "I live here"
    bornPointAnnotation.coordinate = bornCoordinates
    bornPointAnnotation.title = "Born Annotation"
    bornPointAnnotation.subtitle = "I was born here"
    interestingPointAnnotation.coordinate = interestingCoordinates
    interestingPointAnnotation.title = "Interesting Annotation"
    interestingPointAnnotation.subtitle = "I visited here"

        
    //Add MKPointAnnotation objects to pinsArray
    pinsArray = [homePointAnnotation]
    pinsArray.append(bornPointAnnotation)
    pinsArray.append(interestingPointAnnotation)

    }






    override func loadView() {
        //Create a map view
        mapView = MKMapView()
        
        //Set it as "the" view of this view controller
        view = mapView
        
        //Make MapViewContoller delegate for mapView
        mapView.delegate = self
        
        //Make MapViewContoller delegate for locatioManager
        locationManager.delegate = self

        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_segControl:)), for: .valueChanged)
     
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        //Create button for the user to tap show their current location
        let currentLocationButton = UIButton()
        //let buttonFrame = CGRect(x: 0, y: 0, width: 1000, height: 50)
        //currentLocationButton.titleLabel?.frame = buttonFrame
        currentLocationButton.layer.cornerRadius = 2
        currentLocationButton.setTitle("Current Location", for: .normal)
        currentLocationButton.titleLabel?.font = UIFont(name: "HelveticaNeue" , size: 14)
        currentLocationButton.setTitleColor(_: UIColor.blue,for: .normal)
        currentLocationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        currentLocationButton.setTitleColor(_: UIColor.white,for: .highlighted)
        
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(currentLocationButton)
        
        //Create button for the user to tap show their current location
        let droppingPinsButton = UIButton()
        //let buttonFrame = CGRect(x: 0, y: 0, width: 1000, height: 50)
        //droppingPinsButton.titleLabel?.frame = buttonFrame
        droppingPinsButton.layer.cornerRadius = 2
        droppingPinsButton.setTitle("Pin Locations", for: .normal)
        droppingPinsButton.titleLabel?.font = UIFont(name: "HelveticaNeue" , size: 14)
        droppingPinsButton.setTitleColor(_: UIColor.blue,for: .normal)
        droppingPinsButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        droppingPinsButton.setTitleColor(_: UIColor.white,for: .highlighted)
        
        droppingPinsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(droppingPinsButton)
        
        //Link currentButton touchdown event with event handler
        currentLocationButton.addTarget(self, action: #selector(MapViewController.currentLocationButtonDown(_Button:)), for: .touchDown)
        
        //Link currentButton touchup event with event handler
        currentLocationButton.addTarget(self, action: #selector(MapViewController.currentLocationButtonTapUp(_Button:)), for: .touchUpInside)

        //Link currentButton touchdown event with event handler
        droppingPinsButton.addTarget(self, action: #selector(MapViewController.droppingPinsButtonTapDown(_Button:)), for: .touchDown)
        
        //Link currentButton touchup event with event handler
        droppingPinsButton.addTarget(self, action: #selector(MapViewController.droppingPinsButtonTapUp(_Button:)), for: .touchUpInside)

        
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        //let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2)
        //let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -2)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        let topcurrentLocationButtonConstraint = currentLocationButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10)
        let leadingcurrentLocationButtonConstraint = currentLocationButton.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor)
        let widthcurrentLocationButtonConstraint = currentLocationButton.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 0.333)
        
        topcurrentLocationButtonConstraint.isActive = true
        leadingcurrentLocationButtonConstraint.isActive = true
        widthcurrentLocationButtonConstraint.isActive = true
        
        let topdroppingPinsButtonConstraint = droppingPinsButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10)
        let leadingdroppingPinsButtonConstraint = droppingPinsButton.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor)
        let widthdroppingPinsButtonConstraint = droppingPinsButton.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 0.333)
        
        topdroppingPinsButtonConstraint.isActive = true
        leadingdroppingPinsButtonConstraint.isActive = true
        widthdroppingPinsButtonConstraint.isActive = true

        
        //Attempt to start location services
        enableBasicLocationServices()
        
        
        //Start tracking the user's location
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        //Create annotations
        CreateAnnotations()
        
        //Add the MKPointAnnotations to the MapView
        mapView.addAnnotations(pinsArray)
        print(mapView.annotations)
        
    }


    @objc func mapTypeChanged(_segControl: UISegmentedControl) {
        switch _segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view.")
        
    }

    //Function to enable Location Services
    func enableBasicLocationServices() {
        //Test Current Authorization status
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            //request when-in-use authorization
           locationManager.requestWhenInUseAuthorization()
            break
            
        case .denied, .restricted:
            //Location Services denied or restricted by user
            print("Location Services denied or restricted by user request authorization stage")
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
          startRecievingLocationServices ()
            break
        }
        
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //Test Authorization status
        switch status {
        
        case .restricted, .denied:
        print("Location Services denied or restricted by user request authorization update stage")
        break
        
        case .authorizedWhenInUse, .authorizedAlways:
        startRecievingLocationServices ()
        break
        
        case .notDetermined:
            print("authorization request update .notDetermined")
            break
            
        
        }
        
    }


    //Function to start location services
    func startRecievingLocationServices (){
        //Get authorization status for locationManager
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            //Request authorization from the user
            
        }
        
        //Check if Location Services are enabled
        if !CLLocationManager.locationServicesEnabled() {
            //Location Services disabled or unavailable
            
            print("Location Services disabled")
            return
        }
       //Configure and start the Standard location service
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.00
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
    }

       
    //Function for currentButton touchdown event
        @objc func currentLocationButtonDown(_Button: UIButton) {
        //Change the colour button when tapped
        _Button.isHighlighted = true
        _Button.backgroundColor = UIColor.blue
        
        //Zoom in on the user's location
        let userCoordinates = CLLocationCoordinate2D(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        let userzoomSpan = MKCoordinateSpanMake(0.4,0.4)
        let userzoomRegion = MKCoordinateRegion(center: userCoordinates, span: userzoomSpan)
        mapView.setRegion(userzoomRegion, animated: true)
        
        
    }

    //Function for currentButton touchup event
    @objc func currentLocationButtonTapUp(_Button: UIButton) {
        //Change the colour button when tapped
        _Button.isHighlighted = false
        _Button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
    }
        //Function for currentButton touchdown event
        @objc func droppingPinsButtonTapDown(_Button: UIButton) {
            //Change the colour button when tapped
            _Button.isHighlighted = true
            _Button.backgroundColor = UIColor.blue
            
            //Reset selectAnnotation to 1 if value has reached 4
            if selectAnnotation == 3  {
                selectAnnotation = 0
            }
            
            //Variable to reference current annotation
            let currentAnnotation = pinsArray[selectAnnotation]
            let mapAnnotations: [MKAnnotation]
            mapAnnotations = mapView.annotations
            
            //Use value of selectAnnotation variable to set annotation
            let zoomSpan = MKCoordinateSpanMake(0.4,0.4)
            let zoomRegion = MKCoordinateRegion(center: currentAnnotation.coordinate, span: zoomSpan)
            mapView.setRegion(zoomRegion, animated: true)
            
            //Increase selectAnnotation variable
            selectAnnotation += 1
    }
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Check if the annotation is the user's location
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinView: MKPinAnnotationView
        
        //Check if an existing pin view is available
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "customPinAnnotationView") {
            pinView.annotation = annotation
            
            
            } else {
            //If an existing pin view is not available then create one
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotationView")
            pinView.pinTintColor = UIColor .purple
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            
            return pinView
        }
        
        return nil
    }
        
        

        
    //Function for droppingPinsButton touchup event
        @objc func droppingPinsButtonTapUp(_Button: UIButton) {
            //Change the colour button when tapped
            _Button.isHighlighted = false
            _Button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
       
    }
    }

