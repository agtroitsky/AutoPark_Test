program AutoPark;

uses
  Vcl.Forms,
  AutoPark_Main in 'AutoPark_Main.pas' {frmAutoParkMain},
  AutoPark_Data in 'AutoPark_Data.pas' {dmAutoPark: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmAutoParkMain, frmAutoParkMain);
  Application.CreateForm(TdmAutoPark, dmAutoPark);
  Application.Run;
end.
