//
//  LocationSearchService.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.08.2025.
//

import Foundation
import MapKit

//UIKit stuff
class LocationSearchService: NSObject, ObservableObject {
    @Published var results: [LocationResult] = []
    var status: SearchStatus = .idle
    var completer: MKLocalSearchCompleter
    
    init(filter: MKPointOfInterestFilter = .excludingAll,
         region: MKCoordinateRegion = MKCoordinateRegion(
             center: CLLocationCoordinate2D(latitude: 49.8175, longitude: 15.4730),
             span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0) // ONLY CZECH REPUBLIC
         ),
         types: MKLocalSearchCompleter.ResultType = [.address]) { // Just use addresses
        
        completer = MKLocalSearchCompleter()
        
        super.init()
        
        completer.delegate = self
        completer.pointOfInterestFilter = filter
        completer.region = region
        completer.resultTypes = types
    }
    
    func handleSearchFragment(_ fragment: String) {
        self.status = .searching
        self.completer.queryFragment = fragment
    }
}

extension LocationSearchService: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results.map({result in
            return LocationResult(title: result.title, subtitle: result.subtitle)
        })
        
        self.status = .result
    }
    
    func selectResult(_ result: LocationResult, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "\(result.title), \(result.subtitle)"
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.location.coordinate, error == nil else {
                completion(nil)
                return
            }
            completion(coordinate)
        }
    }
}

struct LocationResult: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var subtitle: String
}

enum SearchStatus {
    case idle
    case searching
    case error(String)
    case result
}
