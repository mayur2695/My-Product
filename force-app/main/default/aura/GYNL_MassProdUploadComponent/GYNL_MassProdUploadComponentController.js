({
    downloadFormatedCSV : function(component, event, helper) {
        //alert(event.currentTarget.getAttribute("data-recId"));
        var formattedFileName='Null';
        if(event.currentTarget.getAttribute("data-recId")=='categoryFormat'){
            formattedFileName='GYNF_ProductCategoryUploadFormat';
        }
        else{
            formattedFileName='GYNF_ProductUploadFormat'; 
        }
        component.set("v.FormattedCSVFileId",'06955000001a1SgAAI');
        //var id = component.get("v.FormattedCSVFileId");      
        var actiondownload = component.get("c.DownloadFIle");
        actiondownload.setParams({
            "FileName": formattedFileName
        }); 
        actiondownload.setCallback(this, function(b){
            component.set("v.Baseurl", b.getReturnValue());
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": b.getReturnValue()
            })
            urlEvent.fire();
        });
        $A.enqueueAction(actiondownload);       
    },
    handleCsvFileUpload:function(component,event,helper){
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        if(event.getSource().get("v.name")=='ProductFile'){
            component.set("v.ProductFileName", fileName);
        }
        else{
            component.set("v.CategoryFileName", fileName);
        }
    },
    removeUploadedCSV: function(component,event,helper){
        if(event.getSource().get("v.name")=='productCancel'){
            component.find("CSVFileID").set("v.value", null);
            component.set("v.ProductFileName",'No File Selected..');
        }
        else{
            component.find("fileId").set("v.value", null);
            component.set("v.CategoryFileName",'No File Selected..'); 
        }
        
    },
    handleCsvFile:function(component,evt,helper){         
        var objectName='test';
        console.log('Clicked on process');
        if(evt.getSource().get("v.name")=='processCategory'){
            objectName='Category';
            var fileInput = component.find("fileId").get("v.files");
            console.log('Passes forword.');
        }
        else{
            objectName='Product';
            var fileInput = component.find("CSVFileID").get("v.files");
        }
        //alert(objectName);
        console.log('raw csv'+fileInput);
        if(fileInput){
            var file = fileInput[0];
        }
        console.log('test--->'+file);
        if(file) {
            var reader = new FileReader();
            reader.readAsText(file, 'UTF-8');
            reader.onload = function(evt) {
                var csv = evt.target.result;
                console.log('testing'+csv);
                var result = helper.CSV2JSON(component,csv,objectName);
                console.log('Test Json'+result);
                helper.createCSVObject(component, result,objectName);
            }
        }
    },
     scriptsLoaded : function(component, event, helper) {
        alert('gyansys theme loaded');
    },
})