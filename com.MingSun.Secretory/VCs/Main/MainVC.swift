//
//  MainVC.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/27/19.
//

import UIKit

class MainVC: UIViewController {
	@IBOutlet weak var stickersStack: StickersStack!
	var tmdbService: TMDBServiceHandler!
	var tmdbNowPlaying: [TMDBMovie]?

	override func loadView() {
		Bundle.main.loadNibNamed("MainView", owner: self, options: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupTMDBService()
		setupStickersDeck()

		tmdbService.getNowPlayingList()
	}
}

extension MainVC: TMDBServiceDelegate {
	func setupTMDBService() {
		tmdbService = TMDBServiceHandler()
		tmdbService.delegate = self
	}

	func didReceiveNowPlayingList(_ result: TMDBMovieResult?) {
		tmdbNowPlaying = result?.results
		stickersStack.reloadStack()
	}

	func didReceiveError(_ error: Error?) {
		print(error ?? "Error received")
	}
}

extension MainVC: StickersStackDataSource {
	func setupStickersDeck() {
		stickersStack.dataSource = self
	}

	func numberOfStickers() -> Int {
		return tmdbNowPlaying?.count ?? 0
	}

	func contentViewForSticker(at index: Int) -> UIView {
		let content = MovieContentView()
		content.setup(with: tmdbNowPlaying![index])
		return content
	}
}
