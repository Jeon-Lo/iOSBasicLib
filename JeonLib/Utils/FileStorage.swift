//
//  FileStorage.swift
//  eBook
//
//  Created by Gi Soo Hur on 2023/01/04.
//

import Foundation

class FileStorage : NSObject {
    enum ValidationError: Error {
        case unknownContentsName
        case unknownDateFormat
        case notExists
        case unknown
    }
    
    static let shared: FileStorage = {
        return FileStorage()
    }()
    
    static let GROUP_APP_ID = ""
    let appDir = FileStorage.documentDir()
    var userDir = ""

    static func documentDir(_ useAppGroup : Bool = false) -> String {
        if useAppGroup {
            if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: FileStorage.GROUP_APP_ID) {
                return containerURL.path
            }
        }
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].path
    }

    func createDir(_ path:String) throws {
        if FileManager.default.fileExists(atPath: path) == false {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
        }
    }
    
    func login(_ userId:String) {
        do {
            userDir = "\(appDir)/\(userId)"
            LogEx.e("userDir : \(userDir)")
            remove(PathManager.tempDir)
            try createDir(PathManager.userDir)
            try createDir(PathManager.pdfDir)
            try createDir(PathManager.thumbDir)
            try createDir(PathManager.metaDir)
            try createDir(PathManager.cacheDir)
            try createDir(PathManager.eSealDir)
            try createDir(PathManager.tempDir)
        } catch {
            switch error {
            default:
                LogEx.d("FileStorage login error = "+error.localizedDescription)
            }
        }
    }
    
    func logout() {
        userDir = ""
        remove(PathManager.tempDir)
    }
    
    func saveData(_ atData:Data, _ toPath:String) -> Bool {
        do {
            FileManager.default.createFile(atPath: toPath, contents: atData, attributes: nil)
            LogEx.d("FileStorage saveCompress:\(toPath)")
            return true
        } catch {
            switch error {
            default:
                LogEx.d("FileStorage saveCompress error = "+error.localizedDescription)
            }
        }
        return false
    }
    
    func loadData(_ atPath:String) -> Data? {
        guard let url = URL(string: "file://\(atPath)") else {
            LogEx.d("FileStorage loadUncompress error = url is null")
            return nil
        }
        // 서버에서 내려준 파일이 압축이 풀리는 경우 그냥 데이터 응답
        var zip:Data? = nil
        do {
            zip = try Data(contentsOf: url)
            return zip
//            return try zip?.gunzipped()
        } catch {
            switch error {
            default:
                LogEx.d("FileStorage loadUncompress error = "+error.localizedDescription)
            }
        }
        return zip
    }

    func move(_ atPath:String, _ toPath:String) -> Bool {
        if FileManager.default.fileExists(atPath: atPath) == false {
            LogEx.d("FileStorage move error = atPath not exists")
            return false
        }
        if FileManager.default.fileExists(atPath: toPath) {
            remove(toPath)
        }
        do {
            try FileManager.default.moveItem(atPath: atPath, toPath: toPath)
            return true
        } catch {
            switch error {
            default:
                LogEx.d("FileStorage move error = "+error.localizedDescription)
            }
        }
        return false
    }
    
    func copy(_ atPath:String, _ toPath:String) -> Bool {
        if FileManager.default.fileExists(atPath: atPath) == false {
            LogEx.d("FileStorage copy error = atPath not exists")
            return false
        }
        if FileManager.default.fileExists(atPath: toPath) == false {
            remove(toPath)
        }
        do {
            try FileManager.default.copyItem(atPath: atPath, toPath: toPath)
            return true
        } catch {
            switch error {
            default:
                LogEx.d("FileStorage copy error = "+error.localizedDescription)
            }
        }
        return false
    }
    
    func getUniqueCopyName(_ atPath : String, _ addingText : String = "") -> String {
        let fileName = atPath.fileName().removeExtension()
        let fileExtension = atPath.extension()
        
        var isUniqueName = true
        var index = 0
        
        var newFileName = "\(fileName)\(addingText).\(fileExtension)"
        while (isUniqueName) {
            let newPath = atPath.replacingOccurrences(of: atPath.fileName(), with: newFileName)
            if FileManager.default.fileExists(atPath: newPath) {
                index = index + 1
                newFileName = "\(fileName)\(addingText)(\(index)).\(fileExtension)"
            }
            else {
                isUniqueName = false
            }
        }
        LogEx.e("newFileName : \(newFileName)")
        return atPath.replacingOccurrences(of: atPath.fileName(), with: newFileName)
        
        
        
        /*
        if FileManager.default.fileExists(atPath: atPath) {
            let regex = /(?:_\()([0-9]+)(?:\).)/
            if let match = try? regex.firstMatch(in: atPath.fileName())?.output, let srcIndex = Int(match.1) {
                let newPath = atPath.replacingOccurrences(of: "_(\(srcIndex))", with: "_(\(srcIndex + 1))")
                return self.getUniqueCopyName(newPath)
            }
            else {
                let fileName = atPath.fileName().removeExtension()
                let replaced = atPath.replacingOccurrences(of: fileName, with: "\(fileName)_(\(1))")
                return self.getUniqueCopyName(replaced)
            }
        }
        return atPath*/
    }
    
    func rename(_ atPath : String, _ name : String) -> String? {
        let toPath = atPath.replacingOccurrences(of: atPath.fileName(), with: name)
        if move(atPath, toPath) {
            return toPath
        }
        return nil
    }
    
    open func data<T>(_ atObj:T) -> Data? where T : Codable
    {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(atObj)
            return jsonData
        } catch {
            switch error {
            default:
                LogEx.d("FileStorage load(jsonData) error = "+error.localizedDescription)
            }
        }
        return nil
    }

    open func object<T>(_ atJsonData:Data) -> T? where T : Codable
    {
        do {
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(T.self, from: atJsonData)
        } catch {
            switch error {
            default:
                LogEx.d("FileStorage load(jsonData) error = "+error.localizedDescription)
            }
        }
        return nil
    }

    
    func save<T>(_ atObj: T, _ toPath:String) -> Bool where T : Codable
    {
        if atObj is Data || atObj is Data? {
            LogEx.d("FileStorage save error = atObj is Data")
            return false
        }
        do {
            let jsonEncoder = JSONEncoder()
            let data = try jsonEncoder.encode(atObj)
//            FileManager.default.createFile(atPath: "\(toPath).json", contents: jsonData, attributes: nil)
            // 암호화
            FileManager.default.createFile(atPath: toPath, contents: data, attributes: nil)
            return true
        } catch {
            switch error {
            default:
                LogEx.d("FileStorage save error = "+error.localizedDescription)
            }
        }
        return false
    }
    
    open func load<T>(_ atPath:String) -> T? where T : Codable
    {
        do {
            guard let data = FileManager.default.contents(atPath: atPath) else {
                LogEx.d("FileStorage load error = jsonData is null, path = \(atPath)")
                return nil
            }
            // 복호화
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            switch error {
            default:
                LogEx.d("FileStorage load error = "+error.localizedDescription)
            }
        }
        return nil
    }

    
    func remove(_ atPath:String) -> Bool
    {
        if atPath == "" {
            return false
        }
        do {
            try FileManager.default.removeItem(atPath: atPath)
            return true
        } catch {
            switch error {
            default:
                LogEx.d("FileStorage remove error = "+error.localizedDescription)
            }
            return false
        }
    }
    
    func removeDir(_ atPath : String) -> Bool {
        if atPath.isEmpty {
            return false
        }
        do {
            for subPath in FileManager.default.subpaths(atPath: atPath) ?? [] {
                let subFullPath = "\(atPath)/\(subPath)"
                if let ssubPath = FileManager.default.subpaths(atPath: subFullPath), !ssubPath.isEmpty {
                    self.removeDir(subFullPath)
                }
                else {
                   try? FileManager.default.removeItem(atPath: subFullPath)
                }
            }
            LogEx.e("removeDir subPath count : \((FileManager.default.subpaths(atPath: atPath) ?? []).count) ")
            return true
        }
        catch {
            LogEx.d("FileStorage remove error = "+error.localizedDescription)
            return false
        }
    }
        
    func freeSize() -> Int64 {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: appDir),
            let size = systemAttributes[.systemFreeSize] as? NSNumber
        else {
            LogEx.d("FileStorage freeSize error = systemAttributes or freeSize is null")
            return 0
        }
        return size.int64Value
    }
    
    func totalSize() -> Int64 {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: appDir),
            let size = systemAttributes[.systemSize] as? NSNumber
        else {
            LogEx.d("FileStorage totalSize error = systemAttributes or freeSize is null")
            return 0
        }
        return size.int64Value
    }
    
    func useSize() -> Int64 {
        return totalSize() - freeSize()
    }
}
