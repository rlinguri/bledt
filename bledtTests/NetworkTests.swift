//
//  NetworkTests.swift
//  bledtTests
//
//  Created by Roderic Linguri on 10/10/19.
//  Copyright © 2019 Digices LLC. All rights reserved.
//

import XCTest

@testable import bledt
class NetworkTests: XCTestCase {
    
    /// The thing we are testing
    var systemUnderTest: Network!
    
    /// The expected outcome for asynchronous tests
    var promise: XCTestExpectation!
    
    /// Called before each test method
    override func setUp() {
        self.systemUnderTest = Network()
        self.systemUnderTest.delegate = self
        self.promise = nil
    }

    /// Called after each test method
    override func tearDown() {
        self.systemUnderTest = nil
        self.promise = nil
    }
    
    /// Test fetching data from Google
    func testFetch() {
        self.promise = self.expectation(description: "fetch data from google")
        let url = URL(string: "https://www.google.com")!
        self.systemUnderTest.fetchData(from: url)
        self.waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    /// Test fetching from a broken endpoint
    func testTimeout() {
        self.promise = self.expectation(description: "timeout")
        let url = URL(string: "https://linguri.com/eko/timeout.php")!
        self.systemUnderTest.fetchData(from: url)
        self.waitForExpectations(timeout: 6.0, handler: nil)
    }
    
}

/// NetworkDelegate
extension NetworkTests: NetworkDelegate {
    
    /// Called when the Network has fetched data
    ///
    /// - Parameter data: the data that was fetched
    func didFetchData(data: Data) {
        print("test fetched \(data.debugDescription)")
        XCTAssertNotNil(data, "expected data not to be nil")
        self.promise?.fulfill()
    }
    
    /// Called when the Network has encountered an error
    ///
    /// - Parameter error: the error that was encountered
    func didProduceError(error: Error) {
        if self.promise.description == "fetch data from google" {
            XCTFail(error.localizedDescription)
        } else {
            let nsError = error as NSError
            XCTAssert(nsError.code == 9995, "expected a timeout error to have code 9995")
        }
        self.promise?.fulfill()
    }
    
}
