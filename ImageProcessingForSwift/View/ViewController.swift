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
        enum ImageProcessType {
            // 画像
            case channelSwap
            case grayScale
            case binarization
            case backgroundSubtraction
            // 動画
            case frameSubTraction
        }
        let type: ImageProcessType
        let title: String
    }
    
    let imageProcessingList: [ImageProcessingSection] = [
        .init(sectionTitle: "画像",
              dmageProcessingDataList: [
                .init(type: .channelSwap,
                      title: "チャンネル切り替え"),
                .init(type: .grayScale,
                      title: "グレースケール化"),
                .init(type: .binarization,
                      title: "二値化"),
                .init(type: .backgroundSubtraction,
                      title: "背景差分法")
              ]),
        .init(sectionTitle: "動画",
              dmageProcessingDataList: [
                .init(type: .frameSubTraction,
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "画像処理"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
        let vc: UIViewController
        
        switch imageProcessingList[indexPath.section].dmageProcessingDataList[indexPath.row].type {
        case .channelSwap:
            vc = ChannelSwapViewController.loadFromNib()
        case .grayScale:
            vc = GrayscaleConversionViewController.loadFromNib()
        case .binarization:
            vc = BinarizationViewController.loadFromNib()
        case .backgroundSubtraction:
            vc = BackgroundSubtractionViewController.loadFromNib()
        case .frameSubTraction:
            vc = FrameSubtractionViewController.loadFromNib()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
