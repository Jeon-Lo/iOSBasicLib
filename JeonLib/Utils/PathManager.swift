//
//  PathManager.swift
//  editor
//
//  Created by Jeon on 2023/08/25.
//

import Foundation

struct PathManager
{
    static var userDir : String {
        get {
            return "\(FileStorage.shared.userDir)"
        }
    }
    
    static var appDir = "\(FileStorage.shared.appDir)"
    
    static var pdfDir : String {
        get {
            return "\(PathManager.userDir)/pdf"
        }
    }
    
    static var eSealDir : String {
        get {
            return "\(PathManager.userDir)/eseal"
        }
    }
    
    static var eSealCount : Int {
        get {
            return FileManager.default.subpaths(atPath: PathManager.eSealDir)?.count ?? 0
        }
    }
    
    
    static func pdfFile(_ fileName : String) -> String {
        return "\(pdfDir)/\(fileName)"
    }
    
    static var thumbDir : String {
        get {
            return "\(PathManager.userDir)/thumb"
        }
    }
    
    //JPEG, JPG
    static func thumbFile(_ fileName : String) -> String {
        return "\(PathManager.thumbDir)/\(fileName)"
    }
    
    static func posterDir(_ fileName : String) throws -> String {
        let dir = "\(PathManager.thumbDir)/\(fileName)/poster"
        try FileStorage.shared.createDir(dir)
        return dir
    }
    
    static func thumbListFiles(_ fileName : String) -> [String] {
        var paths = [String]()
        if let thumbListDir = try? PathManager.posterDir(fileName), let sp = FileManager.default.subpaths(atPath: thumbListDir) {
            for subPath in sp {
                let path = "\(thumbListDir)/\(subPath)"
                LogEx.e("thumbListFiles path : \(path)")
                paths.append(path)
            }
        }
        return paths
    }
    
    static var tempDir : String {
        get {
            return "\(PathManager.userDir)/temp"
        }
    }
    
    static func tempFile(_ fileName : String) -> String {
        return "\(tempDir)/\(fileName)"
    }
    
    static var cacheDir : String {
        get {
            return "\(PathManager.userDir)/cache"
        }
    }
    
    static var metaDir : String {
        get {
            return "\(PathManager.userDir)/META"
        }
    }
}

