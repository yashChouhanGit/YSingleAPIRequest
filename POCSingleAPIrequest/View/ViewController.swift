

import UIKit
import AVKit

class ViewController: UIViewController {

	@IBOutlet private weak var firstImageView: UIImageView!
	@IBOutlet private weak var secondImageView: UIImageView!
	@IBOutlet private weak var firstView: UIView!
	@IBOutlet private weak var secondView: UIView!
	
	private var token : NSObjectProtocol?  = nil
	private var player : [AVPlayer]  = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initial()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		removeObserver(token: token)
		self.player.forEach {
			$0.pause()
		}
	}
	
	@IBAction private func nextButtonAction(_ sender: UIButton) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") {
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	private func initial() {
		token = notificationHandler()
		
		let image  = AssetRequest(path: "https://picsum.photos/200/300?random=2",
							  folder: .main,
							  location: .home1)
		let video  = AssetRequest(path: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4",
							  folder: .main,
							  location: .home3)
	
		let requests = [image,video]
		
		requests.forEach {
			DownloadManager.instance.downlodingAsset(for: $0.path,
													 folder:  $0.folder,
													 location:  $0.location,
													 completion: { data in
				print("Data: \(data)")
			})
		}
	}
}

extension ViewController:NotificationObjectHandler {
	func notificationObject(_ notification: Notification?) {
		guard let object = notification?.object as? AssetPushInput else {
			return
		}
		let fileName = object.fileName
		let folder = object.folderName
		let locationName = object.locationName
		switch locationName {
			case .home1:
				if let data = try? LocalFileManager.instance.getData(fileName: fileName, folderName: folder) {
					self.firstImageView.image = UIImage(data: data)
					self.secondImageView.image = UIImage(data: data)
				} else {
					DownloadManager.proccessingFileNames.removeAll(where: {$0.checkAvailability(newFileName: fileName) })
				}
			case .home2: break
			case .home3:
				if let location = try? LocalFileManager.instance.getFileLocationPath(fileName: fileName, folderName: folder){
					self.player.append(self.firstView.loadVideo(path: location))
					self.player.append(self.secondView.loadVideo(path: location))
				} else {
					DownloadManager.proccessingFileNames.removeAll(where: {$0.checkAvailability(newFileName: fileName) })
				}
			case .home4:break
		}
	}
}
