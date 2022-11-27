//
//  CharacterDetailViewController.swift
//  BreakingBad
//
//  Created by Mustafa Çiçek on 27.11.2022.
//

import UIKit
import Kingfisher

final class CharacterDetailViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var characterName: UILabel!
    @IBOutlet private weak var nickName: UILabel!
    @IBOutlet private weak var birthday: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Variables
    var selectedCharacter: CharacterElement?
    var allQuotes: Quotes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllQuotesByID()
        initDelegates()
        configure()
    
        
    }
    // MARK: Private Functions
    
    private func getAllQuotesByID() {
        CharacterDetailService.shared.getCharacterQuotes(by: selectedCharacter?.charID ?? 0) { [weak self] quotes, error in
            if let quotes = quotes {
                self?.allQuotes = quotes
                self?.tableView.reloadData()
                print(quotes)
            }
            else {
                print(error?.localizedDescription)
            }
        }
    }
    
    private func initDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configure() {
        guard let url = URL(string: selectedCharacter?.img ?? "") else { return }
        self.imageView.kf.setImage(with:  url)
        characterName.text = selectedCharacter?.name
        nickName.text = selectedCharacter?.nickname
        birthday.text = selectedCharacter?.birthday
        self.navigationItem.title = selectedCharacter?.name
    }
    
   

}


extension CharacterDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allQuotes?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
extension CharacterDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")
          if (cell == nil) {
              cell = UITableViewCell(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier:"cellReuseIdentifier")
          }
        cell!.textLabel?.text = allQuotes?[indexPath.row].quote
          return cell!
    }
    
}
