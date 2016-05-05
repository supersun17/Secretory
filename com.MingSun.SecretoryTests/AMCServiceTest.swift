//
//  AMCServiceTest.swift
//  com.MingSun.SecretoryTests
//
//  Created by Ming Sun on 4/26/19.
//

import XCTest
@testable import com_MingSun_Secretory

class AMCServiceTest: XCTestCase, AMCServiceDelegate {
	var service: AMCServiceHandler!
	var nowPlayingExp: XCTestExpectation!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		service = AMCServiceHandler()
		service.delegate = self
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_NowPlayingList() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		nowPlayingExp = expectation(description: "nowPlayingExp")
		service.getNowPlayingList()
		wait(for: [nowPlayingExp], timeout: 5)
    }

	func didReceiveNowPlayingList(_ json: Any?) {
		nowPlayingExp.fulfill()
	}

	func didReceiveError(_ error: Error?) {
		nowPlayingExp.fulfill()
	}
}
