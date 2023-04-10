program AutoPark;

uses
  Vcl.Forms,
  AutoPark_Main in 'AutoPark_Main.pas' {frmAutoParkMain},
  AutoPark_Data in 'AutoPark_Data.pas' {dmAutoPark: TDataModule},
  uPathList in 'uPathList.pas' {frmPathList},
  uCar in 'uCar.pas' {frmCar},
  uCommon in 'uCommon.pas',
  uList in 'uList.pas' {frmList},
  uCarModel in 'uCarModel.pas' {frmCarModel},
  uPers in 'uPers.pas' {frmPers},
  uView in 'uView.pas' {frmView},
  uExport in 'uExport.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmAutoParkMain, frmAutoParkMain);
  Application.CreateForm(TdmAutoPark, dmAutoPark);
  Application.CreateForm(TfrmPathList, frmPathList);
  Application.CreateForm(TfrmCar, frmCar);
  Application.CreateForm(TfrmList, frmList);
  Application.CreateForm(TfrmCarModel, frmCarModel);
  Application.CreateForm(TfrmPers, frmPers);
  Application.CreateForm(TfrmView, frmView);
  Application.Run;
end.
