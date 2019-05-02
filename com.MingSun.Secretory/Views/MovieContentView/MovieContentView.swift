//
//  MovieContentView.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 5/1/19.
//

import UIKit

class MovieContentView: UIView {
	@IBOutlet var contentView: UIView!
	@IBOutlet weak var movieImage: UIImageView!
	@IBOutlet weak var movieName: UILabel!
	@IBOutlet weak var movieReleaseDate: UILabel!

	var dataTask: URLSessionDataTask?

	private func customeInit() {
		Bundle.main.loadNibNamed("MovieContentView", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		contentView.backgroundColor = .white
		movieImage.contentMode = .scaleAspectFill
		movieImage.clipsToBounds = true
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		customeInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		customeInit()
	}

	func setup(with movie: TMDBMovie) {
		movieName.text = movie.title
		movieReleaseDate.text = movie.release_date

		guard
			let path = movie.poster_path,
			let url = Endpoint.TMDB.Image.generatePostURL(with: path),
			let request = try? URLRequest(url: url, method: .get) else {
				return
		}

		dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
			guard let data = data else { return }

			DispatchQueue.main.async {
				self?.movieImage.image = UIImage(data: data)
			}
		}
		dataTask?.resume()
	}

	override func removeFromSuperview() {
		dataTask?.cancel()
		dataTask = nil
		super.removeFromSuperview()
	}
}
