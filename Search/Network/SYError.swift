//
//  SYError.swift
//  Search
//
//  Created by SutieDev on 2021/12/28.
//

import Foundation

enum SYError: Error {
    case null
    case invalidURL(String)
    case serverError
}

enum SYCoreDataError: Error {
    case invalidContext
    case fetchFail
    case commonError(String)
}
