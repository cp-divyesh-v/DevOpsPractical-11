//
//  MockWebService.swift
//  DevOpsPractical8Test
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import Foundation
import XCTest
import Alamofire

class MockWebService: WebServiceProtocol {
    var expectation: XCTestExpectation?
    var result: Result<Data, Error>?

    func request<T: Decodable>(url: String, method: HTTPMethod, parameter: Parameters, headers: HTTPHeaders?, success: @escaping (Data, Int, T) -> Void, failure: @escaping (Error) -> Void) {
        if let result = result {
            switch result {
            case .success(let data):
                if let parsedData = try? JSONDecoder().decode(T.self, from: data) {
                    success(data, 200, parsedData)
                }
            case .failure(let error):
                failure(error)
            }
        }
        expectation?.fulfill()
    }
}
