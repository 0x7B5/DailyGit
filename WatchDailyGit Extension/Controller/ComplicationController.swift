//
//  ComplicationController.swift
//  WatchDailyGit Extension
//
//  Created by Vlad Munteanu on 12/26/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        switch complication.family {
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeColumns()
            
            //GPA
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "GPA")
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "4.0")
            //Absences
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "Absences")
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: "0")
            
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: "0")
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        default:
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        var template: CLKComplicationTemplate?
        switch complication.family {
        case .modularLarge:
            let largeTemplate = CLKComplicationTemplateModularLargeColumns()
            
            // Today
            largeTemplate.row1Column1TextProvider = CLKSimpleTextProvider(text: "Today")
            largeTemplate.row1Column2TextProvider = CLKSimpleTextProvider(text: "--")
            // Current Streak
            largeTemplate.row2Column1TextProvider = CLKSimpleTextProvider(text: "Current Streak")
            largeTemplate.row2Column2TextProvider = CLKSimpleTextProvider(text: "--")
            
            template = largeTemplate
            
        case .modularSmall:
            let smallTemplate = CLKComplicationTemplateModularSmallSimpleText()
            smallTemplate.textProvider = CLKSimpleTextProvider(text: "--")
            template = smallTemplate
        default: break
            
        }
        handler(template)
    }
    
}
