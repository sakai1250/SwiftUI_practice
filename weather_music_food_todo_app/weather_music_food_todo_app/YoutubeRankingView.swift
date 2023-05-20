//
//  YoutubeRankingView.swift
//  weather_music_food_todo_app
//
//  Created by 坂井泰吾 on 2023/05/20.
//
import SwiftUI
import Alamofire


struct YoutubeRankingResponse: Codable {
    struct Item: Codable {
        struct Snippet: Codable {
            struct Thumbnails: Codable {
                struct Medium: Codable {
                    let url: String
                }
                let medium: Medium
            }
            let title: String
            let thumbnails:Thumbnails
        }
        let snippet: Snippet
    }
    let items: [Item]
}

struct YoutubeRankingView: View {
    @State private var titl: [String] = []
    @State private var ImageUrl: [String] = []

    var body: some View {
        VStack {
            Text("今週のYoutube再生数Top10(日本)")
            List {
                ForEach(titl.indices, id: \.self) { index in
                    VStack {
                        Text("\(index + 1): \(titl[index])")
                        AsyncImage(url: URL(string: ImageUrl[index]))
                            .padding()
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
            }.onAppear {
                fetchData()
            }
        }
    }
    func fetchData() {
        let url = "https://www.googleapis.com/youtube/v3/videos?part=snippet%2Cstatistics&chart=mostPopular&regionCode=JP&videoCategoryId=10&maxResults=10&key=AIzaSyDtyaj9gSmWQ5p_5t0gA9CQK9M-uGyxLcs"

        AF.request(url)
            .validate()
            .responseDecodable(of: YoutubeRankingResponse.self) { response in
                switch response.result {
                case .success(let YoutubeRankingResponse):
                    titl = YoutubeRankingResponse.items.map { items in return items.snippet.title}
                    ImageUrl = YoutubeRankingResponse.items.map { items in return items.snippet.thumbnails.medium.url}

                    print(titl)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
struct YoutubeRankingView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeRankingView()
    }
}
