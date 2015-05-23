//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Jeff Smith on 5/20/15.
//  Copyright (c) 2015 Jeff Smith. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var messagesScrollView: UIScrollView!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var helpLabelImageView: UIImageView!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageFeedImageView: UIImageView!
    @IBOutlet weak var rightIconImageView: UIImageView!
    @IBOutlet weak var leftIconImageView: UIImageView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    
    let blueColor = UIColor(red: 68/255, green: 170/255, blue: 210/255, alpha: 1)
    let yellowColor = UIColor(red: 254/255, green: 202/255, blue: 22/255, alpha: 1)
    let brownColor = UIColor(red: 206/255, green: 150/255, blue: 98/255, alpha: 1)
    let greenColor = UIColor(red: 85/255, green: 213/255, blue: 80/255, alpha: 1)
    let redColor = UIColor(red: 231/255, green: 61/255, blue: 14/255, alpha: 1)
    let grayColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
    
    var messageScrollViewHeight: CGFloat = 0.0
    var originalMessageLocationX: CGFloat = 0.0
    var originalMessageLocationY: CGFloat = 0.0
    var archivePoint: CGFloat = 60
    var deletePoint: CGFloat = 260
    var deferPoint: CGFloat = -60
    var categorizePoint: CGFloat = -260
    var iconFollowPoint: CGFloat = 60
    var messageSpringDamping: CGFloat = 0.8
    var messageVelocity: CGFloat = 0.9
    var messageViewContentSpaceY: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageViewContentSpaceY = self.messageContainerView.frame.height
        rescheduleImageView.hidden = true
        listImageView.hidden = true
        setScrollViewHeight()
        defineMessageView()
        leftIconImageView.center.x = iconFollowPoint / 2
        rightIconImageView.center.x = 320 - (iconFollowPoint / 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        var panTranslation = sender.translationInView(view)
        if sender.state == UIGestureRecognizerState.Began {
        } else if sender.state == UIGestureRecognizerState.Changed {
            moveMessageWithPan(panTranslation)
            changePosition(panTranslation)
            setIconImage(panTranslation)
        } else if sender.state == UIGestureRecognizerState.Ended {
            setEndPosition(panTranslation)
        }
    }
    
    @IBAction func didTapReschedule(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.rescheduleImageView.alpha = 0
            self.rescheduleImageView.hidden = true
        }) { (Bool) -> Void in
            self.minimizeMessageView()
        }
    }
    
    @IBAction func didTapList(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.listImageView.alpha = 0
            self.listImageView.hidden = true
            }) { (Bool) -> Void in
                self.minimizeMessageView()
        }
    }
    
    func setScrollViewHeight() {
        messageScrollViewHeight = searchImageView.frame.height + helpLabelImageView.frame.height + messageImageView.frame.height + messageFeedImageView.frame.height
        messagesScrollView.contentSize = CGSize(width: 320, height: messageScrollViewHeight)
    }
    
    func defineMessageView() {
        originalMessageLocationX = messageImageView.center.x
        originalMessageLocationY = messageImageView.center.y
    }
    
    func moveMessageWithPan(translation: CGPoint) {
        messageImageView.center = CGPoint(x: translation.x + originalMessageLocationX, y: originalMessageLocationY)
    }

    func changePosition(translation: CGPoint) {
        setColor(translation)
        setIconAlpha(translation)
        setIconLocation(translation)
    }
    
    func setEndPosition(translation: CGPoint) {
        if translation.x > archivePoint {
            sendMessageRightForArchive()
        } else if translation.x > deletePoint {
            sendMessageRightForDelete()
        } else if translation.x < categorizePoint {
            sendMessageLeftForCategorize()
        } else if translation.x < deferPoint {
            sendMessageLeftForDefer()
        } else {
            setMessageBackToCenter()
        }
    }
    
    func setColor(translation: CGPoint) {
        if translation.x < deletePoint && translation.x > 0 {
            messageContainerView.backgroundColor = greenColor
        } else if translation.x > deletePoint {
            messageContainerView.backgroundColor = redColor
        } else if translation.x < 0 && translation.x > categorizePoint {
            messageContainerView.backgroundColor = yellowColor
        } else if translation.x < categorizePoint {
            messageContainerView.backgroundColor = brownColor
        } else {
            messageContainerView.backgroundColor = grayColor
        }
    }
    
    func setIconAlpha(translation: CGPoint) {
        if translation.x > archivePoint {
            leftIconImageView.alpha = 1
            rightIconImageView.alpha = 0
        } else if translation.x < deferPoint {
            rightIconImageView.alpha = 1
            leftIconImageView.alpha = 0
        } else {
            leftIconImageView.alpha = 0.5
            rightIconImageView.alpha = 0.5
        }
    }
    
    func setIconImage(translation: CGPoint) {
        if translation.x > deletePoint {
            leftIconImageView.image = UIImage( named: "delete_icon")
        } else if translation.x < categorizePoint {
            rightIconImageView.image = UIImage( named: "list_icon")
        } else {
            leftIconImageView.image = UIImage( named: "archive_icon")
            rightIconImageView.image = UIImage( named: "later_icon")
        }
    }
    
    func setIconLocation(translation: CGPoint) {
        if translation.x > iconFollowPoint {
            var newLeftIconLocation = translation.x - (iconFollowPoint / 2)
            leftIconImageView.center.x = newLeftIconLocation
        } else if translation.x < -1 * iconFollowPoint {
            var newRightIconLocation = 320 + (translation.x + (iconFollowPoint / 2))
            rightIconImageView.center.x = newRightIconLocation
        }
    }
    
    func sendMessageRightForArchive() {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.messageImageView.center = CGPoint(x: 320 + self.originalMessageLocationX, y: self.originalMessageLocationY)
            self.leftIconImageView.center.x += 320
        }) { (Bool) -> Void in
            self.minimizeMessageView()
        }
    }
    
    func sendMessageRightForDelete() {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.messageImageView.center = CGPoint(x: 320 + self.originalMessageLocationX, y: self.originalMessageLocationY)
            self.leftIconImageView.center.x += 320
        }) { (Bool) -> Void in
            self.minimizeMessageView()
        }
    }
    
    func sendMessageLeftForCategorize() {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.messageImageView.center = CGPoint(x: -320 + self.originalMessageLocationX, y: self.originalMessageLocationY)
            self.rightIconImageView.center.x -= 320
        }) { (Bool) -> Void in
            println("Yo")
            self.showlistImageView()
        }
    }

    func sendMessageLeftForDefer() {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.messageImageView.center = CGPoint(x: -320 + self.originalMessageLocationX, y: self.originalMessageLocationY)
            self.rightIconImageView.center.x -= 320
        }) { (Bool) -> Void in
            self.showReschuduleImageView()
        }
    }
    
    func setMessageBackToCenter() {
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: messageSpringDamping, initialSpringVelocity: messageVelocity, options: nil, animations: { () -> Void in
            self.messageImageView.center = CGPoint(x: self.originalMessageLocationX, y: self.originalMessageLocationY)
            }, completion: nil)
    }
    
    func minimizeMessageView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            var messageViewContentSpaceY = self.messageContainerView.frame.height
            self.messageFeedImageView.center.y -= messageViewContentSpaceY
        }) { (Bool) -> Void in
            self.bringBackDatMessage()
        }
    }
    
    func showReschuduleImageView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.rescheduleImageView.hidden = false
            self.rescheduleImageView.alpha = 1
        }, completion: nil)
    }
    
    func showlistImageView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.listImageView.hidden = false
            self.listImageView.alpha = 1
        }, completion: nil)
    }
    
    func bringBackDatMessage() {
        self.messageImageView.center = CGPoint(x: self.originalMessageLocationX, y: self.originalMessageLocationY)
        delay(1) {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.messageFeedImageView.center.y += self.messageViewContentSpaceY
            }, completion: nil)
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
