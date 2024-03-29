//
//  PostApi.swift
//  DevGetPost
//
//  Created by Rakesh Kumar Sahoo on 30/01/24.
//

import UIKit

class PostApi: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextView!
    
    var titleField: String? = ""
    var bodyField: String? = ""
    
    var userPostService = UserPostService()
    var newPost: UserPost = UserPost(userId: 0, id: 0, title: "", body: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func postButton(_ sender: Any) {
        guard let titleField = titleTextField.text else {return}
        guard let bodyField = bodyTextField.text else{return}
        newPost.userId = 11
        newPost.id = 101
        newPost.title = titleField
        newPost.body = bodyField
        hitCreatePosts()
    }
   
        func hitCreatePosts() {
            userPostService.createNewPost(completion: { result in
                switch result {
                case .success(let success):
                    print("Create post successfully: \(success)")
                case .failure(let failure):
                    switch failure {
                    case .encodingError:
                        print("Encoding Error")
                    case .decodingError:
                        print("Decoding Error")
                    case .invalidUrl:
                        print("Invalid url found")
                    case .noData:
                        print("No data found")
                    }
                }
            }, with: newPost)
        }
}
