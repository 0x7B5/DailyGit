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
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "T:")
            template.row1Column1TextProvider.tintColor = Constants.compColor
            template.row1Column2TextProvider = CLKSimpleTextProvider(text: "--")
            
            // Current Streak
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "Y:")
            template.row2Column1TextProvider.tintColor = Constants.compColor
            template.row2Column2TextProvider = CLKSimpleTextProvider(text: "--")
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        case .utilitarianLarge:
            let largeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
            largeTemplate.textProvider = CLKSimpleTextProvider(text: "-- Contributions Today")
            largeTemplate.textProvider.tintColor = Constants.compColor
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: largeTemplate)
            handler(timelineEntry)
            
        case .utilitarianSmall:
            let smallTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
            smallTemplate.textProvider = CLKSimpleTextProvider(text: "-- Commits")
            smallTemplate.textProvider.tintColor = Constants.compColor
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: smallTemplate)
            handler(timelineEntry)
        case .circularSmall:
            let smallTemplate = CLKComplicationTemplateCircularSmallSimpleText()
            smallTemplate.textProvider = CLKSimpleTextProvider(text: "--")
            smallTemplate.textProvider.tintColor = Constants.compColor
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: smallTemplate)
            handler(timelineEntry)
        case .extraLarge:
            let largeTemplate = CLKComplicationTemplateExtraLargeSimpleText()
            largeTemplate.textProvider = CLKSimpleTextProvider(text: "--")
            largeTemplate.textProvider.tintColor = Constants.compColor
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: largeTemplate)
            handler(timelineEntry)
            
        case .graphicCircular:
            let myTemp = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
            myTemp.centerTextProvider = CLKSimpleTextProvider(text:"--")
            myTemp.bottomTextProvider = CLKSimpleTextProvider(text: "")
            myTemp.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: Constants.compColor, fillFraction: 1)
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: myTemp)
            handler(timelineEntry)
        case .graphicRectangular:
            let rectTemplate = CLKComplicationTemplateGraphicRectangularStandardBody()
            
            // Today
            rectTemplate.headerTextProvider = CLKSimpleTextProvider(text: "Today: --")
            rectTemplate.headerTextProvider.tintColor = Constants.compColor
            
            rectTemplate.body1TextProvider = CLKSimpleTextProvider(text:"Yesterday: --")
            rectTemplate.body1TextProvider.tintColor = Constants.compColor
            rectTemplate.body2TextProvider = CLKSimpleTextProvider(text:"-- day streak!")
            rectTemplate.body2TextProvider!.tintColor = Constants.compColor
            
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: rectTemplate)
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
            smallTemplate.row1Column1TextProvider = CLKSimpleTextProvider(text: "T:")
            smallTemplate.row1Column1TextProvider.tintColor = Constants.compColor
            smallTemplate.row1Column2TextProvider = CLKSimpleTextProvider(text: "00")
            
            // Current Streak
            smallTemplate.row2Column1TextProvider = CLKSimpleTextProvider(text: "Y:")
            smallTemplate.row2Column1TextProvider.tintColor = Constants.compColor
            smallTemplate.row2Column2TextProvider = CLKSimpleTextProvider(text: "00")
            template = smallTemplate
            
        case .utilitarianLarge:
            let largeTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
            largeTemplate.textProvider = CLKSimpleTextProvider(text: "-- Contributions Today")
            largeTemplate.textProvider.tintColor = Constants.compColor
            template = largeTemplate
        case .utilitarianSmall:
            let smallTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
            smallTemplate.textProvider = CLKSimpleTextProvider(text: "-- Commits")
            smallTemplate.textProvider.tintColor = Constants.compColor
            template = smallTemplate
        case .circularSmall:
            let smallTemplate = CLKComplicationTemplateCircularSmallSimpleText()
            smallTemplate.textProvider = CLKSimpleTextProvider(text: "--")
            smallTemplate.textProvider.tintColor = Constants.compColor
            template = smallTemplate
        case .extraLarge:
            let largeTemplate = CLKComplicationTemplateExtraLargeSimpleText()
            largeTemplate.textProvider = CLKSimpleTextProvider(text: "--")
            largeTemplate.textProvider.tintColor = Constants.compColor
            
            template = largeTemplate
        case .graphicCircular:
            let myTemp = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText()
            myTemp.centerTextProvider = CLKSimpleTextProvider(text:"--")
            myTemp.bottomTextProvider = CLKSimpleTextProvider(text: "")
            myTemp.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: Constants.compColor, fillFraction: 1)
            
            template = myTemp
        case .graphicRectangular:
            let rectTemplate = CLKComplicationTemplateGraphicRectangularStandardBody()
            
            // Today
            rectTemplate.headerTextProvider = CLKSimpleTextProvider(text: "Today: --")
            rectTemplate.headerTextProvider.tintColor = Constants.compColor
            
            rectTemplate.body1TextProvider = CLKSimpleTextProvider(text:"Yesterday: --")
            rectTemplate.body1TextProvider.tintColor = Constants.compColor
            rectTemplate.body2TextProvider = CLKSimpleTextProvider(text:"-- day streak!")
            rectTemplate.body2TextProvider!.tintColor = Constants.compColor
            
            template = rectTemplate
        default: break
            
        }
        handler(template)
    }
    
}
