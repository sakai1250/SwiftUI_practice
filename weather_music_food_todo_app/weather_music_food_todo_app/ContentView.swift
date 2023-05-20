//
//  ContentView.swift
//  weather_music_food_todo_app
//
//  Created by 坂井泰吾 on 2023/05/16.
//

import SwiftUI
import CoreData

struct RoundRectangleButton: View {
    let title: String
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 150, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.blue)
                )
        }
    }
}

struct ContentView: View {
    var body: some View {
            NavigationView {
                VStack(spacing: 20) {
                    TodoView()
                    HStack(spacing: 20) {
                        RoundRectangleButton(title: "Map", destination: AnyView(MapView()))
                        RoundRectangleButton(title: "Dog View", destination: AnyView(DogView()))
                    }
                    HStack(spacing: 20) {
                        RoundRectangleButton(title: "Weather", destination: AnyView(WeatherView()))
                        RoundRectangleButton(title: "Food Recipe", destination: AnyView(FoodRecipeView()))
                    }
                    HStack(spacing: 20) {
                        RoundRectangleButton(title: "Food Recipe", destination: AnyView(FoodRecipeView()))
                        RoundRectangleButton(title: "YouTube Ranking", destination: AnyView(YoutubeRankingView()))
                    }
                }
                .padding()
                .navigationTitle("Home")
            }
    }
}

private let itemFormatter: DateFormatter = {
let formatter = DateFormatter()
formatter.dateStyle = .short
formatter.timeStyle = .medium
return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
