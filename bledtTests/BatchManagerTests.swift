//
// File:      BatchManagerTests.swift
// Module:    Entities
// Package:   bledtTests
//
// Author:    Roderic Linguri <rlinguri@mac.com>
// Copyright: © 2019 Roderic Linguri. All Rights Reserved.
// License:   MIT
//
// Requires:  > Swift 5.0 && > iOS 12.0
// Version:   0.2.3
// Since:     0.1.4
//

import XCTest

@testable import bledt
class BatchManagerTests: XCTestCase {

    /// The thing we are testing
    var systemUnderTest: BatchManager!
    
    /// Called before each test method
    override func setUp() {
        if let url = Bundle.main.url(forResource: "data", withExtension: "txt") {
            do {
                let data = try Data(contentsOf: url)
                self.systemUnderTest = BatchManager(data: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Called after each test method
    override func tearDown() {
        self.systemUnderTest = nil
    }
    
    /// Verify that the correct number of samples are produced
    func test_A_SampleCount() {
        let expected: Int = 22
        let result = self.systemUnderTest.samples.count
        XCTAssert(
            result == expected,
            "expected \(expected) samples, result \(result)"
        )
    }
    
    /// Verify that the correct number of batches are produced
    func test_B_BatchCount() {
        let expected: Int = 2
        let result = self.systemUnderTest.batches.count
        XCTAssert(
            result == expected,
            "expected \(expected) samples, result \(result)"
        )
    }
    
    /// Verify that complete batches are evaluated correctly
    func test_C_CompleteBatches() {
        let expected: Int = 1
        var result: Int = 0
        for batch in self.systemUnderTest.batches {
            if batch.isComplete {
                result += 1
            }
        }
        XCTAssert(
            result == expected,
            "expected \(expected) complete batches, result \(result)"
        )
    }
    
    /// Verify that no sample sequence numeral exceeds the maximum
    func test_D_SampleSeq() {
        let expected = 0
        var result = 0
        for sample in self.systemUnderTest.samples {
            if sample.seq > 15 {
                result += 1
            }
        }
        XCTAssert(result == expected, "expected no seq to be larger than 15")
    }
    
}
