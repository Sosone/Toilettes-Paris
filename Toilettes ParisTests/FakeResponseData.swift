//
//  FakeResponseData.swift
//  Toilettes ParisTests
//
//  Created by Anthony Laurent on 08/06/2022.
//

import Foundation

class FakeResponseData {
    
    static var toiletCorrectData : Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        guard let url = bundle.url(forResource: "sanisettesparis", withExtension: "json") else { return nil }
        return try? Data(contentsOf: url)
    }
    
    static let toiletIncorrectData = "erreur".data(using: .utf8)!
    
    
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: nil)!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    class ToiletError: Error {}
    static let error = ToiletError()
}
