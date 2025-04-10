//
//  CustomPin.swift
//  MyMaps
//
//  Created by Sagar Amin on 3/6/25.
//

import Foundation
import MapKit

struct CustomPin: Identifiable {
    var id: UUID = UUID()
    var coordinate: CLLocationCoordinate2D
    var title: String
}
