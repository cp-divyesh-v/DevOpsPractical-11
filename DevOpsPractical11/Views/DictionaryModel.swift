//
//  DictionaryModel.swift
//  DevOpsPractical11
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import Foundation

struct Dictionary: Codable, Hashable {
    let word: String
    let phonetics: [Phonetic]
    let meanings: [Meaning]?
}

struct Meaning: Codable, Hashable {
    let partOfSpeech: String
    let definitions: [Definition]
    let synonyms, antonyms: [String]?
}

struct Definition: Codable, Hashable {
    let definition: String?
    let synonyms, antonyms: [String]?
    let example: String?
}

struct Phonetic: Codable, Hashable {
    let audio: String?
}
