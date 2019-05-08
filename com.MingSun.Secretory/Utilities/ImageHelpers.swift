//
//  ImageHelpers.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 5/6/19.
//

import UIKit
import ImageIO

extension UIImage {
	/**
	ImageIO uses streaming the new image into disk, thus avoid the memory spike when using ImageRenderer
	- Parameters:
		url: local/remote image resouce
		size: prefered size
	- Returns: CGImage
	**/
	static func createThumbnail(from url: NSURL, to size: CGRect) -> CGImage? {
		guard let imageSource = CGImageSourceCreateWithURL(url, nil) else { return nil }
		let _ = CGImageSourceCopyProperties(imageSource, nil)
		let options: [NSString:Any] = [
			kCGImageSourceThumbnailMaxPixelSize: 100,
			kCGImageSourceCreateThumbnailFromImageAlways: true
		]
		return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
	}

	func resize(to rect: CGRect) -> UIImage? {
		let renderer = UIGraphicsImageRenderer.init(size: rect.size)
		let image = renderer.image { (context) in
			draw(in: rect)
		}
		return image
	}

	func resize(to width: CGFloat) -> UIImage? {
		// fmapp-1366: add scale factor into image size. Thus avatar image won`t be blurry due to low resolution
		let canvasSize = CGSize(width: width * scale, height: CGFloat(ceil(width / size.width * size.height) * scale))
		UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		draw(in: CGRect(origin: .zero, size: canvasSize))
		return UIGraphicsGetImageFromCurrentImageContext()
	}

	static func filled(_ image: UIImage, with color: UIColor) -> UIImage? {
		let pixelScale = UIScreen.main.scale
		let pixelSize = 1 / pixelScale
		let fillRect = CGRect.init(x: 0.0, y: 0.0, width: pixelSize, height: pixelSize)
		let renderer = UIGraphicsImageRenderer.init(size: fillRect.size)
		let image = renderer.image { (context) in
			color.setFill()
			context.fill(fillRect)
		}
		return image
	}

	static func imageWithTintColor(_ color: UIColor, rect: CGRect) -> UIImage {
		let renderer = UIGraphicsImageRenderer.init(size: rect.size)
		let image = renderer.image { (context) in
			color.setFill()
			context.fill(rect)
		}
		return image
	}

	/**
	return current image`s size in KB. If the image is nil, return 0
	*/
	func getJPEGFileSize() -> Int {
		if let jpegData = jpegData(compressionQuality: 1) {
			let nsData = NSData(data: jpegData)
			return nsData.length
		} else {
			return 0
		}
	}

	static func saveToDirectory(_ dir: URL, withName name: String) {

	}
}
