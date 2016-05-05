//
//  RealmManagerTest.swift
//  com.MingSun.SecretoryTests
//
//  Created by Ming Sun on 4/27/19.
//

import XCTest
import ObjectMapper
@testable import com_MingSun_Secretory

class RealmManagerTest: XCTestCase {
	var movieRecord: [TMDBMovie] = []

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		guard
			let url = Bundle.init(for: type(of: self)).url(forResource: "TMDBMovieSample", withExtension: "json"),
			let data = try? Data.init(contentsOf: url),
			let str = String.init(data: data, encoding: .utf8)
			else {
				return
		}

		guard
			let results = Mapper<TMDBMovieResult>().map(JSONString: str)
			else {
				return
		}
		movieRecord = results.results
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_MovieRecordDBWrite() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		movieRecord[0].id.value = Int.random(in: 0...999999)
		RealmManager.shared.saveRecord(movieRecord[0])
		let result = RealmManager.shared.queryRecords(for: TMDBMovie.self, predicate: "id = \(movieRecord[0].id.value!)")
		XCTAssert(result.count != 0, "should have at least one record")
		guard let record = result[0] as? TMDBMovie else {
			XCTFail("failed to convert result to TMDBMovie")
			return
		}
		XCTAssert(record.id.value == movieRecord[0].id.value, "saved record has different id than original")
    }

	func test_MovieRecordListDBWrite() {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		RealmManager.shared.saveArrayOfRecords(movieRecord)
		let result = RealmManager.shared.queryRecords(for: TMDBMovie.self, predicate: "id = \(movieRecord[0].id.value!)")
		XCTAssert(result.count != 0, "should have at least one record")
		guard let record = result[0] as? TMDBMovie else {
			XCTFail("failed to convert result to TMDBMovie")
			return
		}
		XCTAssert(record.id.value == movieRecord[0].id.value, "saved record has different id than original")
	}

	func test_MovieRecordUpdate() {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		let result = RealmManager.shared.queryRecords(for: TMDBMovie.self, predicate: "id = \(movieRecord[0].id.value!)")
		guard let record = result[0] as? TMDBMovie else {
			XCTFail("failed to convert result to TMDBMovie")
			return
		}
		guard let originalTitle = record.title else {
			XCTFail("Movie Original title is nil")
			return
		}
		RealmManager.shared.updateRecord {
			record.title! += "testing"
		}

		let newResult = RealmManager.shared.queryRecords(for: TMDBMovie.self, predicate: "id = \(movieRecord[0].id.value!)")
		guard let newRecord = newResult[0] as? TMDBMovie else {
			XCTFail("failed to convert result to TMDBMovie")
			return
		}
		guard let newTitle = newRecord.title else {
			XCTFail("Movie New title is nil")
			return
		}
		XCTAssert(newTitle == originalTitle + "testing", "update record failed")
	}
}
