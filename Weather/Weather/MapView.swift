//
//  MapView.swift
//  Weather
//
//  Created by jimmy233 on 2017/12/25.
//  Copyright © 2017年 NJU. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import UIKit
class MapView:UIViewController,CLLocationManagerDelegate
{
    let managera=CLLocationManager()
    @IBOutlet weak var map: MKMapView!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location=locations[0]
        let span:MKCoordinateSpan=MKCoordinateSpanMake(0.1,0.1)
        let myloc:CLLocationCoordinate2D=CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion=MKCoordinateRegionMake(myloc, span)
        map.setRegion(region, animated: true)
        self.map.showsUserLocation=true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        managera.delegate=self
    managera.desiredAccuracy=kCLLocationAccuracyBest
        managera.requestWhenInUseAuthorization()
        managera.startUpdatingLocation()
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
