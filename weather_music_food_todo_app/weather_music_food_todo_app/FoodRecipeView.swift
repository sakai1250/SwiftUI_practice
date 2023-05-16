//
//  FoodRecipeView.swift
//  weather_music_food_todo_app
//
//  Created by 坂井泰吾 on 2023/05/17.
//

import SwiftUI
import Alamofire


struct FoodRecipeResponse: Codable {
    struct Result: Codable {
        let foodImageUrl: String
    }
    
    let result: [Result]
}
struct FoodRecipeView: View {
    @State private var ImageUrl: [String] = []


    var body: some View {
        VStack {
            List(ImageUrl, id: \.self) { _url in
                AsyncImage(url: URL(string: _url))
                    .padding()
                    .cornerRadius(8)
                    .padding(.horizontal)
            }

        }
        .onAppear {
            fetchData()
        }
    }

    func fetchData() {
        let url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?applicationId=1088202091947710174&categoryId=30"

        AF.request(url)
            .validate()
            .responseDecodable(of: FoodRecipeResponse.self) { response in
                switch response.result {
                case .success(let FoodRecipeResponse):
                    ImageUrl = FoodRecipeResponse.result.map { result in return result.foodImageUrl
                    }
                    print(ImageUrl)

                case .failure(let error):
                    print(error)
                }
            }
    }
}
    
    
struct FoodRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        FoodRecipeView()
    }
}
