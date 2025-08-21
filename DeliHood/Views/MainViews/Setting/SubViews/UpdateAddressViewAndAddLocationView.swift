//
//  DeliveryAddressChangeView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.08.2025.
//

import SwiftUI
import SwiftData
import MapKit

struct LocationEditorView: View {
    let title: String
    @State private var address: String
    @State private var location: CLLocationCoordinate2D
    @State private var cameraPosition: MapCameraPosition
    @StateObject private var searchModel = LocationSearchService()
    let saveAction: (String, CLLocationCoordinate2D) -> Void
    @Environment(\.dismiss) private var dismiss
    
    init(title: String,
         initialAddress: String,
         initialLocation: CLLocationCoordinate2D,
         saveAction: @escaping (String, CLLocationCoordinate2D) -> Void) {
        self.title = title
        self._address = State(initialValue: initialAddress)
        self._location = State(initialValue: initialLocation)
        self._cameraPosition = State(initialValue: .region(MKCoordinateRegion(center: initialLocation, latitudinalMeters: 200, longitudinalMeters: 200)))
        self.saveAction = saveAction
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
                .padding()
            Spacer()
            TextField("Address", text: $address)
                .brandStyle(isFieldValid: true)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onChange(of: address) { oldValue, newValue in
                    searchModel.handleSearchFragment(newValue)
                }
            //Suggestion on addresses
            if !searchModel.results.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(searchModel.results) { result in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(result.title)
                                    .font(.headline)
                                Text(result.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                            .onTapGesture {
                                address = result.title
                                searchModel.selectResult(result) { coordinate in
                                    if let coordinate = coordinate {
                                        DispatchQueue.main.async {
                                            location = coordinate
                                            cameraPosition = .region(MKCoordinateRegion(center: location, latitudinalMeters: 200, longitudinalMeters: 200))
                                            searchModel.results = []
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 150) // limits the height so it doesn't take too much space
            }
            
            //Map with pin on ZStack
            ZStack {
                Map(position: $cameraPosition)
                Image(systemName: "mappin")
                    .scaleEffect(2)
                    .foregroundStyle(.black)
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .padding()
            .onMapCameraChange { context in
                location = context.camera.centerCoordinate
            }
            Button {
                saveAction(address, location)
                dismiss()
            } label: {
                BrandBtn(text: "Save", width: 325)
            }
        }
    }
}

struct UpdateAddressView: View {
    @Bindable var locationModel: Location
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        LocationEditorView(
            title: "Edit location",
            initialAddress: locationModel.address,
            initialLocation: CLLocationCoordinate2D(latitude: locationModel.locationLat, longitude: locationModel.locationLng),
        ) { address, location in
            locationModel.address = address
            locationModel.locationLat = location.latitude
            locationModel.locationLng = location.longitude
        }
    }
}

struct AddLocationView: View {
    @Environment(\.modelContext) var context
    
    var body: some View {
        LocationEditorView(
            title: "Add a new location",
            initialAddress: "",
            initialLocation: CLLocationCoordinate2D(latitude: 16.12, longitude: 32.123),
        ) { address, location in
            let locationModel = Location(id: UUID(), address: address, locationLat: location.latitude, locationLng: location.longitude)
            context.insert(locationModel)
        }
    }
}
