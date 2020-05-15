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
            // Today
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "Today")
            template.row1Column1TextProvider.tintColor = Constants.compColor
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "--")
            
            // Current Streak
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "Yesterday")
            template.row2Column1TextProvider.tintColor = Constants.compColor
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: "--")
            
            
            // Current Streak
            template.row3Column1TextProvider = CLKSimpleTextProvider(text: "Streak")
            template.row3Column1TextProvider.tintColor = Constants.compColor
            template.row3Column2TextProvider = CLKSimpleTextProvider(text: "--")
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallColumnsText()
            
            // Today
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "Today")
            template.row1Column1TextProvider.tintColor = Constants.compColor
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "--")
            
            // Current Streak
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "Yesterday")
            template.row2Column1TextProvider.tintColor = Constants.compColor
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: "--")
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
        case .circularSmall:
            let template = CLKComplicationTemplateModularSmallSimpleText()
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeSimpleText()
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
            largeTemplate.row1Column1TextProvider.tintColor = Constants.compColor
            largeTemplate.row1Column2TextProvider = CLKSimpleTextProvider(text: "--")
            
            // Current Streak
            largeTemplate.row2Column1TextProvider = CLKSimpleTextProvider(text: "Yesterday")
            largeTemplate.row2Column1TextProvider.tintColor = Constants.compColor
            largeTemplate.row2Column2TextProvider = CLKSimpleTextProvider(text: "--")
            
            
            // Current Streak
            largeTemplate.row3Column1TextProvider = CLKSimpleTextProvider(text: "Streak")
            largeTemplate.row3Column1TextProvider.tintColor = Constants.compColor
            largeTemplate.row3Column2TextProvider = CLKSimpleTextProvider(text: "--")
            
            template = largeTemplate
            
        case .modularSmall:
            let smallTemplate = CLKComplicationTemplateModularSmallColumnsText()
            
            // Today
            smallTemplate.row1Column1TextProvider = CLKSimpleTextProvider(text: "Today")
            smallTemplate.row1Column1TextProvider.tintColor = Constants.compColor
            smallTemplate.row1Column2TextProvider = CLKSimpleTextProvider(text: "--")
            
            // Current Streak
            smallTemplate.row2Column1TextProvider = CLKSimpleTextProvider(text: "Yesterday")
            smallTemplate.row2Column1TextProvider.tintColor = Constants.compColor
            smallTemplate.row2Column2TextProvider = CLKSimpleTextProvider(text: "--")
            template = smallTemplate
        
        case .utilitarianLarge:
            let largeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
            largeTemplate.textProvider = CLKSimpleTextProvider(text: "-- Contributions Today")
            template = largeTemplate
        case .utilitarianSmall:
            let smallTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
            smallTemplate.textProvider = CLKSimpleTextProvider(text: "-- Commits")
            template = smallTemplate
        case .circularSmall:
            let smallTemplate = CLKComplicationTemplateModularSmallSimpleText()
            smallTemplate.textProvider = CLKSimpleTextProvider(text: "--")
            
            template = smallTemplate
        case .extraLarge:
            let largeTemplate = CLKComplicationTemplateExtraLargeSimpleText()
            largeTemplate.textProvider = CLKSimpleTextProvider(text: "--")
            
            template = largeTemplate
        default: break
            
        }
        handler(template)
    }
    
}
