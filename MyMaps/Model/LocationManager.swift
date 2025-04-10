//
//  LocationManager.swift
//  MyMaps
//
//  Created by Sagar Amin on 3/6/25.
//

import Foundation
import CoreLocation
import _MapKit_SwiftUI
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var position: MapCameraPosition?
    

    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = lastLocation.coordinate
            self.position = MapCameraPosition.region(
                MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude,
                                                                  longitude: lastLocation.coordinate.longitude),
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    // New Pin
    func convertPointToCoordinate(_ point: CGPoint, region: MKCoordinateRegion) -> CLLocationCoordinate2D {
        let mapWidth = UIScreen.main.bounds.width
        let mapHeight = UIScreen.main.bounds.height
        
        let latitude = region.center.latitude - (Double(point.y / mapHeight) - 0.5) * region.span.latitudeDelta
        let longitude = region.center.longitude + (Double(point.x / mapWidth) - 0.5) * region.span.longitudeDelta
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}

extension MapCameraPosition {
    func getBindingForPosition() -> Binding<MapCameraPosition>? {
        return Binding<MapCameraPosition>(.constant(self))
    }
}
