//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by 김종권 on 2023/02/13.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didReceive(_ notification: UNNotification) {
        titleLabel?.text = notification.request.content.title
        bodyLabel?.text = notification.request.content.body
    }
}
