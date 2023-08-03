public class LexSessionController {
    
    public static String fetchUserSessionId(){
        String sessionId = '';
        // Refer to the Page
        PageReference sessionIdPage = Page.getSessionId;
        // Get the content of the VF page
        String vfContent = '';
        if(test.isRunningTest()) {
            vfContent = 'StartItIsTestSessionIdEnd';
        }
        else vfContent = sessionIdPage.getContent().toString();
        System.debug(vfContent);
        // Find the position of Start and End
        Integer startPosition = vfContent.indexOf('Start') + 'Start'.length(),
        endPosition = vfContent.indexOf('End');
        // Get the Session Id
        sessionId = vfContent.substring(startPosition, endPosition);
        System.debug('sessionId '+sessionId);
        // Return Session Id
        return sessionId;
    }
}