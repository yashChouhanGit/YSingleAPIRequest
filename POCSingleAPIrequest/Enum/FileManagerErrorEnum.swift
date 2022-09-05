//
//  FileManagerErrorEnum.swift
//  POCSingleAPIrequest
//
//  Created by Yash on 03/09/22.
//

import Foundation

enum FileManagerErrorEnum: Error {
	case directoryNil
	case folderNotCreated(String)
	case dataNil
	case dataIsEmpty
	case fileNameNil
	case fileNameIsEmpty
	case folderNameNil
	case folderNameIsEmpty
	case folderURLNil
	case errorWriteData
	case notExitPath
	case removeError
}
