//
//  ViewController.swift
//  JarusTask
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 23/12/20.
//

struct Assignment: Codable {
    let id: Int
    let vin: String?
    let year: Int?
    let make: String?
    let value: Double
    let length: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case vin
        case year
        case make
        case value
        case length
    }
}

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let kHeaderSectionTag: Int = 6900;
    var collapseTable : UITableView!
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    
    var assignments : [Assignment]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat =  view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        let titleLable : UILabel = UILabel.init(frame: CGRect(x: 0, y: barHeight+15, width: displayWidth, height: 40))
        titleLable.text = "Choose Equipment"
        titleLable.textAlignment = .center
        titleLable.font = .boldSystemFont(ofSize: 25)
        
        self.view.addSubview(titleLable)
        
        
        collapseTable = UITableView(frame: CGRect(x: 0, y: barHeight+54, width: displayWidth, height: displayHeight - barHeight+44))
        collapseTable.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        collapseTable.dataSource = self
        collapseTable.delegate = self
        self.view.addSubview(collapseTable)
        self.collapseTable!.tableFooterView = UIView()
        
        guard let bundlePath = Bundle.main.path(forResource: "assignment", ofType: "json") else {
            return
        }
        
        do {
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
            guard let data = jsonData else { return }
            let decoder = JSONDecoder()
            self.assignments = try decoder.decode([Assignment].self, from: data)
            
            if self.assignments?.count ?? 0 > 0 {
                print("rslt:\(self.assignments ?? [])")
                self.collapseTable.reloadData()
            }
            
            } catch let err {
            
            print("Err", err)
            
            let alert = UIAlertController(title: "Failed", message: "Sorry! Data is not found. \n Note: Currently - UG Results are available.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
            

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if assignments?.count ?? 0 > 0 {
            tableView.backgroundView = nil
            return assignments?.count ?? 0
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height:     view.bounds.size.height))
            messageLabel.text = "Retrieving data.\nPlease wait."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.collapseTable.backgroundView = messageLabel;
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            return 4;
        } else {
            return 0;
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell.init()

        cell.textLabel?.textColor = UIColor.black
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "VIN : \(assignments?[indexPath.section].vin ?? "")"
            
        }else if indexPath.row == 1 {
            cell.textLabel?.text = "Year : \(assignments?[indexPath.section].year ?? 0)"
            
        }else if indexPath.row == 2 {
            cell.textLabel?.text = "Make : \(assignments?[indexPath.section].make ?? "")"
            
        }else if indexPath.row == 3 {
            cell.textLabel?.text = "Value : \(assignments?[indexPath.section].value ?? 0)"
            
        }else if indexPath.row == 4 {
            cell.textLabel?.text = "Length : \(assignments?[indexPath.section].length ?? 0)"
            
        }
        
        //cell.textLabel?.text = "\(assignments?[indexPath.row].id ?? 0) \(assignments?[indexPath.row].make ?? "")"
        
        return cell
    }



    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.assignments?.count != 0) {
            return "   \(assignments?[section].id ?? 0)  \(assignments?[section].make ?? "")"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.colorWithHexString(hexStr: "#408000")
        header.textLabel?.textColor = UIColor.white
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
        theImageView.image = UIImage(named: "Chevron-Dn-Wht")
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
        let theImageView2 = UIImageView(frame: CGRect(x: 5, y: 13, width: 18, height: 18));
        theImageView2.image = UIImage(named: "checkBox")
        header.addSubview(theImageView2)
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(ViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Expand / Collapse Methods
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        //let sectionData = self.sectionItems[section] as! NSArray
        
        self.expandedSectionHeaderNumber = -1;
        if (assignments?.count ?? 0 == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< (assignments?.count ?? 0) {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.collapseTable!.beginUpdates()
            self.collapseTable!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.collapseTable!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        //let sectionData = self.sectionItems[section] as! NSArray
        
        if (assignments?.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< (assignments?.count ?? 0){
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.collapseTable!.beginUpdates()
            self.collapseTable!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.collapseTable!.endUpdates()
        }
    }

}

