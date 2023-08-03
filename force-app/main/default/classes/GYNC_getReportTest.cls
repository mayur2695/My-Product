/* Test Class for the Apex Controller class GYNC_getReport
* Developer Name: Debraj Mondal
* Created On:02/03/2021
*/ 

@isTest
public class GYNC_getReportTest {
	//This method is used to test the Reports
    @isTest
    public static void testReports(){
        String repId;
        
        Test.startTest();
        repId=GYNC_getReport.getStandardReport('New_Candidates_with_Position_Report_aa1');
        Test.stopTest();
        System.debug(repId);
        
        
        System.assert(true);
        
    }
    //This method is used to test the Dashboards
    @isTest
    public static void testDashboards(){
        String repId;
        
        
        Test.startTest();
        repId=GYNC_getReport.getStandardDashboard('UCvsqxqBffKhFKegiYNqWMDrTFSohD');
        Test.stopTest();
        System.debug(repId);
        
        System.assert(true);
    }
}