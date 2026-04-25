//
//  watchlogApp.swift
//  watchlog
//
//  Created by Juan on 24/4/26.
//

import SwiftUI
import SwiftData

@main
struct watchlogApp: App {
    var shared_container: ModelContainer = {
        let schema = Schema([
            PeliculaLocal.self,
            FavoritoLocal.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(shared_container)
    }
}
