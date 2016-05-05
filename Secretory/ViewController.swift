//
//  ViewController.swift
//  Secretory
//
//  Created by Ming Sun on 5/4/16.
//  Copyright © 2016 MingSun. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var thingTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordTable: UITableView!
    
    struct oneRecord{
        var dateRecord: String?
        var thingRecord: String?
    }
    var records: [oneRecord]?
    
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.layer.cornerRadius = recordButton.frame.height/2
        
        timer = NSTimer.scheduledTimerWithTimeInterval(
            1.0,
            target: self,
            selector: #selector(tick),
            userInfo: nil,
            repeats: true
        )
        
        thingTextField.returnKeyType = UIReturnKeyType.Send
        
        tableReload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if records != nil {
            return records!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TVCell") as! TVCell
        cell.thingRecordedLabel.text = records![indexPath.row].thingRecord
        cell.dateRecordedLable.text = records![indexPath.row].dateRecord
        return cell
    }
    
    func tableReload() {
        let arrayForm = loadRecord()
        records?.removeAll()
        if arrayForm.count > 0 {
            for record in arrayForm {
                let dateRecord = record.valueForKey("date") as! String
                let thingRecord = record.valueForKey("thing") as! String
                let newRecord = oneRecord(dateRecord: dateRecord, thingRecord: thingRecord)
                records?.append(newRecord)
                print(records!)
            }
            
            recordTable.reloadData()
        }
    }
    
    @IBAction func reconrdButtonPressed(sender: UIButton) {
        self.view.endEditing(true)
        saveRecord()
        tableReload()
        thingTextField.text! = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        recordButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func tick() {
        dateLable.text = NSDateFormatter.localizedStringFromDate(
            NSDate(),
            dateStyle: .MediumStyle,
            timeStyle: .MediumStyle)
    }

    func saveRecord() {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("Entity", inManagedObjectContext: managedObjectContext)
        let entity = Entity(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        entity.thing = thingTextField.text!
        entity.date = dateLable.text!
        
        do {
            try managedObjectContext.save()
            print("Saved")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func loadRecord() -> [NSManagedObject] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Entity")
        var entity: [NSManagedObject]?
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            entity = results as? [NSManagedObject]
            print("Loaded")
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return entity!
    }
}

