//
//  DataManagerTests.swift
//  bledtTests
//
//  Created by Roderic Linguri on 10/10/19.
//  Copyright © 2019 Digices LLC. All rights reserved.
//

import XCTest

@testable import bledt
class DataManagerTests: XCTestCase {
    
    /// The thing we are testing
    var systemUnderTest: DataManager!
    
    /// The expected outcome for asynchronous tests
    var promise: XCTestExpectation!
        
    /// Called before each test method
    override func setUp() {
        let network = Network()
        self.systemUnderTest = DataManager(storage: Storage(), network: network)
        self.systemUnderTest.delegate = self
        self.systemUnderTest.data = nil
        self.promise = nil
    }

    /// Called after each test method
    override func tearDown() {
        self.systemUnderTest = nil
        self.promise = nil
    }
    
    /// Test fetching data over network
    func testFetchData() {
        self.promise = self.expectation(description: "fetch data from server")
        self.systemUnderTest.fetch()
        self.waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    /// Test retriving data from storage
    func testRetrieve() {
        self.promise = self.expectation(description: "retrieve data")
        self.systemUnderTest.retrieve()
        self.waitForExpectations(timeout: 3.0, handler: nil)
    }
    
}

/// DataManagerDelegate
extension DataManagerTests: DataManagerDelegate {
    
    /// Called when the DataManager has retrieved data
    ///
    /// - Parameter data: The data that was retrieved
    func didRetrieveData(data: Data) {
        XCTAssertNotNil(self.systemUnderTest.data, "expected data not to be nil")
        self.promise?.fulfill()
    }
    
    /// Called when the DataManager has encountered an error
    ///
    /// - Parameter error: The error that was encountered
    func didProduceError(error: Error) {
        XCTFail(error.localizedDescription)
        self.promise?.fulfill()
    }
    
}
