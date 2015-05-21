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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setIcons()
        setScrollViewHeight()
        defineMessageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {

        var panTranslation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            messageImageView.center = CGPoint(x: panTranslation.x + originalMessageLocationX, y: originalMessageLocationY)
            println(panTranslation.x)
            
        } else if sender.state == UIGestureRecognizerState.Ended {
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
    
    func setIcons() {
        leftIconImageView.alpha = 0.5
        rightIconImageView.alpha = 0.5
    }
}
