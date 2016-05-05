//
//  TMDBServiceHandler.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 4/26/19.
//

import Foundation

protocol TMDBServiceDelegate {
	func didReceiveNowPlayingList(_ result: TMDBMovieResult?)
	func didReceiveError(_ error: Error?)
}

class TMDBServiceHandler: WebServiceHandler {
	private let credentials = TMDBCredentials()
	var delegate: TMDBServiceDelegate?

	func getNowPlayingList() {
		guard let url = Endpoint.TMDB.NowPlaying.url else { return }
		requestJSON(url: url, parameters: [credentials.keyQuery:credentials.key]) { [weak self] (json, error) in
			if error == nil {
				self?.delegate?.didReceiveNowPlayingList(TMDBMovieResult.factory(json))
			} else {
				self?.delegate?.didReceiveError(error)
			}
		}
	}
}
