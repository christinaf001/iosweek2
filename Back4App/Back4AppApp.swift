//
//  Back4AppApp.swift
//  Back4App
//
//  Created by cecetoni on 10/3/25.
//

import SwiftUI
import Parse

@main
struct Back4AppApp: App {

    init() {
        // Initialize Parse
        let parseConfig = ParseClientConfiguration {
            $0.applicationId = "YOUR_APP_ID"        // Replace
            $0.clientKey = "YOUR_CLIENT_KEY"       // Replace
            $0.server = "https://YOUR_PARSE_SERVER/parse" // Replace
        }
        Parse.initialize(with: parseConfig)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
