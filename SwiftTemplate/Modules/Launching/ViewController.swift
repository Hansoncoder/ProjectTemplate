//
//  ViewController.swift
//  iOS_YHYTMJ
//
//  Created by Hanson on 2019/8/5.
//  Copyright © 2019 Hanson. All rights reserved.
//

import UIKit

class HLListModel: Mappable {
    var id: String?
    var detailURL: String?
    var image: String?
    var name: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        detailURL <- map["detailURL"]
        image <- map["image"]
        name <- map["name"]
    }
}

class ViewController: UIViewController {

    internal var dataList: [HLListModel]?
    lazy var tableView: UITableView = {[unowned self] in
        let tableView = TableViewFactory.createTableView(self)
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.registerClassOf(UITableViewCell.self)
        LTRefresh.addHeaderRefresh(to: tableView, target: self, action: #selector(getNewsData))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        getNewsData()
    }
    
}

//MARK: - network
extension ViewController {

    @objc func getNewsData() {
        if !LTRefresh.refreshing(in: tableView) {
            LTHUD.show(.progress)
        }
        
        NetworkManager.manager.fetchDataWithAPI(api: LTAPI(.home)) {[weak self] (result, _, _) in
            self?.endRefresh()
            result.ifSuccess {
                printLog(result.value)
                
                let data = JSON(result.value as Any)
                guard let dataArray = data.arrayObject else {return} // 数据格式判断
                let models:[HLListModel] = Mapper<HLListModel>().mapArray(JSONObject: dataArray)!
                self?.dataList = models
                self?.tableView.reloadData()
                return;
            }
            // 错误处理
        }
    }
    
    func endRefresh() {
        LTHUD.hide()
        LTRefresh.endHeaderRefresh(tableView)
        LTRefresh.endFooterRefresh(tableView)
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell()
        cell.textLabel?.text = dataList![indexPath.row].name
        return cell
    }
    
}
