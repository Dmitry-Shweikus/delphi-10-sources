
{******************************************}
{                                          }
{             FastScript v1.8              }
{                  Chart                   }
{                                          }
{  (c) 2003-2005 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_ichartrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_itools, fs_iformsrtti, Chart,
  Series, TeEngine, TeeProcs, TeCanvas;


type
  TfsChartRTTI = class(TComponent); // fake component


implementation

type
  TFunctions = class(TObject)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
  public
    constructor Create;
    destructor Destroy; override;
  end;

var
  Functions: TFunctions;


{ TFunctions }

constructor TFunctions.Create;
begin
  with fsGlobalUnit do
  begin
    AddedBy := Self;
    AddType('TChartValue', fvtFloat);
    AddEnum('TLegendStyle', 'lsAuto, lsSeries, lsValues, lsLastValues');
    AddEnum('TLegendAlignment', 'laLeft, laRight, laTop, laBottom');
    AddEnum('TLegendTextStyle', 'ltsPlain, ltsLeftValue, ltsRightValue, ltsLeftPercent,' +
      'ltsRightPercent, ltsXValue');
    AddEnum('TChartListOrder', 'loNone, loAscending, loDescending');
    AddEnum('TGradientDirection', 'gdTopBottom, gdBottomTop, gdLeftRight, gdRightLeft');
    AddEnum('TSeriesMarksStyle', 'smsValue, smsPercent, smsLabel, smsLabelPercent, ' +
      'smsLabelValue, smsLegend, smsPercentTotal, smsLabelPercentTotal, smsXValue');
    AddEnum('TAxisLabelStyle', 'talAuto, talNone, talValue, talMark, talText');
    AddEnum('THorizAxis', 'aTopAxis, aBottomAxis');
    AddEnum('TVertAxis', 'aLeftAxis, aRightAxis');
    AddEnum('TTeeBackImageMode', 'pbmStretch, pbmTile, pbmCenter');
    AddEnum('TPanningMode', 'pmNone, pmHorizontal, pmVertical, pmBoth');
    AddEnum('TSeriesPointerStyle', 'psRectangle, psCircle, psTriangle, ' +
      'psDownTriangle, psCross, psDiagCross, psStar, psDiamond, psSmallDot');
    AddEnum('TMultiArea', 'maNone, maStacked, maStacked100');
    AddEnum('TMultiBar', 'mbNone, mbSide, mbStacked, mbStacked100');
    AddEnum('TBarStyle', 'bsRectangle, bsPyramid, bsInvPyramid, bsCilinder, ' +
      'bsEllipse, bsArrow, bsRectGradient');

    AddClass(TChartValueList, 'TPersistent');
    AddClass(TChartAxisTitle, 'TPersistent');
    AddClass(TChartAxis, 'TPersistent');
    AddClass(TCustomChartLegend, 'TPersistent');
    AddClass(TChartLegend, 'TCustomChartLegend');
    AddClass(TSeriesMarks, 'TPersistent');
    AddClass(TChartGradient, 'TPersistent');
    AddClass(TChartWall, 'TPersistent');
    AddClass(TChartBrush, 'TBrush');
    AddClass(TChartTitle, 'TPersistent');
    AddClass(TView3DOptions, 'TPersistent');
    with AddClass(TChartSeries, 'TComponent') do
    begin
      AddMethod('procedure Clear', CallMethod);
      AddMethod('procedure Add(const AValue: Double; const ALabel: String; AColor: TColor)', CallMethod);
    end;
    AddClass(TSeriesPointer, 'TPersistent');
    AddClass(TCustomSeries, 'TChartSeries');
    AddClass(TLineSeries, 'TCustomSeries');
    AddClass(TPointSeries, 'TCustomSeries');
    AddClass(TAreaSeries, 'TCustomSeries');
    AddClass(TCustomBarSeries, 'TChartSeries');
    AddClass(TBarSeries, 'TCustomBarSeries');
    AddClass(THorizBarSeries, 'TCustomBarSeries');
    AddClass(TCircledSeries, 'TChartSeries');
    AddClass(TPieSeries, 'TCircledSeries');
    AddClass(TFastLineSeries, 'TChartSeries');
    AddClass(TCustomChart, 'TWinControl');
    AddClass(TChart, 'TCustomChart');

    AddedBy := nil;
  end;
end;

destructor TFunctions.Destroy;
begin
  if fsGlobalUnit <> nil then
    fsGlobalUnit.RemoveItems(Self);
  inherited;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
begin
  Result := 0;

  if ClassType = TChartSeries then
  begin
    if MethodName = 'CLEAR' then
      TChartSeries(Instance).Clear
    else if MethodName = 'ADD' then
      TChartSeries(Instance).Add(Params[0], Params[1], Params[2])
  end
end;


initialization
  Functions := TFunctions.Create;

finalization
  Functions.Free;


end.
