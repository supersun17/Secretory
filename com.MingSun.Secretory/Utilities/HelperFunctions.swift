//
//  HelperFunctions.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 3/28/19.
//

import UIKit
import ObjectMapper
import RealmSwift

extension UIColor {
	static func getRandomColor() -> UIColor {
		return UIColor.init(red: CGFloat(Double.random(in: 0...1)),
							green: CGFloat(Double.random(in: 0...1)),
							blue: CGFloat(Double.random(in: 0...1)),
							alpha: 1)
	}
}

class ArrayToListTransform<T: RealmCollectionValue>: TransformType {
	typealias Object = List<T>
	typealias JSON = [T]

	func transformFromJSON(_ value: Any?) -> Object? {
		if let arr = value as? JSON {
			let list = Object()
			list.append(objectsIn: arr)
			return list
		} else {
			return nil
		}
	}

	func transformToJSON(_ value: Object?) -> JSON? {
		var arr = JSON()
		if let list = value {
			for num in list {
				arr.append(num)
			}
			return arr
		} else {
			return nil
		}
	}
}
