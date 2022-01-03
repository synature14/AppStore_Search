//
//  NetworkManager.swift
//  Search
//
//  Created by Suvely on 2021/12/28.
//

import Foundation
import RxSwift

class NetworkManager {
    static let API = "https://itunes.apple.com/search?entity=software&country=kr&term="
    
    static func request(search: String) -> Observable<SYResponse> {
        do {
            let fullAPI = API + search
            guard let encodedURL = fullAPI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: encodedURL) else {
                throw SYError.invalidURL(fullAPI)
            }
            
            let request = URLRequest(url: url)
            
            return URLSession.shared.rx.response(request: request)
                .map { (response: HTTPURLResponse, data: Data) -> SYResponse in
                    // 에러 처리?
                    let result = try JSONDecoder().decode(SYResponse.self, from: data)
                    return result
                }.asObservable()
            
        } catch {
            return Observable.empty()
        }
    }
}

