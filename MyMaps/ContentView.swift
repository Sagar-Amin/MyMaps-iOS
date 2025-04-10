//
//  ContentView.swift
//  MyMaps
//
//  Created by Sagar Amin on 3/6/25.
//

import SwiftUI
import MapKit
import CoreLocation


struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    
    @State private var region = MKCoordinateRegion(
        center: .init(latitude: 51.6514, longitude: -0.27),
        span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    // static custom poins
    @State private var pins : [CustomPin] = [
        CustomPin(id: UUID(),
                  coordinate: CLLocationCoordinate2D(latitude: 51.7514, longitude: -0.275),
                  title: "Pin1"),
        CustomPin(id: UUID(),
                  coordinate: CLLocationCoordinate2D(latitude: 51.8514, longitude: -0.278),
                  title: "Pin2")
    ]
    
    var dynamicPostion: Binding<MapCameraPosition>? {
        guard let location = locationManager.userLocation else {
            return MapCameraPosition.region(region).getBindingForPosition()
        }
        
        let position = MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        
        return position.getBindingForPosition()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let position = dynamicPostion, let currentLocation = locationManager.userLocation {
                    Map(position: position) {
                        // put user location pin
                        Marker("My Location", coordinate: currentLocation)
                        
                        // display static pins and dynamic pins
                        ForEach(pins) { pin in
                            // Marker(pin.title, coordinate: pin.coordinate)
                            Annotation(pin.title, coordinate: pin.coordinate) {
                                ZStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.largeTitle)
                                    
                                }
                            }
                        }
                        
                    }
                    .onTapGesture(coordinateSpace: .local) { position in
                        let coordinate = locationManager.convertPointToCoordinate(position, region: region)
                        let newPin = CustomPin(id: UUID(),
                                               coordinate: coordinate,
                                               title: "New Pin")
                        pins.append(newPin)
                    }
                }
                    
                
            }.ignoresSafeArea()

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
