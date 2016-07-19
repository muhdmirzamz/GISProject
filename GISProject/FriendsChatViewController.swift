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
import FirebaseStorage
import Firebase
import Photos


class FriendsChatViewController: JSQMessagesViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
    
    var storageRef:FIRStorageReference!
    
    var objects: [NSDictionary] = []
    var loaded: [NSDictionary] = []
    
    let ref = FIRDatabase.database().reference().child("FriendsModule/messages")
    
    var chatRoomId: String!
    
    var initialLoadComlete: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addTapped))
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: #selector(addTapped))
        
        print("Entered room \(chatRoomId)")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_person_2x"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(addTapped))
        
        
        self.navigationItem.title = friend.Name
        messages.removeAll()
        setupBubbles()
        
        // No avatars
        collectionView!.collectionViewLayout.springinessEnabled = true
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 28, height: 28)
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 28, height: 28)
        
        self.inputToolbar?.contentView?.textView?.placeHolder = "New Message"
        
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
        
        // [START configurestorage]
        storageRef = FIRStorage.storage().reference().child("FriendsModule/friendList/8899")
        // [END configurestorage]
        
         
       
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        print("--->did finished picking media info")
        print(info)
        
        picker.dismissViewControllerAnimated(true, completion:nil)
        
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let photo = JSQPhotoMediaItem(image: selectedPhoto)
        
        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo!))
        
        // if it's a photo from the library, not an image from the camera
        if #available(iOS 8.0, *), let referenceUrl = info[UIImagePickerControllerReferenceURL] {
            let assets = PHAsset.fetchAssetsWithALAssetURLs([referenceUrl as! NSURL], options: nil)
            let asset = assets.firstObject
            asset?.requestContentEditingInputWithOptions(nil, completionHandler: { (contentEditingInput,info) in
                let imageFile = contentEditingInput?.fullSizeImageURL
                let filePath = FIRAuth.auth()!.currentUser!.uid +
                    "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000))/\(imageFile!.lastPathComponent!)"
                // [START uploadimage]
                self.storageRef.child(filePath)
                    .putFile(imageFile!, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Error uploading: \(error)")
                           // self.urlTextView.text = "Upload Failed"
                            return
                        }
                        self.uploadSuccess(metadata!, storagePath: filePath)
                }
                // [END uploadimage]
            })
        } else {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            let imagePath = FIRAuth.auth()!.currentUser!.uid +
                "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000)).jpg"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            self.storageRef.child(imagePath)
                .putData(imageData!, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print("Error uploading: \(error)")
                       // self.urlTextView.text = "Upload Failed"
                        return
                    }
                    self.uploadSuccess(metadata!, storagePath: imagePath)
            }
        }
        
        
        
        
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        
        // messages.append(JSQMessage()
    }
    
    //  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    //     <#code#>
    //  }
    
    
    func uploadSuccess(metadata: FIRStorageMetadata, storagePath: String) {
        print("Upload Succeeded!")
     //  self.urlTextView.text = metadata.downloadURL()!.absoluteString
        NSUserDefaults.standardUserDefaults().setObject(storagePath, forKey: "storagePath")
        NSUserDefaults.standardUserDefaults().synchronize()
       // self.downloadPicButton.enabled = true
    }
    
    
    func addTapped (sender:UIButton) {
        print("add pressed")
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
    
    
    /*
     
     //creating msg
     func addMessage(id: String, text: String) {
     let message = JSQMessage(senderId: id, displayName: self.friend.Name text: text)
     messages.append(message)
     }
     */
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
            //cell.textView!.textColor = UIColor.whiteColor()
        } else {
            
            cell.textView!.textColor = UIColor.blackColor()
            
        }
        
        return cell
    }
    
    
    //insert msg into firebase
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
                                     senderDisplayName: String!, date: NSDate!) {
        
        /*
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        messages.append(message)
        
        
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
        
        self.finishReceivingMessage()
        */
        if text != "" {
            sendMessage(text, date: date, picture: nil, location: nil)
        }
        
    }
      func sendMessage(text: String?, date: NSDate, picture: UIImage?, location: String?) {
        
        var outgoingMessage = OutgoingMessage?()
        
        //if text message
        if let text = text {
            outgoingMessage = OutgoingMessage(message: text, senderId: senderId, senderName: senderDisplayName, date: date, status: "Delivered", type: "text")
            
           
        }
        //play message sent sound
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.finishSendingMessage()
        
        outgoingMessage!.sendMessage("chatroom1", item: outgoingMessage!.messageDictionary)
        
    }
    
    private func observeMessages() {
        /*
        let messagesQuery = FIRDatabase.database().reference().child("FriendsModule/myFriend/Chats/users/\(senderId)").queryLimitedToLast(25)
        
        
        
        
        
        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot!) in
            // 3
            let id = snapshot.value!["senderId"] as! String
            let text = snapshot.value!["text"] as! String
            let chatMember = snapshot.value!["chatMember"] as! String
            
            // 4
            if(chatMember == self.friend.Name && id == self.senderId)
            {
                //self.addMessage(id, text: text)
            }
            */
        
        /*
          let refMembers = FIRDatabase.database().reference().child("FriendsModule/members/")
        let refMessages = FIRDatabase.database().reference().child("FriendsModule/messages/")
        var keyfound : String!
        var foundMsg : String!
        
        refMembers.observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot!) in
            // 3
            let id = snapshot.value!["\(self.friend.Name)"] as! Bool
            let chatMember = snapshot.value!["\(self.senderId)"] as! Bool
            
            
            
            // 4
            if(chatMember == true && id == true)
            {
                //self.addMessage(id, text: text)
                print("success\(id)---\(chatMember)")
                 print("success---\(self.friend.Name)---\(self.senderId)")
                print(snapshot.key)
                keyfound = snapshot.key
               
            }
            if(keyfound != nil){
                
                
                
                refMessages.observeEventType(FIRDataEventType.Value) { (snapshot1: FIRDataSnapshot!) in
                    
                    print("90909090")
                    print(snapshot1.hasChild(keyfound))
                    
                    
                    if(snapshot1.hasChild(keyfound) == true){
                        
                    // print(  snapshot1.childSnapshotForPath(keyfound).value!["message"] as! String)
                        
                        print("found in message")
                        
                       
                        
                    }
                    
                
                
                }
                // self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
            }
                         // 5
            self.finishReceivingMessage()
        }
        
        */
        

    }
    
    func lookforMessage(fKey : String){
        
    }
    
    //pressed accessory button
    override func didPressAccessoryButton(sender: UIButton!) {
        print("Accessory btn pressed!")
        
        /*
         let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
         
         let takePhoto = UIAlertAction(title: "Take Photo", style: .Default) { (alert: UIAlertAction!) -> Void in
         
         }
         
         let sharePhoto = UIAlertAction(title: "Photo Library", style: .Default) { (alert: UIAlertAction!) -> Void in
         
         let imagePicker = UIImagePickerController()
         imagePicker.delegate = self
         self.presentViewController(imagePicker, animated: true, completion: nil)
         
         
         
         }
         
         let shareLoction = UIAlertAction(title: "Share Location", style: .Default) { (alert: UIAlertAction!) -> Void in
         
         
         }
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert : UIAlertAction!) -> Void in
         
         print("Cancel")
         }
         
         optionMenu.addAction(takePhoto)
         optionMenu.addAction(sharePhoto)
         optionMenu.addAction(shareLoction)
         optionMenu.addAction(cancelAction)
         
         self.presentViewController(optionMenu, animated: true, completion: nil)
         
         */
        let camera = Camera(delegate_: self)
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .Default) { (alert: UIAlertAction!) -> Void in
            camera.PresentPhotoCamera(self, canEdit: true)
        }
        
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .Default) { (alert: UIAlertAction!) -> Void in
            camera.PresentPhotoLibrary(self, canEdit: true)
        }
        
        let shareLoction = UIAlertAction(title: "Share Location", style: .Default) { (alert: UIAlertAction!) -> Void in
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert : UIAlertAction!) -> Void in
            
            print("Cancel")
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(shareLoction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
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
