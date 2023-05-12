//
//  FireStoreUtils.swift
//  ChatIOSApp
//
//  Created by Omar on 17/04/2023.
//
import Firebase
import FirebaseCore
import FirebaseFirestore
class FireStoreUtils {
    
    static let sharedInstance = FireStoreUtils()
    let db: Firestore?
    private init(){
        db = Firestore.firestore()
    }
    
    func addUser(user : User , onCompleteDelegate : @escaping (Error?) -> Void){
        
        db?.collection(Constant.USER_COLLECTION_REFERENCE).document(user.id ?? "").setData(ModelController().convert(from: user).toDictionary,completion: { error in
            print(ModelController().convert(from: user).toDictionary)
            onCompleteDelegate(error)
        })
    }
    
    func getUser(uid : String , onCompleteDelegate : @escaping (User , Error?)->(Void)){
        db?.collection(Constant.USER_COLLECTION_REFERENCE)
            .document(uid).getDocument(completion: { doc, error in
                
                guard let doc = doc  else { return }
                print(ModelController().convert(dictionary: doc.data() ?? [:], ToObj: User()) ?? User())
                guard let user = ModelController().convert(dictionary: doc.data() ?? [:], ToObj: User()) else { return }
                onCompleteDelegate(user , error)
                
            })
    }
    
    func getAllUsers( onCompleteDelegate : @escaping ([User] , Error?)->(Void)){
        var users : [User] = []
        db?.collection(Constant.USER_COLLECTION_REFERENCE).getDocuments(completion: { querySnapshot, err in
            guard let querySnapshot = querySnapshot  else {
                //fail
                print("error getting documents")
                return}
            
                //success
                for document in querySnapshot.documents{
                    guard let user = ModelController().convert(dictionary: document.data() , ToObj: User()) else { return }
                    users.append(user)
                }
                
            onCompleteDelegate(users , err)
            
        })
    }
    
    func addFriend(user : User ,friend : User , onCompleteDelegate : @escaping (Error?) -> (Void)){
        let friendCollectionRef = db?.collection(Constant.USER_COLLECTION_REFERENCE).document(user.id ?? "").collection(Constant.FRIEND_COLLECTION_REFERENCE)
        friendCollectionRef?.document(friend.id ?? "").setData(ModelController().convert(from: friend).toDictionary,completion: { error in
            print(ModelController().convert(from: friend).toDictionary)
            onCompleteDelegate(error)
        })
    }
    
    func getAllFriends(uid : String ,onCompleteDelegate : @escaping ([User] , Error?)->(Void) ){
        var users : [User] = []
        db?.collection(Constant.USER_COLLECTION_REFERENCE).document(uid).collection(Constant.FRIEND_COLLECTION_REFERENCE).getDocuments(completion: { querySnapShot, error in
            guard let querySnapShot = querySnapShot else {return}
            for document in querySnapShot.documents {
                guard let user = ModelController().convert(dictionary: document.data(), ToObj: User()) else { return }
                users.append(user)
            }
            
            onCompleteDelegate(users , error)
        })
    }
    
    func sendMessage(_ message : Message , from user : User , to friend : User , rooms : [PrivateRoom]?, onCompleteDelegate : @escaping (Error?)->(Void)){
        guard let rooms = rooms else {return}
        var roomID : String = ""
        for privateRoom in rooms {
            if (privateRoom.senderID == user.id || privateRoom.senderID == friend.id)
                && (privateRoom.recieverID == friend.id || privateRoom.recieverID == user.id){
                roomID = privateRoom.id ?? ""
            }
        }
        
        
        let messageCollectionREF = db?.collection(Constant.PRIVATEROOM_COLLECTION_REFERENCE)
            .document(roomID).collection(Constant.MESSAGE_COLLECTION_REFERENCE)
        let messageDOC_REF = messageCollectionREF?.document()
        message.id = messageDOC_REF?.documentID
        messageDOC_REF?.setData(ModelController().convert(from: message).toDictionary , completion: { error in
            onCompleteDelegate(error)
        })
        
    }
    
    func createPrivateRoom(rooms : [PrivateRoom]? , room : PrivateRoom , onCompleteDelegate : @escaping (Error?)->(Void)){
        let roomCollectionREF = db?.collection(Constant.PRIVATEROOM_COLLECTION_REFERENCE)
        var roomDOC_REF: DocumentReference?

        guard let rooms = rooms else {return}
        if rooms.isEmpty{
            roomDOC_REF = roomCollectionREF?.document()
        }else{
            for privateRoom in rooms {
                if (room.senderID == privateRoom.recieverID || room.senderID == privateRoom.senderID) && (room.recieverID == privateRoom.senderID || room.recieverID == privateRoom.recieverID){
                    roomDOC_REF = roomCollectionREF?.document(privateRoom.id ?? "")
                }
            }
            if roomDOC_REF == nil {
                roomDOC_REF = roomCollectionREF?.document()
            }
        }
                room.id = roomDOC_REF?.documentID
//                roomID = room.id ?? ""
        roomDOC_REF?.setData(ModelController().convert(from: room).toDictionary , completion: { error in
            onCompleteDelegate(error)
        })
    }
    
    func getAllPrivateRoom(onCompleteDelegate : @escaping ([PrivateRoom] , Error?)->(Void)){
        var privateRooms : [PrivateRoom] = []
        db?.collection(Constant.PRIVATEROOM_COLLECTION_REFERENCE).getDocuments(completion: { querySnapshot, error in
            guard let querySnapshot = querySnapshot else { return }
            for document in querySnapshot.documents {
                guard let room = ModelController().convert(dictionary: document.data(), ToObj: PrivateRoom()) else{return}
                privateRooms.append(room)
            }
            
            onCompleteDelegate(privateRooms , error)
        })
    }
    
//    func updatePrivateRoom(room : PrivateRoom , onCompleteUpdate : @escaping (Error?)->(Void)){
//        let messageCount = UserDefaults.standard.integer(forKey: "count")
//        print(messageCount)
//        db?.collection(Constant.PRIVATEROOM_COLLECTION_REFERENCE).document(room.id ?? "").updateData(["unreadMessages" : messageCount],completion: { error in
//            onCompleteUpdate(error)
//        })
//    }
    
//    func getAllPrivateRoomAfterUpdate(onCompleteDelegate : @escaping ([PrivateRoom] , Error?)->(Void)){
//        var updatedRoom : [PrivateRoom] = []
//        db?.collection(Constant.PRIVATEROOM_COLLECTION_REFERENCE).addSnapshotListener({ querySnapshot, error in
//            guard let querySnapshot = querySnapshot else { return }
//            querySnapshot.documentChanges.forEach { doc in
//                guard let room = ModelController().convert(dictionary: doc.document.data(), ToObj: PrivateRoom())else{return}
//                if doc.type == .modified{
//                    updatedRoom.append(room)
//                }
//                updatedRoom.append(room)
//            }
//            onCompleteDelegate(updatedRoom , error)
//        })
//    }
    
    func getAllMessages(room : PrivateRoom , onCompleteDelegate : @escaping ([Message])->(Void)){
        
        var messages : [Message] = []
        
        db?.collection(Constant.PRIVATEROOM_COLLECTION_REFERENCE).document(room.id ?? "").collection(Constant.MESSAGE_COLLECTION_REFERENCE).order(by: "dateTime").addSnapshotListener({ querySnapshot, error in
            if let e = error {
                //fail
                print("error fail to get messages : \(e.localizedDescription)")
            }else{
                //success
                guard let querySnapshot = querySnapshot else { return }
                for doc in querySnapshot.documentChanges{
                    if doc.type == .added{
                        guard let message = ModelController().convert(dictionary: doc.document.data(), ToObj: Message())else{return}
                        messages.append(message)
//                        UserDefaults.standard.setValue(room.unreadMessages! + 1, forKey: "count")
                    }
                }
                onCompleteDelegate(messages)
            }
        })
    }
    
    
    func makeRequest(request : Request , to friend : User , onCompleteDelegate : @escaping (Error?)->(Void)){
        let requestDOC_REF = db?.collection(Constant.USER_COLLECTION_REFERENCE).document(friend.id ?? "").collection(Constant.REQUEST_COLLECTION_REFERENCE).document()
        request.id = requestDOC_REF?.documentID
        requestDOC_REF?.setData(ModelController().convert(from: request).toDictionary,completion: { error in
            onCompleteDelegate(error)
        })
    }
    
    func getAllRequest(user : User , onCompleteDelegate : @escaping ([Request])->(Void)){
        
        var requests : [Request] = []
        
        db?.collection(Constant.USER_COLLECTION_REFERENCE).document(user.id ?? "").collection(Constant.REQUEST_COLLECTION_REFERENCE).addSnapshotListener({ querySnapShot, error in
            if let e = error {
                //fail
                print("fail to get Requset \(e.localizedDescription)")
            }else{
                //success
                guard let querySnapShot = querySnapShot else{ return }
                for doc in querySnapShot.documentChanges{
                    guard let requset = ModelController().convert(dictionary: doc.document.data(), ToObj: Request()) else{ return }
                    if doc.type == .added {
                        requests.append(requset)
                    }
                    if doc.type == .removed {
                        print(ModelController().convert(from: requset).toDictionary)
                        doc.document.reference.delete()
                    }
                }
                onCompleteDelegate(requests)
            }
        })
    }
    
    func deleteRequest(user : User , requestId : String , onCompleteDelegate : @escaping (Error?)->(Void)){
        db?.collection(Constant.USER_COLLECTION_REFERENCE).document(user.id ?? "").collection(Constant.REQUEST_COLLECTION_REFERENCE).document(requestId).delete(completion: { error in
            onCompleteDelegate(error)
        })
    }
    
    func deleteFriend(user : User , friend : User , onCompleteDelegate : @escaping (Error?)->(Void)){
        let friendCollectionRef = db?.collection(Constant.USER_COLLECTION_REFERENCE).document(user.id ?? "").collection(Constant.FRIEND_COLLECTION_REFERENCE)
        friendCollectionRef?.document(friend.id ?? "").delete(completion: { error in
            onCompleteDelegate(error)
        })
    }
    
    func createGroupChat(_ group : Group , onCompleteDelegate : @escaping (Error?)->(Void)){
        let groupDOC_REF = db?.collection(Constant.GROUP_COLLECTION_REFERENCE).document()
        group.id = groupDOC_REF?.documentID
        groupDOC_REF?.setData(ModelController().convert(from: group).toDictionary ,completion: { error in
            onCompleteDelegate(error)
        })
    }
    func add(friend user : User ,toGroup group:Group , onCompleteDelegate : @escaping(Error?)->(Void)){
        db?.collection(Constant.GROUP_COLLECTION_REFERENCE).document(group.id ?? "").updateData(
            ["users" : FieldValue.arrayUnion([ModelController().convert(from: user).toDictionary])] , completion: { error in
                onCompleteDelegate(error)
            })
//            .addSnapshotListener({ querySnapshot, error in
//            if let e = error{
//                //fail
//                print("error while update \(e.localizedDescription)")
//            }else{
//                //success
//                guard let querySnapshot = querySnapshot else {return}
//                querySnapshot.documentChanges.forEach { doc in
//                    if doc.document.documentID == group.id ?? ""{
//                        doc.document.reference.updateData(
//                            ["users" : FieldValue.arrayUnion([ModelController().convert(from: user).toDictionary])] , completion: { error in
//                                onCompleteDelegate(error)
//                            })
//                    }
//                }
//            }
//        })
    }
    func send(_ message :GroupMessage ,to group:Group , onCompleteDelegete : @escaping (Error?)->(Void)){
        let messageDOC_REF = db?.collection(Constant.GROUP_COLLECTION_REFERENCE).document(group.id ?? "").collection(Constant.MESSAGE_COLLECTION_REFERENCE).document()
        message.id = messageDOC_REF?.documentID
        messageDOC_REF?.setData(ModelController().convert(from: message).toDictionary,completion: { error in
            onCompleteDelegete(error)
        })
    }
    
    func getAllGroupMessage(_ group : Group , onCompleteDelegete : @escaping ([GroupMessage])->(Void)){
        
        var groupMessageArr : [GroupMessage] = []
        
        db?.collection(Constant.GROUP_COLLECTION_REFERENCE).document(group.id ?? "").collection(Constant.MESSAGE_COLLECTION_REFERENCE).addSnapshotListener({ querySnapShotListener, error in
            if let e = error{
                //fail
                print("error in sending message to group \(e.localizedDescription)")
            }else{
                //success
                guard let querySnapShotListener = querySnapShotListener else { return }
                querySnapShotListener.documentChanges.forEach { doc in
                    if doc.type == .added{
                        guard let message = ModelController().convert(dictionary: doc.document.data(), ToObj: GroupMessage())else{return}
                        groupMessageArr.append(message)
                    }
                }
            }
            onCompleteDelegete(groupMessageArr)
        })
    }
    
    func getAllGroupChatForSpecificUser(onCompleteDelegate : @escaping ([Group])->(Void)){
        var groupChatArray : [Group] = []
        db?.collection(Constant.GROUP_COLLECTION_REFERENCE).addSnapshotListener({ querySnapshot, error in
            if let e = error{
                //fail
                print("fail to get groups \(e.localizedDescription)")
            }else{
                //success
                guard let doumentsChanges = querySnapshot?.documentChanges else { return }
                for doc in doumentsChanges {
                    if doc.type == .added {
                        guard let group = ModelController().convert(dictionary: doc.document.data(), ToObj: Group())else {return}
                        guard let users = group.users else { return }
                        guard let currentUser = UserProvider.getInstance.getCurrentUser() else {return}
                        for user in users{
                            if user.id == currentUser.id
                            {
                                groupChatArray.append(group)
                            }
                        }
                        
                    }
//                    if doc.type == .modified{
//                        //reload or get
//                    }
                }
                onCompleteDelegate(groupChatArray)
            }
        })
    }
}
