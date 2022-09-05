//
//  DownloadManager.swift
//  POCSingleAPIrequest
//
//  Created by Yash on 05/09/22.
//

import Foundation

extension Array where Self.Element == Process {
	mutating func addNewEleemnt(_ value: Element) {
		guard value.fielName.isEmpty == false else { return }
		self.append(value)
	}
}

class DownloadManager {
	
	static var proccessingFileNames:[Process] = []
	
	private(set) static var instance = DownloadManager()
	
	func downlodingAsset(for path: String?,
						 folder: FileFolderEnum,
						 location:SetLocationEnum,
						 completion: @escaping(Data) -> Void) {
		guard let path =  path else {
			return
		}
		guard path.isEmpty == false else {
			return
		}
		guard let url = URL(string: path) else {
			return
		}
		let fileName = url.lastPathComponent
		guard fileName.isEmpty == false else {
			return
		}
		
		guard let data = try? LocalFileManager.instance.getData(fileName: fileName,
																folderName: folder) else {
			guard DownloadManager.proccessingFileNames.first(where: {$0.fielName == fileName}) == nil else {
				print("Stil in procees fileName : \(fileName)")
				return
			}
			let process = Process(fielName: fileName, locationName: location, folderName: folder)
			DownloadManager.proccessingFileNames.addNewEleemnt(process)
			URLSession.shared.dataTask(with: url) { [weak self] data ,response , error in
				let fileName = response?.url?.lastPathComponent ?? ""
				if fileName.isEmpty  {
					print("Error: fileName.isEmpty true")
					return
				}
				print("Start procees fileName : \(fileName)")
				if let error = error {
					print("Error: \(error)")
					return
				}
				guard let process = DownloadManager.proccessingFileNames.first(where: { value in
					value.checkAvailability(newFileName: fileName)
				}) else {
					return
				}
				DownloadManager.proccessingFileNames.removeAll(where: {$0.checkAvailability(newFileName: fileName) })
				if let data = data {
					self?.setDataInFile(data: data, fileName: fileName, folder: process.folderName)
					print("Fetch From Server Data: \(data) fileName : \(fileName) \(self == nil)")
					self?.push(fileName: process.fielName, locationName: process.locationName, folder: process.folderName)
					completion(data)
				}
			}.resume()
			return
		}
		print("Fetch From local Data: \(data) fileName : \(fileName)")
		push(fileName: fileName, locationName: location, folder: folder)
		completion(data)
	}
	
	private func setDataInFile(data: Data,fileName: String,folder: FileFolderEnum) {
		_ = try? LocalFileManager.instance.save(data: data, fileName: fileName, folderName: folder)
	}
	
	private func push(fileName: String,
					  locationName: SetLocationEnum,
					  folder: FileFolderEnum) {
		guard let output = AssetPushInput(fileName: fileName,
										  locationName: locationName,
										  folder: folder) else {
			return
		}
		NotificationCenter.default.post(name: Notification.Name.init("DownloadAssetNotification"), object: output)
	}
}

