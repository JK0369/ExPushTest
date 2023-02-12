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
        contentHandler(bestAttemptContent)
    }
    
    // didReceive에서 contentHandler가 호출되지 않고 특정 시간이 경과하면 이 메소드가 호출
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
