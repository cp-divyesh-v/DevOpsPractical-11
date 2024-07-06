//
//  DictionaryViewModel.swift
//  DevOpsPractical11
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import Foundation
import Combine

class DictionaryViewModel: ObservableObject {
    private let webService: WebServiceProtocol
    @Published var dictionary: [Dictionary]?
    @Published var searchText: String = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(webService: WebServiceProtocol = WebService()) {
        self.webService = webService
        $searchText
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] searchText in
                self?.getMeaningOf(searchText)
            })
            .store(in: &cancellables)
    }
    
    func getMeaningOf(_ words: String) {
        webService.request(url: "https://api.dictionaryapi.dev/api/v2/entries/en/\(words)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, method: .get, parameter: [:], headers: nil,
                           success: { (_, _, dictionary: [Dictionary]) in
            self.dictionary = dictionary
        }, failure: { error in
            print("API request failed with error: \(error)")
        })
    }
}
