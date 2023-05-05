//
//  FriendRequestViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 27/04/2023.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI
class FriendRequestViewController: BaseViewController {

    
    @IBOutlet weak var tableV: UITableView!
    var viewModel : FriendRequestViewModel?
    var requestsArr : [Request]?
    var reloadTV : ReloadTableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableV.layer.cornerRadius = 15
        tableV.layer.masksToBounds = true
        tableV.register(UINib(nibName: "FriendRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "request")
        viewModel = FriendRequestViewModel()
        viewModel?.navigator = self
        viewModel?.fetchAllRequestFromDB()
        viewModel?.bindingAllRequest = {[weak self] requests in
            self?.requestsArr = requests
            DispatchQueue.main.async {
                //reload table here
                self?.tableV.reloadData()
            }
        }
    }

}

extension FriendRequestViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        requestsArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableV.dequeueReusableCell(withIdentifier: "request", for: indexPath) as! FriendRequestTableViewCell
        cell.userName.text = requestsArr?[indexPath.row].requestFromName
        if let imageREF = StorageUtils.sharedInstance.storageReference?.child(requestsArr?[indexPath.row].requestFromImage ?? "noImage") {
            cell.userImage.sd_setImage(with: imageREF, placeholderImage: UIImage(named: "1"))
        } else{
            print(" error in loading image in setting ")
        }
        cell.onClickTableViewDelegate = self
        return cell
    }
    
    
}

extension FriendRequestViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected")
    }
}
extension FriendRequestViewController : OnClickTableViewDelegate {
    func onReject(friend: FriendRequestTableViewCell) {
        print("rejected")
    }
    
    func onConfirm(friend: FriendRequestTableViewCell) {
        guard let friendId = requestsArr?[tableV.indexPath(for: friend)?.row ?? 999].requestFromId else { return }
        print(friendId)
        viewModel?.addFriendToDB(friendID: friendId , reloadTV: reloadTV)
    }
}
