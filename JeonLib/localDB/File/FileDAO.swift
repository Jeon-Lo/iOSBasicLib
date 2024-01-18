//
//  FileDAO.swift
//  editor
//
//  Created by Jeon on 2023/08/11.
//

import RealmSwift
import Foundation
import SwiftUI

class FileDAO {
    static func getFileList(_ hash : String? = nil) -> Array<FileEntity> {
        let realm = try! Realm()
        
        let r = realm.objects(FileEntity.self).sorted(byKeyPath: "modifiedTime", ascending: false)
        if let userHash = hash {
            let results = r.filter { entity in
                return entity.userHash == userHash
            }
            return Array<FileEntity>(results)
        }
        else {
            return Array<FileEntity>(r)
        }
    }
    
    static func getRecentlyFileList(_ limit : Int = 20) -> Array<FileEntity> {
        let realm = try! Realm()
        
        let results = realm.objects(FileEntity.self)
            .sorted(byKeyPath: "recentlyOpenTime", ascending: false)
            .filter("recentlyOpenTime != nil"/* AND recentlyOpenTime != ''"*/)
        
        var array = Array<FileEntity>()
        for i in 0 ..< limit {
            guard let entity = Array<FileEntity>(results)[safe : i] else {
                continue
            }
            array.append(entity)
        }
        return array
    }
    
    static func getFile(_ userHash : String, _ fileName : String) -> FileEntity? {
        let realm = try! Realm()
        
        let predicate = NSPredicate.init(format: "userHash == %@ AND fileName == %@", userHash, fileName)
        let results = realm.objects(FileEntity.self).filter(predicate)
        guard let entity = results[safe : 0] else {
            return nil
        }
        return entity
    }
    
    static func getFileFromFileId(_ userHash : String, _ fileId : String) -> FileEntity? {
        let realm = try! Realm()
        
        let predicate = NSPredicate.init(format: "userHash == %@ AND cloudFileId == %@", userHash, fileId)
        let results = realm.objects(FileEntity.self).filter(predicate)
        guard let entity = results[safe : 0] else {
            return nil
        }
        return entity
    }
    
    static func searchFile(_ userHash : String, _ fileName : String) -> [FileEntity] {
        let realm = try! Realm()
        let predicate = NSPredicate.init(format: "userHash == %@ AND fileName contains %@", userHash, fileName)
        let results = realm.objects(FileEntity.self).filter(predicate)
        return Array<FileEntity>(results)
    }
    
    static func insertAll(_ entities : Array<FileEntity> ){
        let realm = try! Realm()
        try! realm.write {
            realm.add(entities, update: .modified)
        }
    }

    static func insert(_ entity : FileEntity, _ completionHandler : ((FileEntity) -> Void)? = nil){
        let realm = try! Realm()
        try! realm.write {
            realm.add(entity, update: .modified)
            
            if let handler = completionHandler {
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.3) {
                    handler(entity)
                }
            }
        }
    }
    
    @available(*, deprecated, message: "The function is being fixed.")
    static func update(_ entity : FileEntity) {
        delete(entity)
        insert(entity)
    }
    
    static func updateName(_ entity : FileEntity, _ name : String) {
        let realm = try! Realm()
        try! realm.write {
            entity.thaw()?.fileName = name
        }
    }
    
    static func updateFileSize(_ entity : FileEntity, _ fileSize : Double) {
        let realm = try! Realm()
        try! realm.write {
            entity.thaw()?.fileSize = fileSize
        }
    }
    
    static func updateCloudFileID(_ entity : FileEntity, _ fileId : String?) {
        LogEx.e("updateCloudFileID fileId : \(fileId)")
        let realm = try! Realm()
        try! realm.write {
            entity.thaw()?.cloudFileId = fileId
        }
    }
    
    static func updateXFDFSyncTime(_ entity : FileEntity, _ fileId : String, _ uploadedAt : Double) {
        LogEx.e("updateXFDFSyncTime uploadedAt : \(uploadedAt)")
        let realm = try! Realm()
        try! realm.write {
            entity.thaw()?.cloudXFDFSynced = uploadedAt
        }
    }
    
    static func updateBookMarkSyncTime(_ entity : FileEntity, _ fileId : String, _ uploadedAt : Double) {
        LogEx.e("updateBookMarkSyncTime uploadedAt : \(uploadedAt)")
        let realm = try! Realm()
        try! realm.write {
            entity.thaw()?.cloudBookmarkSynced = uploadedAt
        }
    }
    
    static func updateOpenTime(_ entity : FileEntity, _ date : Date?) {
        let realm = try! Realm()
        try! realm.write {
            entity.thaw()?.recentlyOpenTime = date
            entity.thaw()?.isOpened = true
        }
    }
    
    static func toggleFavorite(_ entity : FileEntity) {
        let realm = try! Realm()
        try! realm.write {
            entity.isFavorite = !entity.isFavorite
        }
    }
    
    static func delete(_ entity : FileEntity){
        let realm = try! Realm()
        guard let talkRoom = realm.object(ofType: FileEntity.self, forPrimaryKey: entity.key) else {
            return
        }
        do {
            try realm.write {
                realm.delete(talkRoom)
            }
        }
        catch {
            LogEx.e("delete error : \(error.localizedDescription)")
        }
    }
    
    static func delete(_ path : String){
        let realm = try! Realm()
        guard let file = realm.object(ofType: FileEntity.self, forPrimaryKey: path) else {
            return
        }
        do {
            try realm.write {
                realm.delete(file)
            }
        }
        catch {
            LogEx.e("delete error : \(error.localizedDescription)")
        }
    }

    static func deleteAll() -> Bool {
        let realm = try! Realm()
            
        do {
            try realm.write {
                realm.delete(realm.objects(FileEntity.self))
            }
        }
        catch {
            LogEx.e("delete error : \(error.localizedDescription)")
            return false
        }
        
        return true
    }
}
