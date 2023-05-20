//
//  WeatherView.swift
//  weather_music_food_todo_app
//
//  Created by 坂井泰吾 on 2023/05/17.
//

import SwiftUI
import Alamofire

struct WeatherResponse: Codable {
    struct Description: Codable {
        let text: String
    }
    struct Copyright: Codable {
        let image: Image
        
        struct Image: Codable {
            let url: String
        }
    }
    struct Forecast: Codable {
        let date: String
        let dateLabel: String
        let telop: String
    }
    
    let description: Description
    let copyright: Copyright
    let forecasts: [Forecast]
}

struct WeatherView: View {
    @State private var responseText = ""
    @State private var windData: [String] = []
    @State private var url_sample = ""

    var body: some View {
        VStack {
            Text(responseText)
            AsyncImage(url: URL(string: url_sample))

            List(windData, id: \.self) { wind in
                Text(wind)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
        .onAppear {
            fetchData()
        }
    }

    func fetchData() {
        let url = "https://weather.tsukumijima.net/api/forecast/city/130010"

        AF.request(url)
            .validate()
            .responseDecodable(of: WeatherResponse.self) { response in
                switch response.result {
                case .success(let WeatherResponse):
                    responseText = WeatherResponse.description.text
                    url_sample = WeatherResponse.copyright.image.url
                    windData = WeatherResponse.forecasts.map { forecast in return forecast.telop
                    }
                    print(responseText)
                    print(url_sample)
                    print(windData)
                case .failure(let error):
                    print(error)
                }
            }
    }
}


struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
