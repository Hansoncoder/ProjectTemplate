# ProjectTemplate
这是一个Swift项目模板，包含了TableView基本重用协议、JSON转Model、网络API统一封装处理

## 步骤
- 将Library/Modules/Resource三个文件夹,Podfile 文件拖到项目中.
- info.plis位置修改 路径改到 ProjectName/Resource/info.plist
- 删除copy的info.plist。路径：TARGETS---Build Phases --- Copy Bundle Resource.
- 修改 Podfile 文件中的 `SwiftTemplate` 为你的项目名`Your ProjectName`
- 执行`pod install`安装库，运行项目
```bash
# 由于我用的是HTTP，需要在 info.plist 配置如下Key才能请求数据
<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>
</plist>

``

## 项目结构

```bash
├── Library #这个看名称就知道
│   ├── ClassExtension  # 扩展
│   ├── Project # 项目HUD封装
│   ├── Protocol # 协议
│   ├── Refresh # Refresh
│   └── Utils # 公共工具
├── Modules
│   ├── Base # 基类模块
│   ├── Launching # 启动模块，UI跳转管理
│   ├── Network # 网络API封装模块
│   ├── ModuleA # 你的业务内容模块A
│   └── ModuleB # 你的业务内容模块B
└── Resource
    ├── Assets.xcassets # 图片资源
    ├── Base.lproj 
    └── Info.plist
```

### TableView
```swift
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
```

```swift
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
```
[img](screen.png)
