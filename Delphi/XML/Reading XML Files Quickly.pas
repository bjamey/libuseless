// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Reading XML Files Quickly
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// --------------------------------------------------------
// Author      : Korpos Studios [Esteban Rodríguez Nieto]
// Email       : esteban.rnieto@korpos.com.ar
// Web site    : www.korpos.com.ar
// Module name : uMain.pas
// Description : Simple XML reader
// Started     : 04/20/06
// --------------------------------------------------------

unit uMain;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  xmldom, XMLIntf, msxmldom, XMLDoc, StdCtrls;

type

    TMain = class(TForm)

    XMLDocument : TXMLDocument;
    ListBox     : TListBox;

    procedure FormCreate(Sender: TObject);

end;

var Main: TMain;

// --------------------------------------------------------------------------- //

implementation

{$R *.dfm}

// --------------------------------------------------------------------------- //
// Searchs XML node values by name & adds them to a list
// --------------------------------------------------------------------------- //
procedure TMain.FormCreate(Sender: TObject);
begin
     with (XMLDocument) do
     begin
          FileName := 'Example.xml'; // Sets XML file
          Active := true;            // Activates control

          // Here we use the DocumentElement propertie wich gives us access to
          // the root node of the XML file

          with (DocumentElement.ChildNodes) do         // Search nodes by name
          begin
               ListBox.AddItem(FindNode('node1').Text, nil); // Adds node1's text to list
               ListBox.AddItem(FindNode('node2').Text, nil); // Adds node2's text to list
               ListBox.AddItem(FindNode('node4').Text, nil); // Adds node4's text to list

          end;
     end;
end;
// --------------------------------------------------------------------------- //
end.
