//
// File:      bledtTests
// Module:    Tests
// Package:   bledtTests
//
// Author:    Roderic Linguri <linguri@digices.com>
// Copyright: © 2019 Digices LLC. All Rights Reserved
// License:   MIT
//
// Requires:  > Swift 5.1 && > iOS 12.0
// Version:   0.1.0
// Since:     0.1.0
//

import XCTest
@testable import bledt

class bledtTests: XCTestCase {
  
  /// The thing we are testing
  var systemUnderTest: UIApplication!
  
  /// Called before each test method
  override func setUp() {
    self.systemUnderTest = UIApplication.shared
  }
  
  /// Called after each test method
  override func tearDown() {
    self.systemUnderTest = nil
  }
  
  /// Test application exists
  func test_A_Application() {
    XCTAssertNotNil(
      self.systemUnderTest,
      "expected the UIApplication to not be nil"
    )
  }
  
  /// Test window exists
  func test_B_Window() {
    XCTAssert(
      self.systemUnderTest.delegate?.window != nil,
      "expected the window not to be nil"
    )
  }

}
