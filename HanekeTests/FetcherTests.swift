//
//  FetcherTests.swift
//  Haneke
//
//  Created by Hermes Pique on 9/10/14.
//  Copyright (c) 2014 Haneke. All rights reserved.
//

import UIKit
import XCTest

class FetcherTests: XCTestCase {
    
    func testSimpleFetcherInit() {
        let key = self.name
        let image = UIImage.imageWithColor(UIColor.greenColor())
        
        let fetcher = SimpleFetcher<UIImage>(key: key, thing: image)

        XCTAssertEqual(fetcher.key, key)
        XCTAssertEqual(fetcher.getThing(), image)
    }
    
    func testSimpleFetcherFetch() {
        let key = self.name
        let image = UIImage.imageWithColor(UIColor.greenColor())
        let fetcher = SimpleFetcher<UIImage>(key: key, thing: image)
        let expectation = self.expectationWithDescription(self.name)
        
        fetcher.fetch(failure: { _ in
            XCTFail("expected success")
        }) {
            XCTAssertEqual($0, image)
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(0, handler: nil)
    }
    
    func testCacheFetch() {
        let data = NSData.dataWithLength(1)
        let expectation = self.expectationWithDescription(self.name)
        let cache = Cache<NSData>(self.name)
        
        cache.fetch(key: self.name, value: data) {
            XCTAssertEqual($0, data)
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(1, handler: nil)
        
        cache.removeAllValues()
    }
    
    func testCacheFetch_WithFormat() {
        let data = NSData.dataWithLength(1)
        let expectation = self.expectationWithDescription(self.name)
        let cache = Cache<NSData>(self.name)
        let format = Format<NSData>(self.name)
        cache.addFormat(format)
        
        cache.fetch(key: self.name, value: data, formatName: format.name) {
            XCTAssertEqual($0, data)
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(1, handler: nil)
        
        cache.removeAllValues()
    }
    
}
