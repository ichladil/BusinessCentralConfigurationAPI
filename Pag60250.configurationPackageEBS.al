page 60250 "configurationPackageEBS"
{
    PageType = API;
    Caption = 'configurationPackageEBS';
    APIPublisher = 'essence';
    APIGroup = 'configuration';
    APIVersion = 'beta';
    EntityName = 'package';
    EntitySetName = 'packages';
    SourceTable = "Config. Package";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(code; Code)
                {
                    Caption = 'code';
                    ApplicationArea = All;
                }

                field(packageName; "Package Name")
                {
                    Caption = 'packageName';
                    ApplicationArea = All;
                }

                field(noOfTables; "No. of Tables")
                {
                    caption = 'noOfTables';
                    ApplicationArea = All;
                }

                field(noOfRecords; "No. of Records")
                {
                    Caption = 'noOfRecords';
                    ApplicationArea = All;
                }

                field(noOfErrors; "No. of Errors")
                {
                    Caption = 'noOfErrors';
                    ApplicationArea = All;
                }

                field(productVersion; "Product Version")
                {
                    Caption = 'productVersion';
                    ApplicationArea = All;
                }

                field(processingOrder; "Processing Order")
                {
                    Caption = 'processingOrder';
                    ApplicationArea = All;
                }

                field(importStatus; "Import Status")
                {
                    Caption = 'importStatus';
                    ApplicationArea = All;
                }

                field(applyStatus; "Apply Status")
                {
                    Caption = 'applyStatus';
                    ApplicationArea = All;
                }

            }
        }
    }

    [ServiceEnabled()]
    procedure importPackageFromFile(fileName: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
    begin
        FileManagement.BLOBImportFromServerFile(TempBlob, fileName);
        ImportPackageFromBLOB(TempBlob);
    end;

    local procedure importPackageFromBLOB(var TempBlob: Codeunit "Temp Blob")
    var
        ConfigXMLExchange: Codeunit "Config. XML Exchange";
        TempDecompressedBlob: Codeunit "Temp Blob";
        InStr: InStream;
    begin
        ConfigXMLExchange.DecompressPackageToBlob(TempBlob, TempDecompressedBlob);
        TempDecompressedBlob.CreateInStream(InStr);
        if not ConfigXMLExchange.ImportPackageXMLWithCodeFromStream(InStr, Code) then
            Error('Unable to process package import');
    end;

    [ServiceEnabled()]
    procedure applyPackage(): Boolean
    var
        ConfigPackageTable: Record "Config. Package Table";
        ConfigPackageManagement: Codeunit "Config. Package Management";
        ErrorCount: Integer;
    begin
        ConfigPackageTable.SETRANGE("Package Code", Code);
        ErrorCount := ConfigPackageManagement.ApplyPackage(Rec, ConfigPackageTable, TRUE);
        exit(ErrorCount = 0);
    end;
}