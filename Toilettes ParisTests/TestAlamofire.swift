//
//  Toilettes_ParisTests.swift
//  Toilettes ParisTests
//
//  Created by Anthony Laurent on 24/05/2022.
//
import Alamofire
import XCTest
@testable import Toilettes_Paris

class TestAlamofire: XCTestCase {
    
//    override func setUp() {
//        <#code#>
//    }
//
//    override class func tearDown() {
//        <#code#>
//    }
    
    let session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.af.ephemeral
        configuration.protocolClasses = [FakeProtocol.self] + (configuration.protocolClasses ?? [])
        return Alamofire.Session(configuration: configuration)
    }()
    
    
    func testloadAllToilets() {

        FakeProtocol.loadData = {
            return FakeResponseData.toiletCorrectData
        }

        let toiletService = ToiletService(session: session)

        let expectation = expectation(description: "wait")
        toiletService.loadAll() { (success, toilets) in
            XCTAssertTrue(success)
            XCTAssertNotNil(toilets)
            XCTAssertNotEqual(toilets!.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testCannotLoadAllToilets()
    {
        FakeProtocol.loadData = {
            return FakeResponseData.toiletIncorrectData
        }

        let toiletService = ToiletService(session: session)

        let expectation = expectation(description: "wait")
        toiletService.loadAll() { (success, toilets) in
            XCTAssertFalse(success)
            XCTAssertNil(toilets)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }
}
    
    class FakeProtocol: URLProtocol {
        
        static var loadData: () -> Data? = { return nil }
        static var loadError: () -> Error? = { return nil }
        static var loadResponse: () -> URLResponse? = { return nil }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {

            if let data = Self.loadData()
            {
                client?.urlProtocol(self, didReceive: HTTPURLResponse(url: URL(string: "https://google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)!, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)

            }
            else if let error = Self.loadError()
            {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
        
        
        override func stopLoading() {
            
        }
}

