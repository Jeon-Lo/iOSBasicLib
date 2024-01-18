//
//  FileEntity.swift
//  editor
//
//  Created by Jeon on 2023/08/11.
//

import RealmSwift
import Foundation
import UIKit

class FileEntity : Object, ObjectKeyIdentifiable {
//    override class func primaryKey() -> String? {
//        return "key"
//    }
    //Primary key PDF파일의 상대 주소
    @Persisted (primaryKey: true) var key : String! = NSUUID().uuidString
    
    //PDF파일의 절대 주소
    var pdfPath : String {
        get {
            if self.directoryType == .INAPP {
                return "\(FileStorage.shared.appDir)/\(self.userHash)/pdf/\(fileName)"
            }
            //외부 파일은 아직 미정이라 동일한 값을 쓴다 임시로
            else {
                return "\(FileStorage.shared.appDir)/\(self.userHash)/pdf/\(fileName)"
            }
        }
    }
    var originPath : String = ""
    var thumbImage : UIImage? = nil
    var openPassword : String? = nil
    var ownerPassword : String? = nil
    @Persisted var userHash : String = ""
    @Persisted var fileName : String = ""
    @Persisted var fileSize : Double = 0
    @Persisted var modifiedTime : Date? = nil
    @Persisted var recentlyOpenTime : Date? = nil
    @Persisted var isFavorite : Bool = false
    @Persisted var lastViewPage : Int = 0
    @Persisted var isOpened : Bool = false
    @Persisted var cloudFileId : String? = nil
    @Persisted var cloudPDFSynced : Double? = nil
    @Persisted var cloudXFDFSynced : Double? = nil
    @Persisted var cloudBookmarkSynced : Double? = nil
    
    
    @Persisted private var directoryTypeRaw = DIRECTORY_TYPE.INAPP.rawValue
    
    var directoryType : DIRECTORY_TYPE {
        get {
            for type in DIRECTORY_TYPE.allCases where directoryTypeRaw == type.rawValue {
                return type
            }
            return .INAPP
        }
        set(value) {
            self.directoryTypeRaw = value.rawValue
        }
    }
    
    
    enum DIRECTORY_TYPE: String, CaseIterable {
        case INAPP
        case DOWNLOAD
        case CLOUD
    }
}
