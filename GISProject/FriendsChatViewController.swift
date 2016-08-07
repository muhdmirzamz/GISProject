//
//  FriendsChatViewController.swift
//  GISProject
//
//  Created by XINGYU on 12/6/16.
//  Copyright © 2016 NYP. All rights reserved.
//  reference to David Kababyan

import UIKit
import FirebaseDatabase
import JSQMessagesViewController
import FirebaseStorage
import Firebase
import Photos
import IDMPhotoBrowser
import SCLAlertView

class FriendsChatViewController: JSQMessagesViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate {
    
    var friend : Friends!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let kAVATARSTATE = "avatarState"
    let kFIRSTRUN = "firstRun"
    
    
    var locationManager: CLLocationManager!
    var coordinate: CLLocationCoordinate2D!
    
    
    var messages: [JSQMessage] = []
    var objects: [NSDictionary] = []
    var loaded: [NSDictionary] = []
    
    var avatarImagesDictionary: NSMutableDictionary?
    var avatarDictionary: NSMutableDictionary?
    
    var showAvatars: Bool = false
    var firstLoad: Bool?
    
    var recent: NSDictionary?
    var chatRoomId: String!
    var initialLoadComlete: Bool = false
    
    var senderKey : String!
    var friendsKey : String!
    var senderName : String!
    var validChat:Bool!
    var me : Friends!
    
    //firebase reference
    let ref = FIRDatabase.database().reference().child("FriendsModule/messages/")
    let refMembers = FIRDatabase.database().reference().child("FriendsModule/members/")
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    
    
    
    override func viewWillAppear(animated: Bool) {
        loadUserDefaults()
        
     
        
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        // ClearRecentCounter(chatRoomId)
        ref.removeAllObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize sendder key
        self.senderId = senderKey
        self.senderDisplayName = friendsKey
        
        //initialize if chat member has mine key in his friends list
        self.validChat = false;
        
        //look for my name
        let myKey = FIRDatabase.database().reference().child("Account/\(self.senderKey)")
        myKey.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            for record in snapshot.children {
                // Get user value
                let baseDamage = snapshot.value!["Base Damage"] as! Int
                let online = snapshot.value!["KEY_ISONLINE"] as! Bool
                let monstersKilled = snapshot.value!["Monsters killed"] as! Int
                let username = snapshot.value!["Name"] as! String
                let ThumbnailImgUrl = snapshot.value!["profileImage"] as! String
                let level = snapshot.value!["Level"] as! Int
                let lat = snapshot.value!["lat"] as! Double
                let lng = snapshot.value!["lng"] as! Double
                let myKey = snapshot.key
                
                self.me = Friends(bDamage: baseDamage,
                    online: online,
                    monstKilled: monstersKilled,
                    name: username,
                    thumbnailImgUrl: ThumbnailImgUrl,
                    level: level,
                    latitude: lat,
                    longtitude: lng,
                    myKey: myKey)
            }
        })
        
        
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        let refUsers = FIRDatabase.database().reference().child("Friend/\(self.friendsKey)")
        
        //start looking into the chat members friends list
        //look for once
        refUsers.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            
            //assign return value
            print("have?")
            print(snapshot.hasChild("\(uid)"))
            self.validChat = snapshot.hasChild("\(uid)")
            print("result result: \(self.validChat)")
            
            
            if(self.validChat == true){
                
                //set chat room title
                self.navigationItem.title = self.friend.Name
                
                //no avatar yet
                self.collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
                self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
                
                //get avatar from firebase db or datastorage
                self.getAvatars()
                
                //look for room key
                self.lookForKey()
                
                self.inputToolbar?.contentView?.textView?.placeHolder = "New Message"
                
                //testing purposes
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_person_2x"), style: UIBarButtonItemStyle.Plain, target: self, action: "addTapped:")
                
                //enable spring effect
                self.collectionView!.collectionViewLayout.springinessEnabled = true
                
                //look for my name
                let myKey = FIRDatabase.database().reference().child("Account/\(self.senderKey)")
                myKey.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                    for record in snapshot.children {
                        let username = snapshot.value!["Name"] as! String
                        self.senderName = username
                    }
                })
                
            }else{
                //create aleart
                var refreshAlert = UIAlertController(title: "Reminder", message: "Ask \(self.friend.Name)", preferredStyle: UIAlertControllerStyle.Alert)
                
                //pop back to friends detail view controller
                refreshAlert.addAction(UIAlertAction(title: "Scan Later", style: .Cancel, handler: { (action: UIAlertAction!) in
                    print("Later")
                    
                    let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("FriendsViewController")
                    self.navigationController?.popViewControllerAnimated(true)
                    
                }))
                
                //change to qr code view and allow for scanning
                refreshAlert.addAction(UIAlertAction(title: "Scan My Card Now!", style: .Default, handler: { (action: UIAlertAction!) in
                    print("Go Scan Now!")
                    self.dismissViewControllerAnimated(true, completion: nil)
                   // let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("qrViewController")
                   // self.showViewController(vc as! UIViewController, sender: vc)
                    
                }))
                
                self.presentViewController(refreshAlert, animated: true, completion: nil)
            }
        })
        
        
        //location manager
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        print("have location manager")
        locationManager!.startUpdatingLocation()
        
        
        
        
    }
    func addTapped (sender:UIButton) {
        print("add pressed")
        
        //display profile images
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont.systemFontOfSize(30, weight: UIFontWeightLight),
            kTitleHeight: 60,
            kButtonFont: UIFont.systemFontOfSize(18, weight: UIFontWeightLight),
            showCloseButton: false,
            showCircularIcon: true,
            kCircleIconHeight: 80,
            kCircleHeight: 85,
            hideWhenBackgroundViewIsTapped: true
            
        )
        
        //show profile images
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            
            let profileImage = FIRDatabase.database().reference().child("Account/\(self.friendsKey)")
            var image: UIImage?
            
            let decodedData = NSData(base64EncodedString: (self.friend.ThumbnailImgUrl), options: NSDataBase64DecodingOptions(rawValue: 0))
            
            image = UIImage(data: decodedData!)
            
            
            profileImage.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let alertView = SCLAlertView(appearance : appearance)
                    
                    if(self.friend.ThumbnailImgUrl == "profileImage"){
                        var img : UIImage! =  UIImage(named: "loading.png")
                        alertView.showInfo("\(self.friend.Name)", subTitle: "Lvl : \(self.friend.Level)", circleIconImage: JSQMessagesAvatarImageFactory.circularAvatarImage(img, withDiameter: 80))
                    }else{
                        alertView.showInfo("\(self.friend.Name)", subTitle: "Lvl : \(self.friend.Level)", circleIconImage: JSQMessagesAvatarImageFactory.circularAvatarImage(image, withDiameter: 80))
                        
                    }
                    
                })
            })
        }
        
        
    }
    //LocationManger fuctions
    func locationManagerStop() {
        locationManager!.stopUpdatingLocation()
    }
    
    //CLLocationManager Delegate
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        coordinate = newLocation.coordinate
        print(coordinate?.longitude)
        print(coordinate?.latitude)
        
    }
    
    //look for chatroom key
    func lookForKey(){
        
        refMembers.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            print("sender : \(self.senderKey)")
            print("sender : \(self.friendsKey)")
            
            
            for record in snapshot.children {
                
                
                var user1Temp : Bool = false
                var user2Temp : Bool = false
                
                var user1 = record.value!!["\(self.senderKey)"] as? Bool
                
                if(user1 != nil){
                    user1Temp = true
                }else{
                    print("user 1 not found")
                }
                
                var user2 = record.value!!["\(self.friendsKey)"] as? Bool
                
                if(user2 != nil){
                    user2Temp = true
                }else{
                    print("user 2 not found")
                }
                
                print("sender\(self.senderKey)")
                print("sender\(self.friendsKey)")
                
                
                print("aaaaaaaaaa")
                
                //if both chat members exist in the chat room record
                if(user1 == true && user2 == true){
                    print("-------- got it-------")
                    print(record.key!)
                    self.chatRoomId = record.key!
                    self.chatRoomId = record.key!
                    print("-------- got it-------")
                    self.loadmessages()
                }else{
                    
                    //here can improve on the user experience, add no chat yet message
                    print("no chat yet")
                }
                
            }
            
        })
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //JSQMessages dataSource functions
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //define cell as JSQMessage cell, confirm with the datasource
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        //look into message array
        let data = messages[indexPath.row]
        
        //if the message id is the sender, use white text color
        //else use black for receiver
        if data.senderId == self.senderKey {
            cell.textView?.textColor = UIColor.whiteColor()
        } else {
            cell.textView?.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        let data = messages[indexPath.row]
        
        return data
    }
    
    //return total number of messages
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    //JSQMessage bubble image data source
    //differentiate if the msg is incoming or outgoing
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let data = messages[indexPath.row]
        
        if data.senderId == self.senderKey {
            return outgoingBubble
        } else {
            return incomingBubble
        }
    }
    
    //display the date label when there are 3 msg
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        if indexPath.item % 3 == 0 {
            
            let message = messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        return nil
    }
    
    
    //display the label height at the correct index path with correct height
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
    }
    
    //display if the msg are being delivered
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        let message = objects[indexPath.row]
        
        let status = message["status"] as! String
        
        
        if indexPath.row == (messages.count - 1) {
            return NSAttributedString(string: status)
        } else {
            return NSAttributedString(string: "")
        }
    }
    
    //display the deliver msg for the sender
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        if outgoing(objects[indexPath.row]) {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        } else {
            return 0.0
        }
    }
    
    //assign the correct avatar for sender or receiver
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = messages[indexPath.row]
        
        
        let avatar = avatarDictionary!.objectForKey(message.senderId) as! JSQMessageAvatarImageDataSource
        
        return avatar
    }
    
    
    //send message button
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        //check if the messsage is empty
        
        //there are 3 types of message
        //normal text
        //photo image
        //location map
        if text != "" {
            sendMessage(text, date: date, picture: nil, location: nil)
        }
        
    }
    
    //accessory button
    override func didPressAccessoryButton(sender: UIButton!) {
        
        let camera = Camera(delegate_: self)
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        
        //take photo option
        let takePhoto = UIAlertAction(title: "Take Photo", style: .Default) { (alert: UIAlertAction!) -> Void in
            camera.PresentPhotoCamera(self, canEdit: true)
        }
        
        //choose photo from album
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .Default) { (alert: UIAlertAction!) -> Void in
            camera.PresentPhotoLibrary(self, canEdit: true)
        }
        
        //share your current location
        let shareLoction = UIAlertAction(title: "Share Location", style: .Default) { (alert: UIAlertAction!) -> Void in
            
            if self.haveAccessToLocation() {
                self.sendMessage(nil, date: NSDate(), picture: nil, location: "location")
            }
            
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
    
    //MARK: Helper functions
    
    func haveAccessToLocation() -> Bool {
        if let _ = self.coordinate?.latitude {
            return true
        } else {
            print("no access to location")
            return false
        }
    }
    
    // Send Message
    func sendMessage(text: String?, date: NSDate, picture: UIImage?, location: String?) {
        
        var outgoingMessage = OutgoingMessage?()
        
        //if text message
        if let text = text {
            
            outgoingMessage = OutgoingMessage(message: text, senderId: self.senderKey!, senderName: self.senderName, date: date, status: "Delivered", type: "text")
        }
        
        //send picture message
        if let pic = picture {
            
            //The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0.
            // 1 is the highest quality
            let imageData = UIImageJPEGRepresentation(pic, 0.2)
            
            outgoingMessage = OutgoingMessage(message: "Picture", pictureData: imageData!, senderId: self.senderKey!, senderName: self.senderName, date: date, status: "Delivered", type: "picture")
        }
        
        //send location
        if let _ = location {
            
            let lat: NSNumber = NSNumber(double: (self.coordinate?.latitude)!)
            let lng: NSNumber = NSNumber(double: (self.coordinate?.longitude)!)
            
            outgoingMessage = OutgoingMessage(message: "Location", latitude: lat, longitude: lng, senderId: self.senderKey!, senderName: self.senderName, date: date, status: "Delivered", type: "location")
        }
        
        
        //play message sent sound
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.finishSendingMessage()
        
        
        outgoingMessage!.sendMessage("\(self.chatRoomId)", item: outgoingMessage!.messageDictionary,receiverID: self.friendsKey)
    }
    
    
    //MARK: Load Messages
    
    func loadmessages() {
        print("load msges")
        
        let messagesQuery = FIRDatabase.database().reference().child("FriendsModule/messages/\(self.chatRoomId)").queryLimitedToLast(25)
        print(ref)
        
        ref.child("\(self.chatRoomId)").observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            print("chatroom id \(self.chatRoomId)")
            
            //check for snapshot exists
            if snapshot.exists() {
                let item = (snapshot.value as? NSDictionary)!
                
                
                
                if self.initialLoadComlete {
                    let incoming = self.insertMessage(item)
                    
                    //play incoming sound
                    if incoming {
                        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                    }
                    //finish sending msg
                    self.finishReceivingMessageAnimated(true)
                    
                } else {
                    print("no msg : \(item)")
                    self.loaded.append(item)
                }
            }else{
                print("no snapshot")
            }
            
        })
        
        
        ref.child("\(self.chatRoomId)").observeEventType(.ChildChanged, withBlock: {
            snapshot in
            
            //updated message
        })
        
        
        ref.child("\(self.chatRoomId)").observeEventType(.ChildRemoved, withBlock: {
            snapshot in
            
            //Deleted message
        })
        
        ref.child("\(self.chatRoomId)").observeSingleEventOfType(.Value, withBlock:{
            snapshot in
            print("00--> insert msg")
            self.insertMessages()
            self.finishReceivingMessageAnimated(true)
            self.initialLoadComlete = true
        })
        
    }
    
    func insertMessages() {
        
        for item in loaded {
            //create message
            print("item 9 \(item)")
            insertMessage(item)
        }
    }
    
    func insertMessage(item: NSDictionary) -> Bool {
        
        let incomingMessage = IncomingMessage(collectionView_: self.collectionView!)
        
        let message = incomingMessage.createMessage(item)
        
        objects.append(item)
        
        if(message != nil){
            messages.append(message!)
        }
        
        
        return incoming(item)
    }
    
    func incoming(item: NSDictionary) -> Bool {
        
        if self.senderKey == item["senderId"] as! String {
            print("have location")
            return false
        } else {
            return true
        }
    }
    
    func outgoing(item: NSDictionary) -> Bool {
        
        if self.senderKey == item["senderId"] as! String {
            return true
        } else {
            return false
        }
    }
    
    
    //MARK: Helper functions
    
    
    func getAvatars() {
        
        print("showAvatar")
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(30, 30)
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(30, 30)
        
        //download avatars
        avatarImageFromBackend(self.me)
        avatarImageFromBackend(self.friend)
        
        //create avatars
        createAvatars(avatarImagesDictionary)
        
    }
    
    //need to use grand central dispatch
    func avatarImageFromBackend(user: Friends) {
        
        if(user.ThumbnailImgUrl != "profileImage"){
            getImageFromURL(user.ThumbnailImgUrl as! String, result: { (image) -> Void in
                
                let imageData = UIImageJPEGRepresentation(image!, 1.0)
                
                if self.avatarImagesDictionary != nil {
                    
                    self.avatarImagesDictionary!.removeObjectForKey(user.myKey)
                    self.avatarImagesDictionary!.setObject(imageData!, forKey: user.myKey)
                } else {
                    self.avatarImagesDictionary = [user.myKey : imageData!]
                }
                self.createAvatars(self.avatarImagesDictionary)
                
            })
        }
        
    }
    
    //get images from firebase and decode
    func getImageFromURL(url: String, result: (image: UIImage?) ->Void) {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            
            let profileImage = FIRDatabase.database().reference().child("Account/\(url)")
            var image: UIImage?
            
            let decodedData = NSData(base64EncodedString: (url), options: NSDataBase64DecodingOptions(rawValue: 0))
            
            image = UIImage(data: decodedData!)
            
            
            profileImage.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    result(image: image)
                    
                })
            })
        } 
        
    }
    
    //start creating avatar
    func createAvatars(avatars: NSMutableDictionary?) {
        
        var currentUserAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "avatarPlaceholder"), diameter: 70)
        var withUserAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "avatarPlaceholder"), diameter: 70)
        
        //current user avatar
        if let avat = avatars {
            if let currentUserAvatarImage = avat.objectForKey(self.senderId!) {
                
                currentUserAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: currentUserAvatarImage as! NSData), diameter: 70)
                self.collectionView?.reloadData()
            }
        }
        //chat room user avatar
        if let avat = avatars {
            if let withUserAvatarImage = avat.objectForKey(self.friendsKey!) {
                
                withUserAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: withUserAvatarImage as! NSData), diameter: 70)
                self.collectionView?.reloadData()
            }
        }
        
        avatarDictionary = [self.senderId! : currentUserAvatar, self.friendsKey! : withUserAvatar]
    }
    
    
    
    //JSQDelegate functions
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        
        let object = objects[indexPath.row]
        
        if object["type"] as! String == "picture" {
            
            let message = messages[indexPath.row]
            
            let mediaItem = message.media as! JSQPhotoMediaItem
            
            let photos = IDMPhoto.photosWithImages([mediaItem.image])
            let browser = IDMPhotoBrowser(photos: photos)
            
            self.presentViewController(browser, animated: true, completion: nil)
        }
        
        //type location and view it in a different controller
        if object["type"] as! String == "location" {
            
            self.performSegueWithIdentifier("chatToMapSeg", sender: indexPath)
        }
        
    }
    
    
    //UIIMagePickerController functions
    //allow to choose images from photo library
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let picture = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.sendMessage(nil, date: NSDate(), picture: picture, location: nil)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "chatToMapSeg" {
            
            let indexPath = sender as! NSIndexPath
            let message = messages[indexPath.row]
            
            let mediaItem = message.media as! JSQLocationMediaItem
            
            let mapView = segue.destinationViewController as! ChatMapViewController
            mapView.location = mediaItem.location
        }
    }
    
    //MARK: UserDefaults functions
    
    func loadUserDefaults() {
        firstLoad = userDefaults.boolForKey(kFIRSTRUN)
        
        if !firstLoad! {
            userDefaults.setBool(true, forKey: kFIRSTRUN)
            userDefaults.setBool(showAvatars, forKey: kAVATARSTATE)
            userDefaults.synchronize()
        }
        
        showAvatars = userDefaults.boolForKey(kAVATARSTATE)
    }
}
