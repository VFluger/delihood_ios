//
//  DeliveryAddressChangeView.swift
//  DeliHood
//
//  Created by Vojta Fluger on 17.08.2025.
//

import SwiftUI
import SwiftData
import MapKit

struct LocationListView: View {
    var locationModel: Location
    @Binding var updateSheet: Location?
    var body: some View {
        HStack {
            Label(locationModel.address, systemImage: "mappin.circle")
        }
        .onTapGesture {
            updateSheet = locationModel
        }
    }
}


struct UpdateAddressView: View {
    @Bindable var locationModel: Location
    @Environment(\.dismiss) var dismiss
    
    //A placeholder number, will be set by the swiftdata
    @State private var location = CLLocationCoordinate2D(latitude: 16.12, longitude: 32.123)
    
    //A placeholder number, will be set by the swiftdata
    @State private var cameraPosition:  MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.595,
                                                                                                              longitude: 12.288),
            latitudinalMeters: 200, longitudinalMeters: 200))
    
    @State private var address = ""
    @StateObject var searchModel = LocationSearchService()
    
    var body: some View {
        VStack {
            Text("Edit location")
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
                locationModel.address = address
                locationModel.locationLat = location.latitude
                locationModel.locationLng = location.longitude
                dismiss()
                
            }label: {
                BrandBtn(text: "Save", width: 325)
            }
            .onAppear {
                let lat = locationModel.locationLat
                let lng = locationModel.locationLng
                
                // If user set location, update the location pin and cameraPosition
                location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                
                cameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng), latitudinalMeters: 200, longitudinalMeters: 200))
                
                address = locationModel.address
            }
        }
    }
}

struct AddLocationView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @StateObject var searchModel = LocationSearchService()
    
    //A placeholder number, will be set by the swiftdata
    @State private var location = CLLocationCoordinate2D(latitude: 16.12, longitude: 32.123)
    
    //A placeholder number, will be set by the swiftdata
    @State private var cameraPosition:  MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.595,
                                                                                                              longitude: 12.288),
            latitudinalMeters: 200, longitudinalMeters: 200))
    
    @State private var address = ""
    
    var body: some View {
        VStack {
            Text("Add a new location")
                .font(.title)
                .fontWeight(.semibold)
                .padding()
            Spacer()
            TextField("Address", text: $address)
                .brandStyle(isFieldValid: true)
                .onChange(of: address) {oldValue, newValue in
                    print(newValue)
                    searchModel.handleSearchFragment(newValue)
                }
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
                            .clipShape(Capsule())
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
            ZStack {
                Map(position: $cameraPosition)
                Image(systemName: "mappin")
                    .scaleEffect(2)
                    .foregroundStyle(.white)
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .padding()
            .onMapCameraChange { context in
                location = context.camera.centerCoordinate
            }
            Button {
                let lat = location.latitude
                let lng = location.longitude
                
                let locationModel = Location(id: UUID(), address: address, locationLat: lat, locationLng: lng)
                
                context.insert(locationModel)
                dismiss()
                
            }label: {
                BrandBtn(text: "Save", width: 325)
            }
        }
    }
}
