//
//  RealmManager.swift
//  com.MingSun.Secretory
//
//  Created by Ming Sun on 4/27/19.
//

import Foundation
import RealmSwift

class RealmManager {
	static let shared = RealmManager()

	private let realm = try! Realm()
	var fileURL: URL? {
		return realm.configuration.fileURL
	}

	private init() {}

	func saveArrayOfRecords(_ records: [Object]) {
		do {
			try realm.write {
				realm.add(records)
			}
		} catch {
			print(error)
		}
	}

	func saveRecord(_ record: Object) {
		do {
			try realm.write {
				realm.add(record)
			}
		} catch {
			print(error)
		}
	}

	func updateRecord(changes: () -> Void) {
		do {
			try realm.write {
				changes()
			}
		} catch {
			print(error)
		}
	}

	func queryRecords(for recordType: Object.Type, predicate: String? = nil) -> Results<Object> {
		if let predicate = predicate {
			return realm.objects(recordType).filter(predicate)
		} else {
			return realm.objects(recordType)
		}
	}
}
