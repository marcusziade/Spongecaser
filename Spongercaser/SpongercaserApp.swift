//
//  SpongercaserApp.swift
//  Spongercaser
//
//  Created by Marcus Ziadé on 10.10.2022.
//

import SwiftUI

@main
struct SpongercaserApp: App {

    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: viewModel)
            #if os(macOS)
                .frame(minWidth: 500, minHeight: 300)
            #endif
        }
    }
}
