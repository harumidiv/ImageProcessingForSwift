//
//  ViewController.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

final class ViewController: UIViewController {
    struct ImageProcessingData {
        let viewController: UIViewController
        let title: String
    }

    lazy var imageProcessingList: [ImageProcessingData] = [
        .init(viewController: ChannelSwapViewController.loadFromNib(),
              title: "チャンネル切り替え"),
        .init(viewController: GrayscaleConversionViewController.loadFromNib(),
              title: "グレースケール化"),
        .init(viewController: BinarizationViewController.loadFromNib(),
              title: "二値化")
    ]

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageProcessingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = imageProcessingList[indexPath.row].title
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.present(imageProcessingList[indexPath.row].viewController, animated: true)
    }
}
