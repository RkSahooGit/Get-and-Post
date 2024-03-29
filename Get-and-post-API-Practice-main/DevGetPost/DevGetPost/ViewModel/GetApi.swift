//
//  ViewController.swift
//  DevGetPost
//
//  Created by Rakesh Kumar Sahoo on 30/01/24.
//

import UIKit

class GetApi: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var userPostService = UserPostService()
    var resultPosts: [UserPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GetXib", bundle: nil), forCellReuseIdentifier: "table cell")
        hitGetAllPosts()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultPosts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "table cell", for: indexPath) as! GetXib
        cell.userIdLabel.text = String(resultPosts[indexPath.row].userId)
        cell.idLabel.text = String(resultPosts[indexPath.row].id)
        cell.titleLabel.text = resultPosts[indexPath.row].title
        cell.bodyLabel.text = resultPosts[indexPath.row].body
        return cell
    }
    func hitGetAllPosts() {
        userPostService.getAllPosts {[weak self] result in
            switch result {
            case .success(let success):
                self?.resultPosts =  success
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                switch error {
                case .invalidUrl:
                    print("Invalid URL Error")
                case .noData:
                    print("No data found")
                case .decodingError:
                    print("Decoding Error")
                }
            }
        }
    }
}
    
    

