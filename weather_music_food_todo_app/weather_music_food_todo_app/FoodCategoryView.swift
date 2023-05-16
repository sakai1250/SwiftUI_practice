//
//  FoodCategoryView.swift
//  weather_music_food_todo_app
//
//  Created by 坂井泰吾 on 2023/05/17.
//

import SwiftUI
import Alamofire


struct FoodResponse: Codable {
    struct Result: Codable {
        let large: [Large]
        let medium: [Medium]
        let small: [Small]

        struct Large: Codable {
            let categoryName: String
        }
        struct Medium: Codable {
            let categoryName: String
        }
        struct Small: Codable {
            let categoryName: String
        }
    }
    
    let result: Result
}

struct FoodCategoryView: View {
    @State private var largeCategory: [String] = []
    @State private var mediumCategory: [String] = []
    @State private var smallCategory: [String] = []

    var body: some View {
        VStack {
            List(largeCategory, id: \.self) { name in
                Text(name)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            List(mediumCategory, id: \.self) { name in
                Text(name)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            List(smallCategory, id: \.self) { name in
                Text(name)
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
        let url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryList/20170426?applicationId=1088202091947710174"

        AF.request(url)
            .validate()
            .responseDecodable(of: FoodResponse.self) { response in
                switch response.result {
                case .success(let FoodResponse):
                    largeCategory = FoodResponse.result.large.map { large in return large.categoryName
                    }
                    mediumCategory = FoodResponse.result.medium.map { medium in return medium.categoryName
                    }
                    smallCategory = FoodResponse.result.small.map { small in return small.categoryName
                    }

                    print(largeCategory)
                    print(mediumCategory)
                    print(smallCategory)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
struct FoodCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        FoodCategoryView()
    }
}
