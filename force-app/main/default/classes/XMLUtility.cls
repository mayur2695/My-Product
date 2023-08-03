public class XMLUtility {
    private static List<string> listofProperty = new List<string>();
    private static List<String> ListfirstProperty = new List<String>();
    private static List<String> ListsecondProperty = new List<String>();
    private static Dom.XMLNode node;
    private static List<Dom.XMLNode> nodesOfInterest;
    private static Map<String,List<Dom.XMLNode>> nodesOfInterestMap;
    private static Integer typesParsed = 0;
    
    public static List<String> processXML(String xml, Set<String> typesToParse){ 
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        node = doc.getRootElement();
        nodesOfInterestMap = new Map<String,List<Dom.XMLNode>>();
        String nodeName = node.getName();
        //Keep processing the XML until all the targeted entity types are not processed
        while(typesParsed != typesToParse.size()){      
            //Get all child nodes for the current node                            
            Dom.XmlNode[] childNodes = node.getChildElements();
            //Process all child nodes and match them with all entries on typesToParse
            processNodes(node.getAttribute('Name', ''), childNodes, typesToParse);
        }
        system.debug('nodesOfInterestMap.values()'+nodesOfInterestMap);
        for(String eachKey : nodesOfInterestMap.keyset()){
            for(Dom.XmlNode eachproperty : nodesOfInterestMap.get(eachKey)){
                
                if(eachKey.containsIgnoreCase('item')){
                   system.debug('eachKey'+eachKey.contains('item'));
                  ListsecondProperty.add(eachproperty.getAttributeValue('Name', '')); 
                  system.debug('List of Property'+eachproperty.getAttributeValue('Name', ''));
                }
                else{
                  ListfirstProperty.add(eachproperty.getAttributeValue('Name', ''));  
                }
            }
        }
        ListfirstProperty.add('\r\n');
        ListofProperty.addAll(ListfirstProperty);
        system.debug('List of Property11'+ListofProperty);
        ListofProperty.addAll(ListsecondProperty);
        system.debug('List of Property22'+ListofProperty);
        return ListofProperty;
    }
    
    public static void processNodes(String parentNodeName, Dom.XmlNode[] childNodes, Set<String> typesToParse){
        //Loop over each child node for the current parent node
        for(Dom.XmlNode eachChild : childNodes){
            //Check if the child node name is EntityType
            if(eachChild.getName() == 'EntityType'){
                //If child node's Name attribute is in the typesToParse Set, execute recursion to get the children for this node
                if(typesToParse.contains(eachChild.getAttribute('Name', ''))){
                    processNodes(eachChild.getAttribute('Name', ''), eachChild.getChildElements(), typesToParse);
                    typesParsed+=1;
                }
            }
            //This segment would be executed in the recursion runs.
            //Would give the Property nodes for the current Entity Type
            else if(eachChild.getName() == 'Property'){
                if(!nodesOfInterestMap.containsKey(parentNodeName)){
                    nodesOfInterestMap.put(parentNodeName, new List<Dom.XmlNode>{eachChild});
                }
                else{
                    Dom.XmlNode[] childNodesTemp = nodesOfInterestMap.get(parentNodeName);
                    childNodesTemp.add(eachChild);
                    nodesOfInterestMap.put(parentNodeName, childNodesTemp);
                }
            }
            else if(childNodes.size() == 1){
                node = eachChild;
            }
        }
    }
}