// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: FSL Translation Library v2.0
//        (C)2005 FSL - FreeSoftLand
//
//        Translator engine unit
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------


                 

TRANSLATOR.PAS --------------------------------------------------------------




unit Translator;

interface

uses
  Forms, Windows, SysUtils, Classes, TypInfo, StdCtrls, ComCtrls, ExtCtrls,
  Controls;

  function  TrMsg(Msg: String): PChar;
  procedure LoadLanguage(FormInstance: TForm);
  procedure TranslateForm(FormInstance: TForm);
  procedure DumpLanguage(FormInstance: TForm; FileName: String; WriteMode: Word);

implementation

uses Globals;

type
  TTokenKind = (tkScoper, tkProperty, tkData);

  TToken = record
    Data: String;
    Kind: TTokenKind;
  end;

  TTokens = array of TToken;

  
// ----------------------------------------------------------------------------- _____________________________________________________________________________
//
//              Foreign_Message := TrMsg (Ita_Message)
//
// Does the translation of predefined messages
// (declared as msg[xxx]=??? in .lng file)
//
// -----------------------------------------------------------------------------
function TrMsg(Msg: String): PChar;
var
  i: Integer;
begin
  for i := 1 to High(ItaMsgs) do
    begin
      if (Msg = ItaMsgs[i]) and (Messages[i] <> '') then
        begin
          Result := PChar(Messages[i]);
          break;
        end
      else
        Result := PChar(Msg);
    end;
end;


// ----------------------------------------------------------------------------- _____________________________________________________________________________
//
//                         LoadLanguage(Form)
//
// Load xxxxx.lng file for processing
//
// ----------------------------------------------------------------------------- _____________________________________________________________________________

  // ----------------
  // AddMessage (Msg)
  // ----------------
  procedure AddMessage(Msg: String);

    function RemoveQuotes(InStr: String): String;
    begin
      if (InStr <> '') and (InStr[1] in ['"', '''']) then
        Result := copy(InStr, 2, length(InStr) - 2)
      else
        Result := InStr;
    end;

  var
    posit, cut: Integer;
  begin
    posit := pos('[', Msg) + 1;
    posit := StrToInt(Copy(Msg, posit, 3));
    cut := pos('=', Msg);
    Delete(Msg, 1, cut);
    Messages[posit] := RemoveQuotes(Msg);
  end;

  // --------------------
  // SetProperty (Tokens)
  // --------------------
  procedure SetProperty(Tokens: TTokens);

    // --------------------------------------------------------------
    // Sets the component properties (caption and hint) if they exist
    // --------------------------------------------------------------
    procedure SetStringPropertyIfExists(AComp: TComponent; APropName: String;
      AValue: String);
    var
      PropInfo: PPropInfo;
      TK: TTypeKind;
    begin
      PropInfo := GetPropInfo(AComp.ClassInfo, APropName);
      if PropInfo <> nil then
        begin
          TK := PropInfo^.PropType^.Kind;
          if (TK = tkString) or (TK = tkLString) or (TK = tkWString) then
            SetStrProp(AComp, PropInfo, AValue);
        end;
    end;

  var
    i: Integer;
    Comp: TComponent;
    Prop: String;
    Value: String;

  begin
    Comp := Application.FindComponent(Tokens[0].Data);
    if Comp <> nil then
      for i := 1 to high(Tokens) do
        begin
          case Tokens[i].Kind of
            tkScoper:
              if Comp <> nil then
                Comp := Comp.FindComponent(Tokens[i].Data);
            tkProperty: Prop := Tokens[i].Data;
            tkData: Value := Tokens[i].Data;
          end;
        end;

    if (Comp <> nil) and (Comp is TComboBox) then
      begin
        if lowercase(Prop) = 'hint' then
          TComboBox(Comp).Hint := Value
        else
          TComboBox(Comp).Items[StrToInt(Prop)] := Value;
      end;

    if Comp <> nil then
      SetStringPropertyIfExists(Comp, Prop, Value);
  end;

  // ----------------
  // ParseLine (Line)
  // ----------------
  procedure ParseLine(Line: String);

    function Tokenize(InStr: String): TTokens;
    var
      i: Integer;
      level: Integer;
      tKind: TTokenKind;
    begin
      level := 0;
      SetLength(Result, 1);
      tKind := tkScoper;
      for i := 1 to length(InStr) do
        begin
          if (tKind = tkScoper) and (InStr[i] = '.') then
            begin
              inc(level);
              SetLength(Result, level + 1);
              Result[level].Kind := tKind;
            end
          else if (tKind = tkScoper) and (InStr[i] = '=') then
            begin
              inc(level);
              SetLength(Result, level + 1);
              tKind := tkData;
              Result[level].Kind := tKind;
              Result[level - 1].Kind := tkProperty;
            end
    //      else if (tKind = tkData) and (InStr[i] in ['"', '''']) then
    //        // Do nothing
          else
            Result[level].Data := Result[level].Data + InStr[i];
        end;
    end;

  var
    tmp: TTokens;

  begin
    tmp := Tokenize(Line);
    SetProperty(tmp);
  end;

  // -------------------------------------------
  // Loads the file and scans strings one by one
  // -------------------------------------------
  procedure LoadFile(FileName: String; FormInstance: TForm);
  type
    TTokenKind = (tkUnknown, tkComment, tkMessage, tkTranslation);

    function GetTokenKind(Str: String): TTokenKind;
    begin
      Result := tkUnknown;
      Str := trim(Str);
      if Str <> '' then
        if (copy(Str, 1, 2) = '//') or (Str[1] = ';') then
          Result := tkComment
        else if copy(Str, 1, 4) = 'msg[' then
          Result := tkMessage
        else if pos('=', Str) <> 0 then
          Result := tkTranslation;
    end;
  var
    f: textfile;
    FormName: String;
    temp: String;
  begin
    FormName := FormInstance.Name;
    if FileExists(FileName) then
    begin
      assignfile(f, FileName);
      reset(f);
      while not EOF(f) do
      begin
        Readln(f, temp);
        case GetTokenKind(temp) of
          tkTranslation:
            if pos(FormName, temp) <> 0 then
              ParseLine(temp);
          tkMessage:
            AddMessage(temp);
        end;
      end;
      closefile(f);
    end;
  end;


procedure LoadLanguage(FormInstance: TForm);
begin
  SetCurrentDir(LangDir);
  LoadFile(LangFile + '.lng', FormInstance);
  SetCurrentDir(AppDir);
end;

// ----------------------------------------------------------------------------- _____________________________________________________________________________
// Translate Form
//
// ----------------------------------------------------------------------------- _____________________________________________________________________________
procedure TranslateForm(FormInstance: TForm);

  // ------------------
  // Parses a text file
  // ------------------
  procedure ParseLine(InStr: String; out Form, Component, Prop, Value: String);
  var 
    posit: Integer;
  begin    
    posit := pos('.', InStr);
    Form := lowercase(trim(copy(InStr, 1, posit - 1)));
    Delete(InStr, 1, posit);
    posit := pos('.', InStr);
    Component := lowercase(trim(copy(InStr, 1, posit - 1)));
    Delete(InStr, 1, posit);
    posit := (pos('=', InStr));
    Prop := lowercase(trim(copy(InStr, 1, posit - 1)));
    Delete(Instr, 1, posit);
    posit := (pos('=', InStr));
    Delete(InStr, posit, 1);
    Value := Trim(InStr);
  end;

  // -------------------------------------
  // Sets string property if it exists ;-)
  // -------------------------------------
  procedure SetStringPropertyIfExists(AComp: TComponent; APropName: String;
    AValue: String);
  var
    PropInfo: PPropInfo;
    TK: TTypeKind;
  begin    
    PropInfo := GetPropInfo(AComp.ClassInfo, APropName);
    if PropInfo <> nil then
      begin
        TK := PropInfo^.PropType^.Kind;
        if (TK = tkString) or (TK = tkLString) or (TK = tkWString) then
          SetStrProp(AComp, PropInfo, AValue);
      end;
  end;

var 
  f: textfile;   
  Line, Temp: String;
  Form, Component, Prop, Value: String;
  CompC: TComponent;
  Index: Integer;

begin                   
  assignfile(f, LangDir + LangFile + '.lng');
  reset(f);
  while not EOF(f) do
    begin
      readln(f, Line);
      Temp := copy(Line, 1, length(FormInstance.Name));
      if Temp = FormInstance.Name then
        begin
          ParseLine(Line, Form, Component, Prop, Value);
          if not (FormInstance = nil) then
            begin
              Compc := FormInstance.FindComponent(Component);
              if CompC <> nil then
                begin
                  if CompC is TComboBox then
                    begin
                      if Prop = 'hint' then
                        TComboBox(CompC).Hint := Value
                      else
                        begin
                          Index := StrToInt(Prop);
                          TComboBox(CompC).Items[Index] := Value;
                        end
                    end
                  else
                    SetStringPropertyIfExists(CompC, Prop, Value)
                end;
            end;
        end;
    end;
  closefile(f);
end;

// ----------------------------------------------------------------------------- _____________________________________________________________________________
//
//                   DumpLanguage (Form, FileName, WriteMode)
//
// Dumps all form component's captions and hints into a language file
// WriteMode: fmCreate, fmOpenRead, fmOpenWrite, fmOpenReadWrite
//
// ----------------------------------------------------------------------------- _____________________________________________________________________________
procedure DumpLanguage(FormInstance: TForm; FileName: String; WriteMode: Word);
var
  fs: TFileStream;

  function GetStringProperty(Component: TComponent;
    const PropName: String): String;
  var
    PropInfo: PPropInfo;
    TK: TTypeKind;
  begin    
    Result := '';
    PropInfo := GetPropInfo(Component.ClassInfo, PropName);
    if PropInfo <> nil then
      begin
        TK := PropInfo^.PropType^.Kind;
        if (TK = tkString) or (TK = tkLString) or (TK = tkWString) then
          Result := GetStrProp(Component, PropInfo);
      end;
  end;

  function GetComponentTree(Component: TComponent): String;
  var
    Owner: TComponent;
  begin
    Result := Component.Name;
    Owner := Component.Owner;
    while Owner <> Application do
      begin
        Result := Owner.Name + '.' + Result;
        Owner := Owner.Owner;
      end;
  end;

  procedure DumpComponent(Component: TComponent;
    const Properties: array of String);
  var
    i: Integer;
    str: String;
    tmp: String;
  begin    
    for i := 0 to high(Properties) do
      begin
        str := GetComponentTree(Component);
        tmp := GetStringProperty(Component, Properties[i]);
        if tmp <> '' then
          begin
            str := #13#10 + str + '.' + Properties[i] + '=' + tmp;
            fs.WriteBuffer(str[1], length(str));
          end;
      end;
  end;

var
  i: Integer;
  Comment: String;

begin
  fs := TFileStream.Create(FileName, WriteMode);
  try    
    fs.Seek(0, soFromEnd);     
    Comment := #13#10 + chr(VK_TAB) + '// ' + FormInstance.Name;
    fs.WriteBuffer(Comment[1], length(comment));
    for i := 0 to FormInstance.ComponentCount - 1 do
      DumpComponent(FormInstance.Components[i], ['caption', 'hint']);
  finally    
    fs.Free   
  end;
end;

end.




GLOBALS.PAS -----------------------------------------------------------




unit Globals;

interface

const
  // Messages count  <---  CHANGE THIS IF STRINGS ADDED
  MsgCount = 10;
  //Contains original English messages
  ItaMsgs: array [1..MsgCount] of String =
  (
      'This is String #1',
      'Str 2',
      'Str 3',
      'Str 4',
      'Str 5',
      'Str 6',
      'Str 7',
      'Str 8',
      'Str 9',
{010} 'Str 10'
  );

type
  TConfig = record         // The global configuration type
    DebugMode: boolean;    // Are we in debug mode?
  end;

var
  Config: TConfig;         // Holds the global ZTranslator configuration

  AppDir: string;          // Holds the application files directory
  SkinsDir: string;        // Holds the skins files directory

  LangDir: String;         // Holds the language files directory
  LangFile: String;        // Holds the current language file name

  Messages: array [1..MsgCount] of String; //Contains translated versions of messages

implementation

end.




ENGLISH.LNG --------------------------------------------------------------




; MainForm

MainForm.L_Title.caption=PROGRAM TITLE
MainForm.L_Version.caption= My PROGRAM 1.0
MainForm.L_Version.hint=Release version

; MainForm

SetupForm.L_Setup.Caption=SETUP
SetupForm.L_Setup.Hint=Click here for setup

; Single strings or messages
                                             
msg[001]=This is strig #1
msg[002]=Str 2
msg[003]=Str 3
msg[004]=Str 4
msg[005]=Str 5
msg[006]=Str 6
msg[007]=Str 7
msg[008]=Str 8
msg[009]=Str 9
msg[010]=Str 10
