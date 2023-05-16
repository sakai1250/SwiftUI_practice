//
//  MapView.swift
//  weather_music_food_todo_app
//
//  Created by 坂井泰吾 on 2023/05/16.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) ->  MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: 34.011, longitude: -116.166)
        
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        view.setRegion(region, animated: true)
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
