//
//  AMCServiceHandler.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 4/26/19.
//

import Foundation

protocol AMCServiceDelegate {
	func didReceiveNowPlayingList(_ json: Any?)
	func didReceiveError(_ error: Error?)
}

class AMCServiceHandler: WebServiceHandler {
	private let credentials = AMCCredentials()
	var delegate: AMCServiceDelegate?

	func getNowPlayingList() {
		guard let url = Endpoint.AMC.NowPlaying.url else { return }
		requestJSON(url: url, headers: [credentials.keyHeader:credentials.key]) { [weak self] (json, error) in
			if error == nil {
				self?.delegate?.didReceiveNowPlayingList(json)
			} else {
				self?.delegate?.didReceiveError(error)
			}
		}
	}
}
