//
//  ViewController.swift
//  Mapa
//
//  Created by Gerardo Valencia on 1/17/16.
//  Copyright © 2016 Gerardo Valencia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var Mapa: MKMapView!
    
    let manejador = CLLocationManager()
    
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var distancia : Double = 0
    var lastDistance : Double = 0
    var totalDistance : Double = 0
    let regionRadius: CLLocationDistance = 1500
    
    
    @IBAction func Standard()
    {
        Mapa.mapType = MKMapType.Standard
    }
    
    @IBAction func Satelite()
    {
        Mapa.mapType = MKMapType.Satellite
    }
    
    @IBAction func Hibrido()
    {
        Mapa.mapType = MKMapType.Hybrid
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestAlwaysAuthorization()
        manejador.requestWhenInUseAuthorization()
        
        manejador.distanceFilter = 5
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        Mapa.setRegion(coordinateRegion, animated: true)
        
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        
        if(status == .AuthorizedWhenInUse)
        {
            manejador.startUpdatingLocation()
            Mapa.showsUserLocation = true
            
        }
        else
        {
            manejador.stopUpdatingLocation()
            Mapa.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if startLocation == nil
        {
            self.startLocation = locations.first
            
            let centro = CLLocation(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
            
            centerMapOnLocation(centro)
        }
        else
        {
            
            if (self.distancia >= 50)
            {
                var punto = CLLocationCoordinate2D()
                punto.latitude = manager.location!.coordinate.latitude
                punto.longitude = manager.location!.coordinate.longitude
                
                let pin = MKPointAnnotation()
                
                let lat : Double = round(1000000*(manager.location!.coordinate.latitude))/1000000
                let lon : Double = round(1000000*(manager.location!.coordinate.longitude))/1000000
                
                pin.title = "Lat:" + "\(lat)" + " " + "Lon:" + "\(lon)"
                
                totalDistance = round(100*totalDistance)/100
                
                pin.subtitle = "Distancia Recorrida:" + " " + "\(self.totalDistance)"
                pin.coordinate = punto
                
                Mapa.addAnnotation(pin)
                
                self.distancia = 0
                
            }
            
            self.lastLocation = locations.last!
            self.lastDistance = self.startLocation.distanceFromLocation(self.lastLocation)
            self.startLocation = self.lastLocation
            self.distancia += self.lastDistance
            self.totalDistance += self.lastDistance
            
            

        }
        
        
        
        //distancia = locations.first!.distanceFromLocation(locations.last! as CLLocation)
        
        
    }
    
    /*
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        let alerta = UIAlertController(title: "Error", message: "No se pudo iniciar aplicacion", preferredStyle: .Alert)
        let accionOK = UIAlertAction(title: "OK", style: .Default, handler:
            { accion in
             //..
        })
        
        alerta.addAction(accionOK)
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

