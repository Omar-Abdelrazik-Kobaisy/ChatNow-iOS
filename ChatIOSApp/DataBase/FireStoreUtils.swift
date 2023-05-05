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
    
    func getAllMessages(roomID : String , onCompleteDelegate : @escaping ([Message])->(Void)){
        
        var messages : [Message] = []
        
        db?.collection(Constant.PRIVATEROOM_COLLECTION_REFERENCE).document(roomID).collection(Constant.MESSAGE_COLLECTION_REFERENCE).order(by: "dateTime").addSnapshotListener({ querySnapshot, error in
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
                    if doc.type == .added {
                        guard let requset = ModelController().convert(dictionary: doc.document.data(), ToObj: Request()) else{ return }
                        requests.append(requset)
                    }
                }
                onCompleteDelegate(requests)
            }
        })
    }
}
