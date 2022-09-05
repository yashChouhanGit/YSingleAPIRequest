//
//  LocalFileManager.swift
//  POCSingleAPIrequest
//
//  Created by Yash on 03/09/22.
//

import Foundation

class LocalFileManager {
	
	static var instance = LocalFileManager()
	
	private var directory: URL? {
		FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
	}
	
	private init() {}
	
	private func createFolder(folder: FileFolderEnum?) throws -> URL? {
		guard let folder = folder else {
			throw FileManagerErrorEnum.folderNameNil
		}
		guard folder.folderName.isEmpty == false else {
			throw FileManagerErrorEnum.folderNameIsEmpty
		}
		guard let directory = directory else {
			throw FileManagerErrorEnum.directoryNil
		}
		let folderURL = directory.appendingPathComponent(folder.folderName)
		do {
			try FileManager.default.createDirectory(at: folderURL,
													withIntermediateDirectories: true,
													attributes: nil)
			return folderURL
		} catch {
			throw FileManagerErrorEnum.folderNotCreated(error.localizedDescription)
		}
	}
	
	func save(data: Data?,fileName: String?,folderName: FileFolderEnum?) throws {
		guard let data = data else {
			throw FileManagerErrorEnum.dataNil
		}
		guard data.isEmpty == false else {
			throw FileManagerErrorEnum.dataIsEmpty
		}
		guard let fileName = fileName else {
			throw FileManagerErrorEnum.fileNameNil
		}
		guard fileName.isEmpty == false else {
			throw FileManagerErrorEnum.fileNameIsEmpty
		}
		do {
			guard  let folderURLPath = try	createFolder(folder: folderName) else {
				throw FileManagerErrorEnum.folderURLNil
			}
			let fileSaveLocationPath = folderURLPath.appendingPathComponent(fileName)
			do {
				try data.write(to: fileSaveLocationPath)
			} catch {
				throw FileManagerErrorEnum.errorWriteData
			}
		} catch {
			throw error
		}
	}
	
	func getFileLocationPath(fileName: String?,folderName: FileFolderEnum?) throws -> URL {
		guard let fileName = fileName else {
			throw FileManagerErrorEnum.fileNameNil
		}
		guard fileName.isEmpty == false else {
			throw FileManagerErrorEnum.fileNameIsEmpty
		}
		guard let folderName = folderName else {
			throw FileManagerErrorEnum.folderNameNil
		}
		guard folderName.folderName.isEmpty == false else {
			throw FileManagerErrorEnum.folderNameIsEmpty
		}
		do {
			guard  let folderURL = try	createFolder(folder: folderName) else {
				throw FileManagerErrorEnum.folderURLNil
			}
			
			let paths = try FileManager.default.contentsOfDirectory(atPath: folderURL.path)
			guard  paths.isEmpty == false else {
				throw FileManagerErrorEnum.folderURLNil
			}
			
			let  urls = paths.compactMap({ URL(fileURLWithPath: $0) })
			
			guard  urls.isEmpty == false else {
				throw FileManagerErrorEnum.folderURLNil
			}
			
			let  fileNames = urls.compactMap({ $0.lastPathComponent })
			
			guard  fileNames.isEmpty == false else {
				throw FileManagerErrorEnum.folderURLNil
			}
			
			guard let first = fileNames.first(where: {$0.contains(fileName) || fileName.contains($0)}) else {
				throw FileManagerErrorEnum.folderURLNil
			}
			guard  first.isEmpty == false else {
				throw FileManagerErrorEnum.folderURLNil
			}
			
			let fileSaveLocationURLPath = folderURL.appendingPathComponent(first).path
			let fileSaveLocationURL = URL(fileURLWithPath: fileSaveLocationURLPath)
			return fileSaveLocationURL
		} catch {
			throw error
		}
	}
	
	func getData(fileName: String?,folderName: FileFolderEnum?) throws -> Data {
		do {
			let fileURLPath = try getFileLocationPath(fileName: fileName,folderName: folderName).path
			//print(fileURLPath)
			guard let data = FileManager.default.contents(atPath: fileURLPath) else {
				throw FileManagerErrorEnum.dataNil
			}
			guard data.isEmpty == false else {
				throw FileManagerErrorEnum.dataIsEmpty
			}
			return  data
		} catch {
			throw error
		}
	}
	
	func remove(fileName: String?,folderName: FileFolderEnum?) throws {
		guard let folder = folderName else {
			throw FileManagerErrorEnum.folderNameNil
		}
		guard folder.folderName.isEmpty == false else {
			throw FileManagerErrorEnum.folderNameIsEmpty
		}
		guard let fileName = fileName else {
			throw FileManagerErrorEnum.fileNameNil
		}
		guard fileName.isEmpty == false else {
			throw FileManagerErrorEnum.fileNameIsEmpty
		}
		guard let directory = directory else {
			throw FileManagerErrorEnum.directoryNil
		}
		let fileURLPath =	 directory.appendingPathComponent(folder.folderName).appendingPathComponent(fileName)
		guard FileManager.default.fileExists(atPath: fileURLPath.absoluteString) else {
			throw FileManagerErrorEnum.notExitPath
		}
		do {
			try FileManager.default.removeItem(at: fileURLPath)
		} catch {
			throw FileManagerErrorEnum.removeError
		}
	}
}
