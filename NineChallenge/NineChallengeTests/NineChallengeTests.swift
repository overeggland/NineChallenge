//
//  NineChallengeTests.swift
//  NineChallengeTests
//
//  Created by Xavier Zhang on 6/7/2023.
//

import XCTest
@testable import NineChallenge

final class NineChallengeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    //Test Network
    func testNetwork() async {
        let expectation = expectation(description: "received data!")
        do {
            let data = try await Network.fetchAssetList()
            print(data)
            expectation.fulfill()
        } catch {
            print("not expected!")
        }
        await fulfillment(of: [expectation], timeout: 6, enforceOrder: false)
    }
    
    //Test date convert
    func testDateFormatter() {
        var timestamp = 1688943129
        var dateString = convert(timeStamp: timestamp)
        XCTAssertEqual(dateString, "08:52 10/07/2023")
        
        timestamp = 1689029650
        dateString = convert(timeStamp: timestamp)
        XCTAssertEqual(dateString, "08:54 11/07/2023")
    }
    
    //Test sort method
    func testTimestampSort() {
        let timestamp = [1688943129, 1688941129, 1688943029, 1689943129, 1688943029].shuffled()
        let assets = timestamp.map {
            Asset(assetType: "", url: "", relatedImages: nil, byLine: "", headline: "", theAbstract: "", lastModified:$0)
        }
        let arr = assets.sortByLastmodified().map { $0.lastModified! }
        XCTAssertEqual(arr, timestamp.sorted(by: >))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
