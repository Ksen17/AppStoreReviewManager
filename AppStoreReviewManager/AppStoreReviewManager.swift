//
//  AppStoreReviewManager.swift
//  AppStoreReviewManager
//
//  Created by Ilia on 28/03/2019.
//  Copyright © 2019 Ilia Stukalov. All rights reserved.
//

import Foundation
import StoreKit

class AppStoreReviewManager {
    
    private let lastAskKey = "AppStoreReviewManager_LastReviewAskDate"
    
    public func askForReviewAfter(_ days: Int) {
        guard let lastAskDate = getLastReviewDate() else {
            askForReview()
            return
        }
        let daysFromLastReview = numberOfDaysfrom(lastReviewDate: lastAskDate)
        if daysFromLastReview >= days {
            askForReview()
        }
    }
    
    public func askForReviewNow() {
        askForReview()
    }
    
    private func numberOfDaysfrom(lastReviewDate: Date, to currentDate: Date = Date()) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: lastReviewDate, to: currentDate)
        return components.day ?? 0
    }
    
    private func getLastReviewDate() -> Date? {
        return UserDefaults.standard.object(forKey: lastAskKey) as? Date
    }
    
    private func updateLastReviewDate(with date: Date = Date()) {
        UserDefaults.standard.set(date, forKey: lastAskKey)
    }
    
    private func askForReview() {
        DispatchQueue.main.async {
            SKStoreReviewController.requestReview()
            self.updateLastReviewDate()
        }
    }
}
