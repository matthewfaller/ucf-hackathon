//
//  TasklyTests.swift
//  TasklyTests
//
//  Created by Matthew Faller on 10/29/18.
//  Copyright © 2018 Royal Bank of Canada. All rights reserved.
//

import XCTest
@testable import Taskly

class TasklyTests: XCTestCase {

    var controllers = ["A", "B", "C"]
    
    var count: Int {
        return controllers.count
    }
    
    func testFindsIndex() {
        let index = controllers.firstIndex(of: "B")
        
        let expected = 1
        
        XCTAssertEqual(index, expected)
    }
    
    func testModulusMiddle() {
        
        guard let index = controllers.firstIndex(of: "B") else { XCTFail(); return }
        
        let previousIndex = (index - 1) % count
        let nextIndex = (index + 1) % count
        
        let expectedPrevious = 0
        let expectedNext = 2
        
        XCTAssertEqual(previousIndex, expectedPrevious)
        XCTAssertEqual(nextIndex, expectedNext)
    }
    
    func testModulusFirst() {
        guard let index = controllers.firstIndex(of: "A") else { XCTFail(); return }
        
        let previousIndex = modulo(index - 1, by: count)
        let nextIndex = modulo(index + 1, by: count)
        
        let expectedPrevious = 2
        let expectedNext = 1
        
        XCTAssertEqual(previousIndex, expectedPrevious)
        XCTAssertEqual(nextIndex, expectedNext)
    }
    
    func testModulusLast() {
        guard let index = controllers.firstIndex(of: "C") else { XCTFail(); return }
        
        let previousIndex = modulo(index - 1, by: count)
        let nextIndex = modulo(index + 1, by: count)
        
        let expectedPrevious = 1
        let expectedNext = 0
        
        XCTAssertEqual(previousIndex, expectedPrevious)
        XCTAssertEqual(nextIndex, expectedNext)
    }
    
    func modulo(_ x: Int, by amount: Int) -> Int {
        if x < 0 {
            return amount + (x % amount)
        } else {
            return (x % amount)
        }
    }
}
