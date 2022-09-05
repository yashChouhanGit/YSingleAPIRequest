//
//  NotificationObjectHandler.swift
//  POCSingleAPIrequest
//
//  Created by Yash on 05/09/22.
//

import UIKit

protocol NotificationObjectHandler {
	func notificationObject(_ notification: Notification?)
}

extension NotificationObjectHandler where Self: UIViewController {

	func notificationHandler() -> NSObjectProtocol {
			let token = NotificationCenter
			.default
			.addObserver(forName: Notification.Name.init("DownloadAssetNotification"),
						 object: nil,
						 queue: .main,
						 using: { [weak self] notification in
							self?.notificationObject(notification)
						 })
		return token
	}
	
	func removeObserver(token: NSObjectProtocol?)  {
		guard let token = token else { return }
		
		return
			NotificationCenter.default.removeObserver(token)
	}
}
