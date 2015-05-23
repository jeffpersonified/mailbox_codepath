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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            messageImageView.center = CGPoint(x: 320 + originalMessageLocationX, y: originalMessageLocationY)
        } else if translation.x > deletePoint {
            messageImageView.center = CGPoint(x: 320 + originalMessageLocationX, y: originalMessageLocationY)
        } else if translation.x < deferPoint {
            messageImageView.center = CGPoint(x: -320 + originalMessageLocationX, y: originalMessageLocationY)
        } else if translation.x < categorizePoint {
            messageImageView.center = CGPoint(x: -320 + originalMessageLocationX, y: originalMessageLocationY)
        } else {
            messageImageView.center = CGPoint(x: originalMessageLocationX, y: originalMessageLocationY)
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
            println(newRightIconLocation)
        }
    }
}
