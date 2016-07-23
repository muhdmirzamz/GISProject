//
//  reference to David Kababyan


import Foundation
import UIKit
import Firebase

class OutgoingMessage {
    
    //change
   
    let refChats = FIRDatabase.database().reference().child("FriendsModule/chats")
    let refMembers = FIRDatabase.database().reference().child("FriendsModule/members")
    let refMessages = FIRDatabase.database().reference().child("FriendsModule/messages")
    
    let messageDictionary: NSMutableDictionary
    
    //chats init
    init (title: String, lastMessage: String,  date: NSDate) {
        
        messageDictionary = NSMutableDictionary(objects: [title, lastMessage, dateFormatter().stringFromDate(date)], forKeys: ["title", "lastMessage", "date"])
    }
    
    
    init (message: String, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        messageDictionary = NSMutableDictionary(objects: [message, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "senderId", "senderName", "date", "status", "type"])
    }
    
    init(message: String, latitude: NSNumber, longitude: NSNumber, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        messageDictionary = NSMutableDictionary(objects: [message, latitude, longitude, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "latitude", "longitude", "senderId", "senderName", "date", "status", "type"])
    }
    
    init (message: String, pictureData: NSData, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        let pic = pictureData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        
        messageDictionary = NSMutableDictionary(objects: [message, pic, senderId, senderName, dateFormatter().stringFromDate(date), status, type], forKeys: ["message", "picture", "senderId", "senderName", "date", "status", "type"])
    }
    
    //save to firebase
    //add
    func sendMessage(chatRoomID: String, item: NSMutableDictionary) {
        
        print("ooutoing chat romid -> \(chatRoomID)")
        
        refChats.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if snapshot.hasChild("\(chatRoomID)"){
                
                print("true rooms exist")
                
                let title : String = item["message"] as! String
                let lastMessage : String = item["message"] as! String
                var timeStamp = item["date"] as! String
                var type = item["type"] as! String
                 let senderId : String = item["senderId"] as! String
                
                //chats
                
                
                //messages
                
                let itemMessage = self.refMessages.child("\(chatRoomID)")// 1
                
                let message : String = item["message"] as! String
                
                //random key for individual chat room
                let randomChatKey = itemMessage.childByAutoId()
                
                let conversation = [ // 2
                    "name" : senderId,
                    "message": message,
                    "timestamp": timeStamp,
                    "type" : type
                    
                ]
                //itemMessage.setValue(conversation)
                itemMessage.child("/\(randomChatKey.key)").setValue(item)
                
                
                
            }else{
                
                print("false room doesn't exist")
                
                let itemChat = self.refChats.childByAutoId() // 1
                
                
                let title : String = item["message"] as! String
                let lastMessage : String = item["message"] as! String
                var timeStamp = item["date"] as! String
                var type = item["type"] as! String
                
                let chat = [ // 2
                    "title" : title,
                    "lastMessage": lastMessage,
                    "timestamp": timeStamp
                    
                ]
                
                
                itemChat.setValue(chat) // 3
                
                
                
                //members
                //same as chat key
                let itemMember = self.refMembers.child(itemChat.key)// 1
                
                
                let senderId : String = item["senderId"] as! String
                let senderName: String = item["senderName"] as! String
                
                let messageMember = [ // 2
                    "\(senderName)": true,
                    "\(senderId)": true
                    
                ]
                itemMember.setValue(messageMember) // 3
                
                
                
                //messages
                
                let itemMessage = self.refMessages.child(itemChat.key)// 1
                
                let message : String = item["message"] as! String
                
                //random key for individual chat room
                let randomChatKey = itemMessage.childByAutoId()
                
                let conversation = [ // 2
                    "name" : senderId,
                    "message": message,
                    "timestamp": timeStamp,
                    "type" : type
                    
                ]
                //itemMessage.setValue(conversation)
                itemMessage.child("/\(randomChatKey.key)").setValue(item)
                
                
            }
            
            
        })
        
        
        /*
        
         //chats
         let itemChat = refChats.childByAutoId() // 1
        
        
        let title : String = item["message"] as! String
        let lastMessage : String = item["message"] as! String
        var timeStamp = item["date"] as! String
        var type = item["type"] as! String
        
        let chat = [ // 2
            "title" : title,
            "lastMessage": lastMessage,
            "timestamp": timeStamp
            
        ]
        
        
        itemChat.setValue(chat) // 3
        
        
        
         //members
        //same as chat key
         let itemMember = refMembers.child(itemChat.key)// 1
        
        
        let senderId : String = item["senderId"] as! String
        let senderName: String = item["senderName"] as! String
         
         let messageMember = [ // 2
         "\(senderName)": true,
         "\(senderId)": true
         
         ]
         itemMember.setValue(messageMember) // 3
        
        
         
         //messages
        
         let itemMessage = refMessages.child(itemChat.key)// 1
        
        let message : String = item["message"] as! String
         
         //random key for individual chat room
         let randomChatKey = itemMessage.childByAutoId()
         
         let conversation = [ // 2
         "name" : senderId,
         "message": message,
         "timestamp": timeStamp,
         "type" : type
         
         ]
         //itemMessage.setValue(conversation)
         itemMessage.child("/\(randomChatKey.key)").setValue(conversation)
        
        
         
 */
 
       
        /*
       
        let reference = refMessages.child(chatRoomID).childByAutoId()
        
        item["messageId"] = reference.key
        
        reference.setValue(item) { (error, ref) -> Void in
            if error != nil {
                print("Error, couldnt send message")
            }
        }
*/
        
       // SendPushNotification(chatRoomID, message: (item["message"] as? String)!)
       // UpdateRecents(chatRoomID, lastMessage: (item["message"] as? String)!)
    }

    
    
}
//MARK: Helper functions

private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> NSDateFormatter {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}