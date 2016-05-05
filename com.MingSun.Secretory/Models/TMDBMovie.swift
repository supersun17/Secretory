//
//  TMDBMovie.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 4/26/19.
//

import Foundation
import ObjectMapper
import RealmSwift

struct TMDBMovieResult: Mappable {
	var results: [TMDBMovie] = []
	var page: Int?
	var total_result: Int?
	var total_pages: Int?

	init?(map: Map) {}

	mutating func mapping(map: Map) {
		results <- map["results"]
		page <- map["page"]
		total_result <- map["total_result"]
		total_pages <- map["total_pages"]
	}

	static func factory(_ json: Any?) -> TMDBMovieResult? {
		return Mapper<TMDBMovieResult>().map(JSONObject: json)
	}
}

class TMDBMovie: Object, Mappable {
	let id = RealmOptional<Int>()
	let vote_average = RealmOptional<Double>()
	@objc dynamic var title: String?
	@objc dynamic var poster_path: String?
	var genre_ids = List<Int>()
	@objc dynamic var overview: String?
	@objc dynamic var release_date: String?

	required convenience init?(map: Map) {
		self.init()
	}

	override static func primaryKey() -> String? {
		return "id"
	}

	func mapping(map: Map) {
		id.value <- map["id"]
		vote_average.value <- map["vote_average"]
		title <- map["title"]
		poster_path <- map["poster_path"]
		genre_ids <- (map["genre_ids"], ArrayToListTransform())
		overview <- map["overview"]
		release_date <- map["release_date"]
	}
}
