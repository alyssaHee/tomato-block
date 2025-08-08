//
//  NFCReader.swift
//  Tomato Brick
//
//  Created by Alyssa H on 2025-07-21.
//

import CoreNFC

class NFCReader: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    @Published var message = "Waiting for Tomato..."
    var session: NFCNDEFReaderSession?
    var onScanComplete: ((String) -> Void)?
    var onWriteComplete: ((Bool) -> Void)?
    var isWriting = false
    var textToWrite: String?
    
    func scan(modeName: String, completion: @escaping (String) -> Void) {
        self.onScanComplete = completion
        self.isWriting = false
        startSession(modeName: modeName)
    }
    
    func write(_ text: String, completion: @escaping (Bool) -> Void) {
        self.onWriteComplete = completion
        self.textToWrite = text
        self.isWriting = true
        startSession()
    }
    
    private func startSession(modeName: String? = nil) {
        guard NFCNDEFReaderSession.readingAvailable else {
            NSLog("NFC is not available on this device")
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        if isWriting {
                session?.alertMessage = "Hold your iPhone near tomato to create tag."
            } else if let modeName = modeName {
                session?.alertMessage = "Hold your iPhone near tomato to trigger \(modeName) mode."
            } else {
                session?.alertMessage = "Hold your iPhone near tomato."
            }
        session?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        guard !isWriting else { return }
        
        for message in messages {
            for record in message.records {
                if record.typeNameFormat == .nfcWellKnown {
                    if let text = record.wellKnownTypeTextPayload().0 {
                        DispatchQueue.main.async {
                            self.message = text
                            self.onScanComplete?(text)
                        }
                    }
                }
            }
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if isWriting {
            handleWriting(session: session, tags: tags)
        } else {
            handleReading(session: session, tags: tags)
        }
    }
    
    private func handleReading(session: NFCNDEFReaderSession, tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            session.alertMessage = "More than 1 tomato detected. Please try again."
            session.invalidate()
            return
        }
        
        let tag = tags.first!
        session.connect(to: tag) { error in
            if let error = error {
                session.invalidate(errorMessage: "Connection error: \(error.localizedDescription)")
                return
            }
            
            tag.queryNDEFStatus { status, _, error in
                if let error = error {
                    session.invalidate(errorMessage: "Failed to query tomato: \(error.localizedDescription)")
                    return
                }
                
                switch status {
                case .notSupported:
                    session.invalidate(errorMessage: "Tomato is not NDEF compliant")
                case .readOnly, .readWrite:
                    tag.readNDEF { message, error in
                        if let error = error {
                            session.invalidate(errorMessage: "Read error: \(error.localizedDescription)")
                        } else if let message = message {
                            self.processMessage(message)
                            session.alertMessage = "Tomato read successfully!"
                            session.invalidate()
                        } else {
                            session.invalidate(errorMessage: "No NDEF message found on tomato")
                        }
                    }
                @unknown default:
                    session.invalidate(errorMessage: "Unknown tomato status")
                }
            }
        }
    }
    
    private func processMessage(_ message: NFCNDEFMessage) {
        for record in message.records {
            switch record.typeNameFormat {
            case .nfcWellKnown:
                if let text = record.wellKnownTypeTextPayload().0 {
                    DispatchQueue.main.async {
                        self.message = text
                        self.onScanComplete?(text)
                    }
                } else if let url = record.wellKnownTypeURIPayload() {
                    DispatchQueue.main.async {
                        self.message = url.absoluteString
                        self.onScanComplete?(url.absoluteString)
                    }
                }
            case .absoluteURI:
                if let text = String(data: record.payload, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.message = text
                        self.onScanComplete?(text)
                    }
                }
            default:
                break
            }
        }
    }
    
    private func handleWriting(session: NFCNDEFReaderSession, tags: [NFCNDEFTag]) {
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "No tomato detected")
            return
        }
        
        session.connect(to: tag) { error in
            if let error = error {
                session.invalidate(errorMessage: "Connection error: \(error.localizedDescription)")
                return
            }
            
            tag.queryNDEFStatus { status, capacity, error in
                guard error == nil else {
                    session.invalidate(errorMessage: "Failed to query tomato")
                    return
                }
                
                switch status {
                case .notSupported:
                    session.invalidate(errorMessage: "Tomato is not NDEF compliant")
                case .readOnly:
                    session.invalidate(errorMessage: "Tomato is read-only")
                case .readWrite:
                    guard let textToWrite = self.textToWrite else {
                        session.invalidate(errorMessage: "No text to write")
                        return
                    }
                    
                    let payload = NFCNDEFPayload.wellKnownTypeTextPayload(string: textToWrite, locale: Locale(identifier: "en"))!
                    let message = NFCNDEFMessage(records: [payload])
                    
                    tag.writeNDEF(message) { error in
                        if let error = error {
                            session.invalidate(errorMessage: "Write failed: \(error.localizedDescription)")
                        } else {
                            session.alertMessage = "Write successful!"
                            session.invalidate()
                        }
                        
                        DispatchQueue.main.async {
                            self.onWriteComplete?(error == nil)
                        }
                    }
                @unknown default:
                    session.invalidate(errorMessage: "Unknown tomato status")
                }
            }
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                NSLog("Session invalidated with error: \(error.localizedDescription)")
            }
        }
        self.session = nil
    }
}
