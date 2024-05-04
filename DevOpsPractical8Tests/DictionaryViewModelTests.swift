//
//  DictionaryViewModel.swift
//  DevOpsPractical8Tests
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import XCTest
import Cuckoo

class DictionaryViewModelTests: XCTestCase {
    
    func testGetMeaningOfValidWord() {
        let expectation = XCTestExpectation(description: "API Request")
        
        let mockWebService = MockWebService()
        mockWebService.expectation = expectation
        mockWebService.result = .success(MockResponse.mockResponse("Dictionary")!)
        
        let viewModel = DictionaryViewModel(webService: mockWebService as WebServiceProtocol)
        
        viewModel.getMeaningOf("hello")
    }
}
