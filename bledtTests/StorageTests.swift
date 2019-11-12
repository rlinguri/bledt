//
//  StorageTests.swift
//  bledtTests
//
//  Created by Roderic Linguri on 10/10/19.
//  Copyright © 2019 Digices LLC. All rights reserved.
//

import XCTest

@testable import bledt
class StorageTests: XCTestCase {
    
    /// The thing we are testing
    var systemUnderTest: Storage!
    
    /// Temporary data reference
    var testData: Data?
    
    /// Called before each test method
    override func setUp() {
        self.systemUnderTest = Storage()
        if let url = Bundle.main.url(forResource: "data", withExtension: "txt") {
            do {
                self.testData = try Data(contentsOf: url)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    /// Called after each test method
    override func tearDown() {
        self.systemUnderTest = nil
        self.testData = nil
    }
    
    /// Test saving and loading of data
    func testSaveAndLoad() {
        if let data = self.testData {
            self.systemUnderTest.save(data: data, to: "test_data.txt")
            let loaded = self.systemUnderTest.load(from: "test_data.txt")
            XCTAssertNotNil(loaded, "Expected loaded data not to be nil")
        } else {
            XCTFail("Test data is missing")
        }
    }
    
    /// Test removing data from storage
    func testReset() {
        if let data = self.testData {
            self.systemUnderTest.save(data: data, to: "test_data.txt")
            self.systemUnderTest.reset(file: "test_data.txt")
            let attemptedLoad = self.systemUnderTest.load(from: "test_data.txt")
            XCTAssertNil(attemptedLoad, "Expected attempted load to fail")
        } else {
            XCTFail("Test data is missing")
        }
    }
    
}
