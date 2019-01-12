# Apex Settings
A simple library for managing settings such as configuration settings. Custom Metadata is used to avoid Query limits and 
to ensure efficiency (since they are cached).

Additionally, the custom metadata schema for the Settings__mdt object allow the user 
to specify different settings for prod vs sandboxes, and to allow settings which apply to both.
The intention is that the same name would be used for the setting
and the library will determine at runtime which setting it should access. For this revision, the user should ensure that
settings are not duplicated.

The user can also specify a category if desired. This allows logical groupings of related settings, and effectively 
allows name-spacing.

## Usage
1. Create a new entry in Settings__mdt; specify if the setting is only for sandboxes, only for prod, or applies to both.
2. Access the setting in code as desired:  
`String mySetting = Settings.getSetting('myName');`  
or  
`String mySetting = Settings.getSetting('myCategory', 'myName');`  

## Testing
For testing purposes, a developer can force a setting to return a specific value by overwriting the 
mockSettings list field as such:  

     Settings__mdt mockSetting = new Settings__mdt(Value__c = 'fake', Category__c = '', Name__c = 'zzzTest');
     Settings.mockedSettings.add(mockSetting);

Note: custom metadata cannot be easily manipulated in apex tests.