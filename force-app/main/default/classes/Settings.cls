/**
 * Class for managing settings such as configuration settings
 * @author mlockett
 * @date 2019-01-12
 */

global virtual with sharing class Settings {
   private final static String DUP_EXCEPTION_MESSAGE = 'More than one setting for category "{0}" with name "{1}"';
   private final static String MISSING_EXCEPTION_MESSAGE = 'There is no setting for category "{0}" with name "{1}"';

   @TestVisible
   private static Boolean orgIsSandbox;

   // allows overwriting settings for testing purposes
   @TestVisible
   private static List<Settings__mdt> mockedSettings = new List<Settings__mdt>();

   global class MissingSettingsException extends Exception {
   }
   global class DuplicateSettingsException extends Exception {
   }

   /**
    * Returns the setting value for the given name/category or null
    *
    * @param category
    * @param name
    *
    * @exception DuplicateSettingsException
    * @exception MissingSettingsException
    *
    * @return string
    */
   global static String getSetting(String category, String name) {

      List<Settings__mdt> settings = [
            SELECT
                  Value__c
            FROM Settings__mdt
            WHERE Category__c = :category
            AND Name__c = :name
            AND OrgType__c IN ('All', :OrgType)
      ];
      return getReturnValue(settings, category, name);
   }
   /**
    * Returns the setting value for the given name with no category or null
    *
    * @param name
    * @exception DuplicateSettingsException
    * @exception MissingSettingsException
    *
    * @return
    */
   global static String getSetting(String name) {
      List<Settings__mdt> settings = [
            SELECT
                  Value__c
            FROM Settings__mdt
            WHERE Category__c = ''
            AND Name__c = :name
            AND OrgType__c IN ('All', :OrgType)
      ];

      return getReturnValue(settings, '', name);
   }

   @TestVisible
   private static String getReturnValue(List<Settings__mdt> settings, String category, String name) {
      for(Settings__mdt setting: mockedSettings){
         if(setting.Category__c == category && setting.Name__c == name){
            return setting.Value__c;
         }
      }
      // there should only be one
      if (settings.size() == 1) {
         return settings[0].Value__c;
      } else if (settings.size() > 1) {// if there is more than one, throw a dupe exception
         throw new DuplicateSettingsException(String.format(DUP_EXCEPTION_MESSAGE, new List<String>{
               category, name
         }));
      }
      //if there are none, throw a missing exception
      throw new MissingSettingsException(String.format(MISSING_EXCEPTION_MESSAGE, new List<String>{
            category, name
      }));
   }

   // scratch orgs are identified as sandboxes
   global static Boolean IsSandbox {
      get {
         if (orgIsSandbox == null) {
            orgIsSandbox = [SELECT IsSandbox FROM Organization LIMIT 1][0].IsSandbox;
         }
         return orgIsSandbox;
      }
      private set;
   }

   /**
    * Returns 'Sandbox' for sandboxes and scratch orgs; returns 'Prod' for Prod and Developer orgs
    */
   global static String OrgType {
      get {
         if (IsSandbox) { // scratch orgs are identified as sandboxes
            return 'Sandbox';
         }
         return 'Prod';
      }
      private set;
   }
}