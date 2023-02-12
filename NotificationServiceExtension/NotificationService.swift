//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by 김종권 on 2023/02/12.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    // APNs를 수신하면 didReceive 메소드 호출
    // contentHnadler 클로저를 수행하면 푸시가 노출
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent else { return }
        
        bestAttemptContent.title = "변경 " + request.content.title
        bestAttemptContent.subtitle = "변경 " + request.content.subtitle
        
        // 푸시에 이미지 추가
        let imageURLString = request.content.userInfo["image"] as! String
        do {
            // 이미지 타입으로 저장하지 않으면 error나므로 주의 (.png, .jpg 등으로 할 것)
            try saveFile(id: "myImage.png", imageURLString: imageURLString) { fileURL in
                do {
                    print(fileURL.absoluteURL)
                    let attachment = try UNNotificationAttachment(identifier: "", url: fileURL, options: nil)
                    bestAttemptContent.attachments = [attachment]
                    contentHandler(bestAttemptContent)
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
        
    }
    
    // didReceive에서 contentHandler가 호출되지 않고 특정 시간이 경과하면 이 메소드가 호출
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func saveFile(id: String, imageURLString: String, completion: (_ fileURL: URL) -> Void) throws {
        let fileManager = FileManager.default
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentDirectory.appendingPathComponent(id)
        
        guard
            let imageURL = URL(string: imageURLString),
            let data = try? Data(contentsOf: imageURL)
        else { throw URLError(.cannotDecodeContentData) }
        try data.write(to: fileURL)
        completion(fileURL)
    }
}
