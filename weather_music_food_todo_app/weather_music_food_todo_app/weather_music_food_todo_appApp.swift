//
//  weather_music_food_todo_appApp.swift
//  weather_music_food_todo_app
//
//  Created by 坂井泰吾 on 2023/05/16.
//

import SwiftUI

@main
struct weather_music_food_todo_appApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
