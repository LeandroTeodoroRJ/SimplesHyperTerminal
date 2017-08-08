unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Layouts, FMX.Memo;

type
  TFormMain = class(TForm)
    ButtonConfigura: TButton;
    ButtonEnvia: TButton;
    ButtonRecebe: TButton;
    EditEnvia: TEdit;
    EditRecebe: TEdit;
    Label1: TLabel;
    EditPorta: TEdit;
    Memo1: TMemo;
    EditRecebeDec: TEdit;
    Label2: TLabel;
    EditEnviaDec: TEdit;
    ButtonEnviaDec: TButton;
    procedure ButtonConfiguraClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonEnviaClick(Sender: TObject);
    procedure ButtonRecebeClick(Sender: TObject);
    procedure ButtonEnviaDecClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  function AbrirPortaSerial(NomePorta:String):integer; stdcall; external 'C:\DADOS\Informatica\Info_projetos\DriveSerial\Win32\Debug\DriveSerial.dll';
  function ConfiguraUART
  (bauld:integer; Byte_Size: Byte; Paridade:integer; Stop_bit:integer):boolean;
  stdcall; external 'C:\DADOS\Informatica\Info_projetos\DriveSerial\Win32\Debug\DriveSerial.dll';
  procedure FecharPorta; external 'C:\DADOS\Informatica\Info_projetos\DriveSerial\Win32\Debug\DriveSerial.dll';
  function config_porta():boolean; external 'C:\DADOS\Informatica\Info_projetos\DriveSerial\Win32\Debug\DriveSerial.dll';
  function TX_catacter(var tx:AnsiChar):boolean; external 'C:\DADOS\Informatica\Info_projetos\DriveSerial\Win32\Debug\DriveSerial.dll';
  procedure le_porta; external 'C:\DADOS\Informatica\Info_projetos\DriveSerial\Win32\Debug\DriveSerial.dll';
  function bytes_ler(): integer; external 'C:\DADOS\Informatica\Info_projetos\DriveSerial\Win32\Debug\DriveSerial.dll';
  function recebe_dado(count:integer): char; stdcall; external 'C:\DADOS\Informatica\Info_projetos\DriveSerial\Win32\Debug\DriveSerial.dll';
  function envia_serial(var BufferEnvia: AnsiString):DWORD; stdcall; external 'C:\DADOS\Informatica\Info_projetos\DriveSerial\Win32\Debug\DriveSerial.dll';

implementation
  {$R *.fmx}

procedure TFormMain.ButtonConfiguraClick(Sender: TObject);
var
porta: string;
Flag_configura: boolean;
begin

porta:= EditPorta.Text;
  if AbrirPortaSerial(porta)<>1 then
  begin
    showmessage('A porta não abriu corretamente');
  end;

Flag_configura:=ConfiguraUART(7,8,3,1);
  if (Flag_configura<>false) then
  begin
    ShowMessage('A porta foi configurada corretamente.');
  end
  else
  begin
    ShowMessage('Erro de configuração.');
  end;

  if config_porta()=False then
  begin
    ShowMessage('Erro de configuração dos time-outs.');
  end;

end;

procedure TFormMain.ButtonEnviaClick(Sender: TObject);
var
Envia: AnsiChar;
Dado: string;
AnsiDado: AnsiString;
//Flag_envia: boolean;
begin
Dado:= EditEnvia.Text;
//Envia:= AnsiChar(Dado[1]);
AnsiDado:=AnsiString(Dado);

  if envia_serial(AnsiDado)=0 then
  begin
  ShowMessage('Não foi possivel enviar o dado');
  end;

  //  if (TX_catacter(Envia)=false) then
//  begin
//    showmessage('O caractere não foi enviado');
//  end;
end;

procedure TFormMain.ButtonEnviaDecClick(Sender: TObject);
var
Envia: AnsiChar;
Dado: integer;
//Flag_envia: boolean;
begin
Dado:= strtoint(EditEnviaDec.Text);
Envia:= AnsiChar(Chr(Dado));
  if (TX_catacter(Envia)=false) then
  begin
    showmessage('O caractere não foi enviado');
  end;
end;

procedure TFormMain.ButtonRecebeClick(Sender: TObject);
begin
le_porta;

  if (bytes_ler()=0) then
  begin
    showmessage('Nenhum Byte para receber');
  end
  else
  begin
    EditRecebe.text:=recebe_dado(0);
    EditRecebeDec.Text:=inttostr(Ord(recebe_dado(0)));
  end;

end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FecharPorta;
end;

end.
