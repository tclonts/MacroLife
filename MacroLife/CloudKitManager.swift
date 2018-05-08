//
//  CloudKitManager.swift
//  MacroLife
//
//  Created by Tyler Clonts on 3/19/18.
//  Copyright © 2018 Tyler Clonts. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class CloudKitManager {
    
    static let shared = CloudKitManager()
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    // Save one file at a time
    func saveRecordToCloudKit(record: CKRecord, database: CKDatabase, completion: @escaping (CKRecord?, Error?) -> Void) {
        
        database.save(record, completionHandler: completion)
    }
    
    // Save all the files at once instead of one at a time. (It is Async)
    func saveRecordsToCloudKit(record: [CKRecord], database: CKDatabase, perRecordCompletion: ((CKRecord?, Error?) -> Void)?, completion: (([CKRecord]?,[CKRecordID]?, Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: record, recordIDsToDelete: nil)
        
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        operation.savePolicy = .changedKeys
        
        operation.perRecordCompletionBlock = perRecordCompletion
        operation.modifyRecordsCompletionBlock = completion
        
        database.add(operation)
        
    }
    
    // Fetch
    func fetchRecordsOf(type: String, predicate: NSPredicate = NSPredicate(value: true),
                        database: CKDatabase,
                        completion:@escaping ([CKRecord]?, Error?) -> Void) {
        
        let query = CKQuery(recordType: type, predicate: predicate)
        
        database.perform(query, inZoneWith: nil, completionHandler: completion)
        
    }
    
    func subscribeToCreationOfRecordsOf(type: String,
                                        database: CKDatabase,
                                        predicate: NSPredicate = NSPredicate(value: true),
                                        withNotificationTitle title: String?,
                                        alertBody: String?,
                                        andSoundName soundName: String?,
                                        completion: @escaping (CKSubscription?, Error?) -> Void) {
        
        let subscription = CKQuerySubscription(recordType: type, predicate: predicate, options: .firesOnRecordCreation)
        
        
        // Notification info lets us choose what will be displayed on the banner (if anything at all)
        let notificationInfo = CKNotificationInfo()
        
        notificationInfo.title = title
        notificationInfo.alertBody = alertBody
        notificationInfo.soundName = soundName
        
        subscription.notificationInfo = notificationInfo
        
        database.save(subscription, completionHandler: completion)
    }
    // MARK: - User Discoverability
    
    func requestDiscoverabilityAuthorization(completion: @escaping(CKApplicationPermissionStatus, Error?) -> Void) {
        
        CKContainer.default().status(forApplicationPermission: .userDiscoverability) { (permissionStatus, error) in
            
            // Make sure that the permission status is anything other than granted. If it is granted then we dont need to request permission again, so well call completion in the else statement
            guard permissionStatus != .granted else {completion(.granted,error); return}
            
            CKContainer.default().requestApplicationPermission(.userDiscoverability, completionHandler: completion)
        }
    }
    
    func fetchUserIdentityWith(email: String, completion: @escaping (CKUserIdentity?, Error?) -> Void) {
        CKContainer.default().discoverUserIdentity(withEmailAddress: email, completionHandler: completion)
    }
    func fetchUserIdentityWith(phoneNumber: String, completion: @escaping (CKUserIdentity?, Error?) -> Void) {
        CKContainer.default().discoverUserIdentity(withPhoneNumber: phoneNumber, completionHandler: completion)
    }
    
    //MARK: Modify records
    
    func modifyRecords(_ records: [CKRecord], database: CKDatabase, perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        operation.perRecordCompletionBlock = perRecordCompletion
        
        operation.modifyRecordsCompletionBlock = { (records, recordIDs, error) -> Void in
            completion?(records, error)
        }
        
        publicDB.add(operation)
    }
    
    // MARK: - Sharing
    
    var sharingZoneID: CKRecordZoneID = {
        return CKRecordZoneID(zoneName: "EntrySharingZone", ownerName: CKCurrentUserDefaultName)
    }()
    
    func createSharingZone() {
        let sharingZoneHasBeenCreatedKey = "SharingZoneHasBeenCreated"
        
        guard UserDefaults.standard.bool(forKey: sharingZoneHasBeenCreatedKey) == false else { return }
        
        let sharingZone = CKRecordZone(zoneID: sharingZoneID)
        
        let modifyZonesOperation = CKModifyRecordZonesOperation(recordZonesToSave: [sharingZone], recordZoneIDsToDelete: nil)
        
        modifyZonesOperation.modifyRecordZonesCompletionBlock = { (_, _, error) in
            
            if let error = error {
                print("Error saving sharing zone to Cloudkit: \(error.localizedDescription)")
            } else {
                UserDefaults.standard.set(true, forKey: sharingZoneHasBeenCreatedKey)
            }
        }
        CKContainer.default().privateCloudDatabase.add(modifyZonesOperation)
    }
    
    func createCloudSharingControllerWith(cloudKitSharable: CloudKitSharable) -> UICloudSharingController {
        
        let cloudSharingController = UICloudSharingController { (cloudSharingController, preparationCompletionHandler) in
            
            cloudSharingController.availablePermissions = []
            
            let share = CKShare(rootRecord: cloudKitSharable.cloudKitRecord)
            
            share.setValue(cloudKitSharable.title, forKey: CKShareTitleKey)
            share.setValue(kCFBundleIdentifierKey, forKey: CKShareTypeKey)
            
            CloudKitManager.shared.saveRecordsToCloudKit(record: [cloudKitSharable.cloudKitRecord, share], database: CKContainer.default().privateCloudDatabase, perRecordCompletion: nil, completion: { (_, _, error) in
                
                if let error = error {
                    print("Error saving share: \(error.localizedDescription)")
                }
                
                preparationCompletionHandler(share, CKContainer.default(), error)
            })
        }
        
        return cloudSharingController
    }
    
    func acceptShareWith(cloudKitShareMetadata: CKShareMetadata, completion: @escaping () -> Void) {
        let acceptShareOperation = CKAcceptSharesOperation(shareMetadatas: [cloudKitShareMetadata])
        
        acceptShareOperation.qualityOfService = .userInteractive
        
        var savedZoneIDs: [[String: String]] = UserDefaults.standard.value(forKey: "sharedRecordUserRecordIDs") as? [[String: String]] ?? []
        
        acceptShareOperation.perShareCompletionBlock = { (metadata, share, error) in
            
            if let error = error { print(error.localizedDescription) }
            
            savedZoneIDs.append(metadata.rootRecordID.zoneID.dictionaryRepresentation)
        }
        
        acceptShareOperation.acceptSharesCompletionBlock = { error in
            
            if let error = error { print(error.localizedDescription) }
            
            UserDefaults.standard.set(savedZoneIDs, forKey: "sharedRecordUserRecordIDs")
            
            completion()
        }
        
        CKContainer(identifier: cloudKitShareMetadata.containerIdentifier).add(acceptShareOperation)
    }
    // Fetching Shared Records
    func fetchSharedRecords(completion: @escaping ([CKRecord]) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Entry", predicate: predicate)
        
        guard let zoneIDDictionaries = UserDefaults.standard.value(forKey: "sharedRecordUserRecordIDs") as? [[String: String]], zoneIDDictionaries.count > 0 else { completion([]); return }
        
        let zoneIDs = zoneIDDictionaries.flatMap({ CKRecordZoneID(dictionary: $0) })
        
        let group = DispatchGroup()
        
        var sharedRecords: [CKRecord] = []
        
        for zoneID in zoneIDs {
            
            group.enter()
            
            CKContainer.default().sharedCloudDatabase.perform(query, inZoneWith: zoneID) { (records, error) in
                if let error = error { print("Error fetching shared records: \(error.localizedDescription)") }
                
                guard let records = records else { return }
                
                sharedRecords.append(contentsOf: records)
                
                group.leave()
            }
            
        }
        
        group.notify(queue: DispatchQueue.main) {
            completion(sharedRecords)
        }
    }
    
}

extension CKRecordZoneID {
    
    var dictionaryRepresentation: [String: String] {
        return ["zoneName": zoneName, "ownerName": ownerName]
    }
    
    convenience init?(dictionary: [String: String]) {
        guard let zoneName = dictionary["zoneName"],
            let ownerName = dictionary["ownerName"] else { return nil}
        
        
        self.init(zoneName: zoneName, ownerName: ownerName)
    }
}

protocol CloudKitSharable {
    var title: String { get set }
    var cloudKitRecord: CKRecord { get }
}

