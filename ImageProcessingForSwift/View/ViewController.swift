//
//  ViewController.swift
//  ImageProcessingForSwift
//
//  Created by 佐川 晴海 on 2022/09/17.
//

import UIKit

final class ViewController: UIViewController {
    struct ImageProcessingSection {
        let sectionTitle: String
        let dmageProcessingDataList: [ImageProcessingData]
    }
    
    struct ImageProcessingData {
        let viewController: UIViewController
        let title: String
    }
    
    let imageProcessingList: [ImageProcessingSection] = [
        .init(sectionTitle: "画像",
              dmageProcessingDataList: [
                .init(viewController: ChannelSwapViewController.loadFromNib(),
                      title: "チャンネル切り替え"),
                .init(viewController: GrayscaleConversionViewController.loadFromNib(),
                      title: "グレースケール化"),
                .init(viewController: BinarizationViewController.loadFromNib(),
                      title: "二値化"),
                .init(viewController: BackgroundSubtractionViewController.loadFromNib(),
                      title: "背景差分法")
              ]),
        .init(sectionTitle: "動画",
              dmageProcessingDataList: [
                .init(viewController: FrameSubtractionViewController.loadFromNib(),
                      title: "フレーム間差分法")
              ])
    ]

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let indexPath = tableView.indexPathForSelectedRow {
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return imageProcessingList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
        return imageProcessingList[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageProcessingList[section].dmageProcessingDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = imageProcessingList[indexPath.section].dmageProcessingDataList[indexPath.row].title
        return cell
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = imageProcessingList[indexPath.section].dmageProcessingDataList[indexPath.row].viewController
        self.present(vc, animated: true)
    }
}
