//
//  api-calls.swift
//  Riot-API-Project
//
//  Created by Micah Howard on 12/20/23.
//

import Foundation
struct APIresponsePUUID: Codable {
    let puuid: String
}
struct APIresponseMatches: Codable {
 let matchList :[String]
}

enum NetworkError: Error {
    
case custom(errorMessage: String)
}

class NetworkManager: ObservableObject{
    let api_key = "RGAPI-a5dab8e9-115c-4bcb-8500-5200d97e9002"
    var puuid_url = "https://na1.api.riotgames.com/lol/summoner/v4/summoners/by-name/mikeboi08"
    var matches_url = "https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/VClqfvwetdBaetW-jiyT4kMjUL3nkJcWeAO-rbbUYcEu1FELFJKleaxBSGtfY1ImNEyBLB6BdND_eg/ids?start=0&count=20"
    
    @Published var PUID = "0"
    @Published var matches = []
    
    func fetchPUIDs(completionHandler: @escaping (Result<APIresponsePUUID, NetworkError>) -> Void){
        guard let url = URL(string:puuid_url)else{
            return
        }
        var request = URLRequest(url:url)
        request.addValue(api_key, forHTTPHeaderField: "X-Riot-Token")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request){(data,response,Error) in
            
            guard let data = data,Error == nil else {
                completionHandler(.failure(.custom(errorMessage: "Didn't get back response data")))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(APIresponsePUUID.self, from:data)
                Task{
                    await MainActor.run {
                        self.PUID = response.puuid
                        print(response)
                    }
                }
            }
            catch {
                completionHandler(.failure(.custom(errorMessage: "Failed to decode data")))
            }
            
            
        }
        task.resume()
    }
//    func fetchMatchIDS(completionHandler: @escaping (Result<APIresponseMatches, NetworkError>) -> Void){
//        guard let url = URL(string:matches_url)else{
//            return
//        }
//        var request = URLRequest(url:url)
//        request.addValue(api_key, forHTTPHeaderField: "X-Riot-Token")
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let task = URLSession.shared.dataTask(with: request){(data,response,Error) in
//            
//            guard let data = data,Error == nil else {
//                completionHandler(.failure(.custom(errorMessage: "Didn't get back response data")))
//                return
//            }
//            
//            do {
//                let response = try JSONDecoder().decode(APIresponseMatches.self, from:data)
//                Task{
//                    await MainActor.run {
//                        self.matches = response.matchList
//                        print(response)
//                    }
//                }
//            }
//            catch {
//                completionHandler(.failure(.custom(errorMessage: "Failed to decode data")))
//            }
//            
//            
//        }
//        task.resume()
//    }
}



