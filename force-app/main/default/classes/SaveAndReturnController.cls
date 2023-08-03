public with sharing class SaveAndReturnController
{
    private ApexPages.StandardController controller;

    public SaveAndReturnController(ApexPages.StandardController controller)
    {
        this.controller = controller;
    }

    public PageReference saveAndReturn()
    {
        PageReference cancel = controller.cancel();
        controller.save();
        return cancel;
    }
}