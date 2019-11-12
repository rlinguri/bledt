//
// File:      TextualModuleTests.swift
// Module:    Textual
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
class TextualModuleTests: XCTestCase {

    var systemUnderTest: TextualViewController!
    
    override func setUp() {
        self.systemUnderTest = TextualRouter.createViewController(rootRouter: RootRouter()) as? TextualViewController
    }
        
    override func tearDown() {
        self.systemUnderTest = nil
    }
    
    /// Verify factory method creates a ViewController
    func test_A_ViewController() {
        XCTAssertNotNil(
            self.systemUnderTest,
            "expected viewController not to be nil"
        )
    }
    
    /// Verify that the presenter has been injected as a dependency and has a delegate
    func test_B_Presenter() {
        XCTAssertNotNil(
            self.systemUnderTest.presenter.delegate,
            "expected presenter delegate not to be nil"
        )
    }
    
    /// Verify that the interactor has been injected as a dependency and has a delegate
    func test_C_Interactor() {
        XCTAssertNotNil(
            self.systemUnderTest.presenter.interactor.delegate,
            "expected iteractor delegate not to be nil"
        )
    }
    
    /// Verify that the router has been injected as a dependency
    func test_D_Router() {
        XCTAssertNotNil(
            self.systemUnderTest.presenter.interactor.router,
            "expected router not to be nil"
        )
    }

    
}
