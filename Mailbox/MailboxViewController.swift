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
    
    var messageScrollViewHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollViewHeight()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setScrollViewHeight() {
        messageScrollViewHeight = searchImageView.frame.height + helpLabelImageView.frame.height + messageImageView.frame.height + messageFeedImageView.frame.height
        messagesScrollView.contentSize = CGSize(width: 320, height: messageScrollViewHeight)
    }
}
