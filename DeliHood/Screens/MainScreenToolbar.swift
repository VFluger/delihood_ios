//
//  MainScreenToolbar.swift
//  DeliHood
//
//  Created by Vojta Fluger on 10.08.2025.
//

import SwiftUI

struct MainScreenToolbar: View {
    var body: some View {
            Button {
                
            }label: {
                Image(systemName: "gear")
            }
    }
}

#Preview {
    NavigationView {
        VStack {
            Text("Screen")
        }
        .toolbar {
            MainScreenToolbar()
        }
    }
}
