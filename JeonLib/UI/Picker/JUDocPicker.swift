//
//  JUDocPicker.swift
//  editor
//
//  Created by Jeon on 2023/07/27.
//

import UIKit
import UniformTypeIdentifiers

class JUDocPicker : UIDocumentPickerViewController {
    var fileName : String? = nil
    var pickHandler : ((String) -> ())?
    var multiPickHandler : (([String]) -> ())?
    var cancelHandler : (() -> Void)?
    
    var isAccessSecurity = false
    
    public func setPickHandler(pickHandler : @escaping ((String) -> ())) {
        self.pickHandler = pickHandler
    }
    
    public func setMultiPickHandler(pickHandler : @escaping (([String]) -> ())) {
        self.multiPickHandler = pickHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}


extension JUDocPicker : UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("documentPickerWasCancelled")
        cancelHandler?()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("documentPicker url : \(url)")
        if !self.isAccessSecurity && !url.startAccessingSecurityScopedResource() {
            return
        }
        guard let nsUrl = NSURL(string: url.absoluteString), let strPath = nsUrl.path else {
            return
        }
        pickHandler?(self.fileName != nil ? "\(strPath)/\(self.fileName!)" : strPath)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("documentPicker urls : \(urls)")
        var paths = [String]()
        for url in urls {
            if !self.isAccessSecurity && !url.startAccessingSecurityScopedResource() {
                continue
            }
            guard let nsUrl = NSURL(string: url.absoluteString), let strPath = nsUrl.path else {
                continue
            }
            paths.append(self.fileName != nil ? "\(strPath)/\(self.fileName!)" : strPath)
        }
        multiPickHandler?(paths)
    }
}

extension JUDocPicker {
    
    static func allUTITypes(removePDF : Bool = false) -> [UTType] {
            let types : [UTType] =
                [.item,
                 .content,
                 .compositeContent,
                 .diskImage,
                 .data,
                 .directory,
                 .resolvable,
                 .symbolicLink,
                 .executable,
                 .mountPoint,
                 .aliasFile,
                 .urlBookmarkData,
                 .url,
                 .fileURL,
                 .text,
                 .plainText,
                 .utf8PlainText,
                 .utf16ExternalPlainText,
                 .utf16PlainText,
                 .delimitedText,
                 .commaSeparatedText,
                 .tabSeparatedText,
                 .utf8TabSeparatedText,
                 .rtf,
                 .html,
                 .xml,
                 .yaml,
                 .sourceCode,
                 .assemblyLanguageSource,
                 .cSource,
                 .objectiveCSource,
                 .swiftSource,
                 .cPlusPlusSource,
                 .objectiveCPlusPlusSource,
                 .cHeader,
                 .cPlusPlusHeader]

            var types_1: [UTType] =
                [.script,
                 .appleScript,
                 .osaScript,
                 .osaScriptBundle,
                 .javaScript,
                 .shellScript,
                 .perlScript,
                 .pythonScript,
                 .rubyScript,
                 .phpScript,
//                 .makefile, 'makefile' is only available in iOS 15.0 or newer
                 .json,
                 .propertyList,
                 .xmlPropertyList,
                 .binaryPropertyList,
                 .rtfd,
                 .flatRTFD,
                 .webArchive,
                 .image,
                 .jpeg,
                 .tiff,
                 .gif,
                 .icns,
                 .bmp,
                 .ico,
                 .rawImage,
                 .svg,
                 .livePhoto,
                 .heif,
                 .heic,
                 .webP,
                 .threeDContent,
                 .usd,
                 .usdz,
                 .realityFile,
                 .sceneKitScene,
                 .arReferenceObject,
                 .audiovisualContent]
        
        if !removePDF {
            types_1.append(.pdf)
        }

            let types_2: [UTType] =
                [.movie,
                 .video,
                 .audio,
                 .quickTimeMovie,
                 UTType("com.apple.quicktime-image"),
                 .mpeg,
                 .mpeg2Video,
                 .mpeg2TransportStream,
                 .mp3,
                 .mpeg4Movie,
                 .mpeg4Audio,
                 .appleProtectedMPEG4Audio,
                 .appleProtectedMPEG4Video,
                 .avi,
                 .aiff,
                 .wav,
                 .midi,
                 .playlist,
                 .m3uPlaylist,
                 .folder,
                 .volume,
                 .package,
                 .bundle,
                 .pluginBundle,
                 .spotlightImporter,
                 .quickLookGenerator,
                 .xpcService,
                 .framework,
                 .application,
                 .applicationBundle,
                 .applicationExtension,
                 .unixExecutable,
                 .exe,
                 .systemPreferencesPane,
                 .archive,
                 .gzip,
                 .bz2,
                 .zip,
                 .appleArchive,
                 .spreadsheet,
                 .presentation,
                 .database,
                 .message,
                 .contact,
                 .vCard,
                 .toDoItem,
                 .calendarEvent,
                 .emailMessage,
                 .internetLocation,
                 .internetShortcut,
                 .font,
                 .bookmark,
                 .pkcs12,
                 .x509Certificate,
                 .epub,
                 .log]
                    .compactMap({ $0 })

            return types + types_1 + types_2
        }
}
