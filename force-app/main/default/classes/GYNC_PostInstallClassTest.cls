@isTest
public class GYNC_PostInstallClassTest{
public static testMethod void testInstallScript() {
  GYNC_PostInstallClass postinstall = new GYNC_PostInstallClass();
    Test.testInstall(postinstall, null);
    Test.testInstall(postinstall, new Version(1,0), true);
    List<GYNCS_AuthorizationSetting__c> a = [Select id, name from GYNCS_AuthorizationSetting__c where name ='Default'];
    System.assertEquals(a.size(), 1, 'System not found');
  }
}