
{******************************************}
{                                          }
{             FastScript v1.8              }
{               DB controls                }
{                                          }
{  (c) 2003-2005 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_idbctrlsrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_itools, fs_iformsrtti, fs_idbrtti, DB
{$IFDEF CLX}
, QDBCtrls, QDBGrids
{$ELSE}
, DBCtrls, DBGrids
{$ENDIF};


type
  TfsDBCtrlsRTTI = class(TComponent); // fake component


implementation

type
  THackDBLookupControl = class(TDBLookupControl);

  TFunctions = class(TObject)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
    function GetProp(Instance: TObject; ClassType: TClass;
      const PropName: String): Variant;
    procedure SetProp(Instance: TObject; ClassType: TClass;
      const PropName: String; Value: Variant);
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
    AddEnumSet('TButtonSet', 'nbFirst, nbPrior, nbNext, nbLast,' +
      'nbInsert, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh');
    AddEnum('TColumnButtonStyle', 'cbsAuto, cbsEllipsis, cbsNone');
    AddEnumSet('TDBGridOptions', 'dgEditing, dgAlwaysShowEditor, dgTitles,' +
      'dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect,' +
      'dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect');

    AddClass(TDBEdit, 'TWinControl');
    AddClass(TDBText, 'TGraphicControl');
    with AddClass(TDBCheckBox, 'TWinControl') do
      AddProperty('Checked', 'Boolean', GetProp, nil);
    with AddClass(TDBComboBox, 'TCustomComboBox') do
      AddProperty('Text', 'String', GetProp, nil);
    AddClass(TDBListBox, 'TCustomListBox');
    with AddClass(TDBRadioGroup, 'TWinControl') do
    begin
      AddProperty('ItemIndex', 'Integer', GetProp, nil);
      AddProperty('Value', 'String', GetProp, nil);
    end;
    AddClass(TDBMemo, 'TWinControl');
    AddClass(TDBImage, 'TCustomControl');
    AddClass(TDBNavigator, 'TWinControl');
    with AddClass(TDBLookupControl, 'TCustomControl') do
      AddProperty('KeyValue', 'Variant', GetProp, SetProp);
    with AddClass(TDBLookupListBox, 'TDBLookupControl') do
      AddProperty('SelectedItem', 'String', GetProp, nil);
    with AddClass(TDBLookupComboBox, 'TDBLookupControl') do
      AddProperty('Text', 'String', GetProp, nil);
    AddClass(TColumnTitle, 'TPersistent');
    AddClass(TColumn, 'TPersistent');
    with AddClass(TDBGridColumns, 'TCollection') do
    begin
      AddMethod('function Add: TColumn', CallMethod);
      AddMethod('procedure RebuildColumns', CallMethod);
      AddMethod('procedure RestoreDefaults', CallMethod);
      AddDefaultProperty('Items', 'Integer', 'TColumn', CallMethod, True);
    end;
    AddClass(TDBGrid, 'TWinControl');

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

  if ClassType = TDBGridColumns then
  begin
    if MethodName = 'ADD' then
      Result := Integer(TDBGridColumns(Instance).Add)
    else if MethodName = 'ITEMS.GET' then
      Result := Integer(TDBGridColumns(Instance).Items[Params[0]])
    else if MethodName = 'REBUILDCOLUMNS' then
      TDBGridColumns(Instance).RebuildColumns
    else if MethodName = 'RESTOREDEFAULTS' then
      TDBGridColumns(Instance).RestoreDefaults
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TDBCheckBox then
  begin
    if PropName = 'CHECKED' then
      Result := TDBCheckBox(Instance).Checked
  end
  else if ClassType = TDBComboBox then
  begin
    if PropName = 'TEXT' then
      Result := TDBComboBox(Instance).Text
  end
  else if ClassType = TDBRadioGroup then
  begin
    if PropName = 'ITEMINDEX' then
      Result := TDBRadioGroup(Instance).ItemIndex
    else if PropName = 'VALUE' then
      Result := TDBRadioGroup(Instance).Value
  end
  else if ClassType = TDBLookupControl then
  begin
    if PropName = 'KEYVALUE' then
      Result := THackDBLookupControl(Instance).KeyValue
  end
  else if ClassType = TDBLookupListBox then
  begin
    if PropName = 'SELECTEDITEM' then
      Result := TDBLookupListBox(Instance).SelectedItem
  end
  else if ClassType = TDBLookupComboBox then
  begin
    if PropName = 'TEXT' then
      Result := TDBLookupComboBox(Instance).Text
  end
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TDBLookupControl then
  begin
    if PropName = 'KEYVALUE' then
      THackDBLookupControl(Instance).KeyValue := Value
  end
end;


initialization
  Functions := TFunctions.Create;

finalization
  Functions.Free;


end.
