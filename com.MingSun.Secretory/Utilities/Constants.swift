//
//  Constants.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/29/19.
//

import Foundation

struct AnimationConstants {
	static let stikerAnimationDuration = 0.2
}

enum Endpoint {
	enum AMC: String {
		case Base = "https://api.amctheatres.com"
		case NowPlaying = "/v2/movies/views/now-playing"
		case TOP10 = "/v2/movies/views/top-10-grossing"

		var url: URL? {
			return URL.init(string: Endpoint.AMC.Base.rawValue + self.rawValue)
		}
	}
	enum TMDB: String {
		case Base = "https://api.themoviedb.org/3"
		case Image = "https://image.tmdb.org/t/p/w500"
		case NowPlaying = "/movie/now_playing"

		var url: URL? {
			return URL.init(string: Endpoint.TMDB.Base.rawValue + self.rawValue)
		}

		func generatePostURL(with posterPath: String) -> URL? {
			return URL.init(string: self.rawValue + posterPath)
		}
	}
}
