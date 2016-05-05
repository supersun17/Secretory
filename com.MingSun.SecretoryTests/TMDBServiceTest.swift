//
//  TMDBServiceTest.swift
//  com.MingSun.SecretoryTests
//
//  Created by Ming Sun on 4/26/19.
//

import XCTest
@testable import com_MingSun_Secretory

class TMDBServiceTest: XCTestCase, TMDBServiceDelegate {
	var service: TMDBServiceHandler!
	var nowPlayingExp: XCTestExpectation!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		service = TMDBServiceHandler()
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

	func didReceiveNowPlayingList(_ result: TMDBMovieResult?) {
		nowPlayingExp.fulfill()
		XCTAssertNotNil(result, "now playing list result should not be nil")
		XCTAssert(result!.results.count != 0, "movies count should not be 0")
		XCTAssert(result!.results[0].id.value != nil, "move id should not be nil")
		XCTAssert(result!.results[0].genre_ids.count != 0, "move genre should not be 0")
	}

	func didReceiveError(_ error: Error?) {
		nowPlayingExp.fulfill()
	}
}
