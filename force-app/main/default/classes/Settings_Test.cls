/**
 * @author mlockett
 * @date 2019-01-12
 */
@IsTest
private class Settings_Test {
   @IsTest
   private static void getWorks(){
      String result = Settings.getSetting('', 'zzzTest');
      System.assertEquals('All test', result);
   }

   @IsTest
   private static void settingCanBeOverwrittenInTest(){
      Settings__mdt mockSetting = new Settings__mdt(Value__c = 'fake', Category__c = '', Name__c = 'zzzTest');
      Settings.mockedSettings.add(mockSetting);

      String result = Settings.getSetting('', 'zzzTest');
      System.assertEquals('fake', result);
   }

   @IsTest
   private static void getWorksForProd(){
      Settings.orgIsSandbox = false;
      String result = Settings.getSetting('', 'zzzTest');
      System.assertEquals('Prod test', result);
   }

   @IsTest
   private static void getThrowsMissingException(){
      try{
         Settings.getSetting('My silly setting');
         System.assert(false, 'Should have thrown exception');
      }
      catch(Settings.MissingSettingsException e){
         // this is the expected result
      }
   }

   @IsTest
   private static void throwsDupExceptionForMultiples(){
      List<Settings__mdt> mySettings = new List<Settings__mdt>();
      mySettings.add(new Settings__mdt(Name__c='Foo', Value__c='FooVal', OrgType__c='All'));
      mySettings.add(new Settings__mdt(Name__c='Foo', Value__c='FooVal', OrgType__c='All'));

      try {
         Settings.getReturnValue(mySettings, 'a', 'b');
         System.assert(false, 'Should have thrown');
      }
      catch(Settings.DuplicateSettingsException e){
         // this is the desired result
      }
   }
}