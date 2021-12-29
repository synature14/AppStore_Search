//
//  SearchResult.swift
//  Search
//
//  Created by SutieDev on 2021/12/28.
//

import Foundation

struct SYResponse: Decodable {
    let results: [SearchResult]
    let resultCount: Int
    
    enum CodingKeys: CodingKey {
        case results
        case resultCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.resultCount = try container.decode(Int.self, forKey: .resultCount)
        self.results = try container.decode(Array<SearchResult>.self, forKey: .results)
    }
}


struct SearchResult: Decodable {
    let iconImage: String      // 앱 아이콘
    let screenshotUrls: [String]
    let ipadScreenshotUrls: [String]
    let trackName: String   // 앱 타이틀
    
    // 릴리즈노트
    let version: String     // 최신 버전
    let releaseNotes: String?
    let description: String
    
    // InfoData
    let sellerName: String              // 제공자
    let fileSizeBytes: String           // 크기
    let genres: [String]                // 카테고리
    let minimumOsVersion: String        // 호환성 os버전
    let languageCodesISO2A: [String]    // 언어 ($0 및 $1)
    
    let trackContentRating: String      // 연령 등급
    let advisories: [String]            // 연령등급 상세 설명
    
    let sellerUrl: String?       // 개발자 웹사이트
    
    // User Review
    let userRatingCount: Int        // ~개의 평가
    let averageUserRating: Double        // 소수점 둘째자리에서 반올림
    
    enum CodingKeys: String, CodingKey {
        case iconImage = "artworkUrl100"
        case screenshotUrls, ipadScreenshotUrls
        case trackName
        case version, releaseNotes, description
        case sellerName, fileSizeBytes, genres, minimumOsVersion, languageCodesISO2A
        case trackContentRating, advisories, sellerUrl
        case userRatingCount, averageUserRating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.iconImage = try container.decode(String.self, forKey: .iconImage)
        self.screenshotUrls = try container.decode(Array<String>.self, forKey: .screenshotUrls)
        self.ipadScreenshotUrls = try container.decode(Array<String>.self, forKey: .ipadScreenshotUrls)
        self.trackName = try container.decode(String.self, forKey: .trackName)
        
        self.version = try container.decode(String.self, forKey: .version)
        self.releaseNotes = try? container.decode(String.self, forKey: .releaseNotes)
        self.description = try container.decode(String.self, forKey: .description)
        
        self.sellerName = try container.decode(String.self, forKey: .sellerName)
        self.fileSizeBytes = try container.decode(String.self, forKey: .fileSizeBytes)
        self.genres = try container.decode(Array<String>.self, forKey: .genres)
        self.minimumOsVersion = try container.decode(String.self, forKey: .minimumOsVersion)
        self.languageCodesISO2A = try container.decode(Array<String>.self, forKey: .languageCodesISO2A)
        
        self.trackContentRating = try container.decode(String.self, forKey: .trackContentRating)
        self.advisories = try container.decode(Array<String>.self, forKey: .advisories)
        
        self.sellerUrl = try? container.decode(String.self, forKey: .sellerUrl)
        
        self.userRatingCount = try container.decode(Int.self, forKey: .userRatingCount)
        self.averageUserRating = try container.decode(Double.self, forKey: .averageUserRating)
        
    }
}

//struct InfoData: Decodable {
//    let sellerName: String              // 제공자
//    let fileSizeBytes: String           // 크기
//    let genres: [String]                // 카테고리
//    let minimumOsVersion: String        // 호환성 os버전
//    let languageCodesISO2A: [String]    // 언어 ($0 및 $1)
//
//    let trackContentRating: String      // 연령 등급
//    let advisories: [String]            // 연령등급 상세 설명
//
//    let sellerUrl: String       // 개발자 웹사이트
//
//
//    enum CodingKeys: CodingKey {
//        case sellerName, fileSizeBytes, genres, minimumOsVersion, languageCodesISO2A
//        case trackContentRating, advisories, sellerUrl
//    }
//}
//
//struct ReleaseNote: Decodable {
//    let version: String     // 최신 버전
//    let releaseNotes: String
//    let description: String
//
//    // [고도화] 개발자가 출시한 또다른 앱 two depth로 보여줄수 있음
//    // https://itunes.apple.com/search?country=kr&term=__인코딩된sellerName__.&entity=software 으로 request. response 중에 artistName이 sellerName과 같은것만 filter
//
//    enum CodingKeys: CodingKey {
//        case version, releaseNotes, description
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.version = try container.decode(String.self, forKey: .version)
//        self.releaseNotes = try container.decode(String.self, forKey: .releaseNotes)
//        self.description = try container.decode(String.self, forKey: .description)
//    }
//
//}
//
//struct UserReview: Decodable {
//    let userRatingCount: Int        // ~개의 평가
//    let averageUserRating: Double        // 소수점 둘째자리에서 반올림
//
//    enum CodingKeys: CodingKey {
//        case userRatingCount, averageUserRating
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.userRatingCount = try container.decode(Int.self, forKey: .userRatingCount)
//        self.averageUserRating = try container.decode(Double.self, forKey: .averageUserRating)
//    }
//}
