//
//  FriendsChatViewController.swift
//  GISProject
//
//  Created by XINGYU on 12/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import FirebaseDatabase
import JSQMessagesViewController


class FriendsChatViewController: JSQMessagesViewController {
    
    //friends obj
    var friend : Friends!
    
    
    //JSQ msg obj
    var messages = [JSQMessage]()
    
    //2 types of msg: incoming & outgoing
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    //2 tpes of avator img
    var outgoingAvatarImage : JSQMessagesAvatarImage!
    var incomingAvatarImage : JSQMessagesAvatarImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.navigationItem.title = friend.Name
        messages.removeAll()
        setupBubbles()
        
        // No avatars
        collectionView!.collectionViewLayout.springinessEnabled = true
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 28, height: 28)
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 28, height: 28)
        
        
        // Load the image from the given URL
        //
        let nurl = NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Smiley.svg/2000px-Smiley.svg.png")
        var imageBinary : NSData?
        if nurl != nil
        {
            imageBinary = NSData(contentsOfURL: nurl!)
        }
        
        // After retrieving the image data, we convert
        // it to an UIImage object. This is an update
        // to the User Interface.
        //
        var img : UIImage!
        if imageBinary != nil
        {
            img = UIImage(data: imageBinary!)
        }
        
        outgoingAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(img!, diameter: 64)
        outgoingAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(img!, diameter: 64)
        
    }
    
    //show timestamp
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString!
    {
        let message = messages[indexPath.item]
        
        if indexPath.item == 0 {
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messages[indexPath.item - 1]
            if message.date.timeIntervalSinceDate(previousMessage.date) / 60 > 1 {
                return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
            }
        }
        if indexPath.item % 3 == 0
        {
            
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
            
        }
        return nil
    }
    
    // 送信時刻を出すために高さを調整する
    
    // make sure the timestamps have the correct heights:
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messages[indexPath.item - 1]
            let message = messages[indexPath.item]
            if message.date .timeIntervalSinceDate(previousMessage.date) / 60 > 1 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        if indexPath.item % 3 == 0
        {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
    }
    
    
    
    //display text on top of bubble msg
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat
        
    {
        if indexPath.item == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messages[indexPath.item - 1]
            let message = messages[indexPath.item]
            if message.date .timeIntervalSinceDate(previousMessage.date) / 60 > 1 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        if indexPath.item % 3 == 0
        {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
    }
    
    //load earlier messages
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!)
    {
        print("ealier msg button tapped")
    }
    
    //tap bubble event
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!)
    {
        print(indexPath.row)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //delegate methods
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    //delegate methods
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    //create img for the chat bubbles
    
    func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    
    //datasource corresponds to the msg data in the collectionView
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return outgoingAvatarImage!
    }
    
    
    
    
    //creating msg
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // messages from someone else
        // addMessage("foo", text: "Hey person!")
        // messages sent from local sender
        // addMessage(senderId, text: "Yo!")
        // addMessage(senderId, text: "I like turtles!")
        // animates the receiving of a new message on the view
        finishReceivingMessage()
        observeMessages()
    }
    
    
    //define outgoing and incoming msg color
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        
        
        
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            
            //cell.cellTopLabel!.text = senderId
            cell.messageBubbleTopLabel!.text = senderId
            cell.cellBottomLabel!.text = senderId
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            
            cell.textView!.textColor = UIColor.blackColor()
            
        }
        
        return cell
    }
    
    
    //insert msg into firebase
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
                                     senderDisplayName: String!, date: NSDate!) {
        
        
        let ref = FIRDatabase.database().reference().child("FriendsModule/myFriend/Chats/users/\(senderId)")
        
        let itemRef = ref.childByAutoId() // 1
        
        
        
        let messageItem = [ // 2
            "text": text,
            "senderId": senderId,
            "chatMember" : friend.Name
        ]
        itemRef.setValue(messageItem) // 3
        
        
        
        
        // 4
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        // 5
        finishSendingMessage()
        print("--> \(ref.childByAutoId())")
        
        
        
        
        /*
         //chats
         let ref = FIRDatabase.database().reference().child("FriendsModule/chats")
         
         let itemRef = ref.childByAutoId() // 1
         //ref.child("FriendsModule/members").childByAutoId()
         
         let messageItem = [ // 2
         "title": friend.Name,
         "lastMessage": senderId,
         "timestamp" : "123"
         ]
         itemRef.setValue(messageItem) // 3
         
         //members
         let refMember = FIRDatabase.database().reference().child("FriendsModule/members")
         let itemMember = refMember.child(itemRef.key)// 1
         
         let messageMember = [ // 2
         "\(friend.Name)": true,
         "\(senderId)": true
         
         ]
         itemMember.setValue(messageMember) // 3
         
         
         //chats
         let refMessage = FIRDatabase.database().reference().child("FriendsModule/messages")
         let itemMessage = refMessage.child(itemRef.key)// 1
         
         //random key for individual chat room
         let randomChatKey = refMessage.childByAutoId()
         
         let conversation = [ // 2
         "name" : friend.Name,
         "message": "The relay seems to be malfunctioning.",
         "timestamp": "oo"
         
         ]
         itemMessage.setValue(conversation)
         //itemMember.setValue(conversation)
         
         let refy = FIRDatabase.database().reference().child("FriendsModule/members/")
         
         
         ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
         
         for record in snapshot.children {
         
         
         
         }
         
         
         
         })
         */
        
    }
    
    private func observeMessages() {
        let messagesQuery = FIRDatabase.database().reference().child("FriendsModule/myFriend/Chats/users/\(senderId)").queryLimitedToLast(25)
        
        
        
        
        
        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot!) in
            // 3
            let id = snapshot.value!["senderId"] as! String
            let text = snapshot.value!["text"] as! String
            let chatMember = snapshot.value!["chatMember"] as! String
            
            // 4
            if(chatMember == self.friend.Name && id == self.senderId)
            {
                self.addMessage(id, text: text)
            }
            
            
            
            
            // 5
            self.finishReceivingMessage()
        }
    }
    
    //pressed accessory button
    override func didPressAccessoryButton(sender: UIButton!) {
        print("Accessory btn pressed!")
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
