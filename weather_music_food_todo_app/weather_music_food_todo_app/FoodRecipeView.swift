//
//  FoodRecipeView.swift
//  weather_music_food_todo_app
//
//  Created by 坂井泰吾 on 2023/05/17.
//

import SwiftUI
import Alamofire
import Foundation

struct FoodResponse: Codable {
    struct Result: Codable {
        struct Large: Codable {
            let categoryName: String
        }
        struct Medium: Codable {
            let categoryName: String
        }
        struct Small: Codable {
            let categoryName: String
            let categoryUrl: String

        }
        let large: [Large]
        let medium: [Medium]
        let small: [Small]
    }
    let result: Result
}


struct FoodRecipeResponse: Codable {
    struct Result: Codable {
        let foodImageUrl: String
        let recipeMaterial: [String]
        let recipeTitle: String
        let recipeUrl: String
    }
    let result: [Result]
}




struct FoodRecipeView: View {
    @State private var isButtonPressed: Bool = false
    @State private var ImageUrls: [String] = []
    @State private var ImageUrl: String = ""
    @State private var Materials: [[String]] = []
    @State private var Material: [String] = []
    @State private var RecipeUrls: [String] = []
    @State private var RecipeUrl: String = ""
    @State private var RecipeTitles: [String] = []
    @State private var RecipeTitle: String = ""
    @State private var inputText: String = ""
    @State private var combinedText: String = ""
    @State private var recipes: [String] = []
    @State private var randomIndex: Int = 0
    @State private var Id: [String] = []
    @State private var extractedValues: [String] = []
    @State private var Category: [String] = []
    @State private var dict: [String: String] = [:]
    @State private var randId: String = ""

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text("画像タップで楽天レシピに移動")
                TextField("Enter text", text: $inputText)
                    .keyboardType(.default)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    fetchData()
                    isButtonPressed.toggle()
                }) {
                    Text("InputText")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Text(inputText)
            }
            VStack {
                Text(RecipeTitle)
                  .font(.title)
                AsyncImage(url: URL(string: ImageUrl)){ image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                        } placeholder: { ProgressView()
                    }.frame(width: 400, height: 400)
                    .onTapGesture {
                        // 画像がタップされたらHTMLサイトに移動する
                        if let url = URL(string: RecipeUrl) {
                            UIApplication.shared.open(url)
                        }
                    }
            }
            VStack {
                Text("〜材料〜\n")
                    .font(.title)
                ForEach(Material, id: \.self) { material in
                    Text(material)
                    }
                }
            }
        .onAppear {
            fetchdictionary()
            fetchData()
            }
    }

    func fetchData() {
        var url = ""
        
        if inputText.isEmpty {
            let randIds = extractedValues.shuffled()
            randId = randIds.first ?? "10"
//            print(randId)
//            print(dict)
            url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?applicationId=1088202091947710174&categoryId=" + randId
        }
//        空欄ではないとき
        else {
            let filteredValues = dict.filter { key, _ in key.contains(inputText) }.values
//            見つからなかったとき
            if filteredValues.isEmpty {
                let randIds = extractedValues.shuffled()
                randId = randIds.first ?? "10"
//                print(randId)
                url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?applicationId=1088202091947710174&categoryId=" + randId
            }
            else {
                randId = filteredValues.first ?? "10"
//                print(randId)
                url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?applicationId=1088202091947710174&categoryId=" + randId
            }
        }
        sleep(1)
        AF.request(url)
            .validate()
            .responseDecodable(of: FoodRecipeResponse.self) { response in
                switch response.result {
                case .success(let FoodRecipeResponse):
//                    レシピ画像
                    ImageUrls = FoodRecipeResponse.result.map { result in return result.foodImageUrl
                    }
                    let randomIndex = ImageUrls.indices.randomElement() ?? 0
                    ImageUrl = ImageUrls[randomIndex]
//                    材料
                    Materials = FoodRecipeResponse.result.map { result in return result.recipeMaterial
                    }
                    Material = Materials[randomIndex]
//                    レシピ名
                    RecipeTitles = FoodRecipeResponse.result.map { result in return result.recipeTitle
                    }
                    RecipeTitle = RecipeTitles[randomIndex]
//                    レシピサイトURL
                    RecipeUrls = FoodRecipeResponse.result.map { result in return result.recipeUrl
                    }
                    RecipeUrl = RecipeUrls[randomIndex]

//                    print(RecipeTitle)

                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func fetchdictionary() {
        var largeCategory: [String] = []
        var mediumCategory: [String] = []
        var smallCategory: [String] = []

        let url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryList/20170426?applicationId=1088202091947710174"
        sleep(1)
        AF.request(url)
            .validate()
            .responseDecodable(of: FoodResponse.self) { response in switch response.result {
            case .success(let FoodResponse):
                let _result = FoodResponse.result
                largeCategory = _result.large.map { large in return large.categoryName }
                mediumCategory = _result.medium.map { medium in return medium.categoryName }
                smallCategory = _result.small.map { small in return small.categoryName }

                Id = _result.small.map { small in return small.categoryUrl }

                let excludedValues = ["https://recipe.rakuten.co.jp/category/", "/"]
                
                Id.forEach { inputString in
                    var extractedValue = inputString
                    excludedValues.forEach { excludedValue in
                        extractedValue = extractedValue.replacingOccurrences(of: excludedValue, with: "")
                    }
                    extractedValues.append(extractedValue)
                }

                Category = largeCategory + mediumCategory + smallCategory
                dict = Dictionary(zip(Category, extractedValues), uniquingKeysWith: { (first, _) in first })
//                print(dict)
                                
            case .failure(let error):
                print(error)
            }
        }
//        print(dict)
    }
    
}
    
    
struct FoodRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        FoodRecipeView()
    }
}
