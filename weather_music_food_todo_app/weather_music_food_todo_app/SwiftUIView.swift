//
//  SwiftUIView.swift
//  weather_music_food_todo_app
//
//  Created by 坂井泰吾 on 2023/05/16.
//

import SwiftUI

struct DogView: View {
    var body: some View {
        Image("inu")
            .resizable()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct DogView_Previews: PreviewProvider {
    static var previews: some View {
        DogView()
    }
}
