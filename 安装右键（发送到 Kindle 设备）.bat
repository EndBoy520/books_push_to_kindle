@echo off
cd /d "%~dp0"

::�����б�������������ɫ
title -- ��װ�Ҽ������͵� Kindle �豸�� --
MODE con: COLS=46 lines=12
color 0a

goto menu

:menu
MODE con: COLS=46 lines=12
set id=
set kindle_email=
set send_email=
set send_email_password=
cls
echo.
echo. ===== ��װ�Ҽ������͵� Kindle �豸��=====
echo.
echo.    1.��װ���Ҽ������͵����˵�
echo.
echo.    2.���Ҽ������͵����˵�ж��
echo.
echo.    ʹ�÷�����ѡ�е�����-�Ҽ�-���͵�
echo.
set /p id=������ѡ������:
if "%id%"=="1" goto install
if "%id%"=="2" goto unstall else (
goto menu
)

:install
MODE con: COLS=46 lines=24
cls
echo.
echo. ===== ��װ�Ҽ������͵� Kindle �豸��=====
echo.

::����������Ϣ
echo. 1.���� Kindle ���䣨�������䣩
echo.
set /p kindle_email=������:
if not defined kindle_email goto error
echo.

echo. 2.�������ڷ��͸���������
echo.
set /p send_email=������:
if not defined send_email goto error
echo.

for /f "tokens=2,3,4 delims=@." %%a in ("%send_email%") do (
set h1=%%a
set h2=%%b
set h3=%%c
)

if not defined h3 (set domain=%h1%.%h2%) else (set domain=%h2%.%h3%)

echo. 3.���ø������SMTP������
echo. ��Ĭ�Ϸ�������smtp.%domain%��
echo.
set /p send_email_smtp=������:
if not defined send_email_smtp (set send_email_smtp=smtp.%domain%)
echo.

echo. 4.���ø��������Ȩ�루�����룩
echo. ���������Ĵ����� send-to-kindle.vbs �У�
echo.
set /p send_email_password=������:
if not defined send_email_password goto error
echo.

::����vbs����
del /f /q %AppData%\Microsoft\Windows\SendTo\���͵�-Kindle-�豸.lnk 1>nul 2>nul
rd /s /q %cd%\app 1>nul 2>nul
md %cd%\app

(echo dim strFilepath
echo strFilepath = WScript.Arguments(0^)
echo kname = "��" ^& mid(strFilepath,instrrev(strFilepath,"\"^)+1^) ^& "��"
echo Currentdate = date(^)
echo ktime = "����ʱ�䣺" ^& Currentdate
echo.
echo.
echo '���� �ռ�����
echo Const Email_To = "%kindle_email%"
echo.
echo '���� ��������
echo Const Email_From = "%send_email%"
echo Const Password = "%send_email_password%"
echo.
echo.
echo Set CDO = CreateObject("CDO.Message"^)
echo CDO.Subject = "������:" ^& kname ^& ktime
echo CDO.From = Email_From
echo CDO.To = Email_To
echo CDO.TextBody = "��ʾ������ĸ�����"
echo CDO.AddAttachment strFilepath
echo Const schema = "http://schemas.microsoft.com/cdo/configuration/"
echo With CDO.Configuration.Fields
echo 	.Item(schema ^& "sendusing"^) = 2
echo 	.Item(schema ^& "smtpserver"^) = "%send_email_smtp%"
echo 	.Item(schema ^& "smtpauthenticate"^) = 1
echo 	.Item(schema ^& "sendusername"^) = Email_From
echo 	.Item(schema ^& "sendpassword"^) = Password
echo 	.Item(schema ^& "smtpserverport"^) = 465
echo 	.Item(schema ^& "smtpusessl"^) = True
echo 	.Item(schema ^& "smtpconnectiontimeout"^) = 60
echo 	.Update
echo End With
echo CDO.Send
echo.
echo MsgBox ktime ^& Chr(13^) ^& "���͵���" ^& Email_To ^& Chr(13^) ^& "�����ļ�:" ^& kname, vbOKOnly, "���ͳɹ�")>%cd%\app\send-to-kindle.vbs

::���ɿ�ݷ�ʽ����װ�������͵���Ŀ¼
set Program=%cd%\app\send-to-kindle.vbs
set LnkName=���͵�-Kindle-�豸
set WorkDir=%cd%\app
set Desc=�����Ҽ������͵����˵�

(echo Set WshShell=CreateObject("WScript.Shell"^)
echo Set oShellLink=WshShell.CreateShortcut("%cd%\app\%LnkName%.lnk"^)
echo oShellLink.TargetPath="%Program%"
echo oShellLink.WorkingDirectory="%WorkDir%"
echo oShellLink.WindowStyle=1
echo oShellLink.Description="%Desc%"
echo oShellLink.IconLocation="%SystemRoot%\System32\SHELL32.dll,192"
echo oShellLink.Save)>%cd%\app\makelnk.vbs

%cd%\app\makelnk.vbs
del /f /q %cd%\app\makelnk.vbs 1>nul 2>nul
copy %cd%\app\%LnkName%.lnk %AppData%\Microsoft\Windows\SendTo 1>nul 2>nul

MODE con: COLS=46 lines=8
cls
echo.
echo. ===== ��װ�Ҽ������͵� Kindle �豸��=====
echo.
echo. ��װ�У����Ժ󡣡���
echo.
echo. ��װ��ɣ���������˳���װ����
pause 1>nul 2>nul
exit

:unstall
MODE con: COLS=46 lines=8
cls
echo.
echo. ===== ��װ�Ҽ������͵� Kindle �豸��=====
echo.
echo. ж���У����Ժ󡣡���
del /f /q %AppData%\Microsoft\Windows\SendTo\���͵�-Kindle-�豸.lnk 1>nul 2>nul
rd /s /q %cd%\app 1>nul 2>nul
echo.
echo. ж����ɣ���������˳���װ����
pause 1>nul 2>nul
exit

:error
MODE con: COLS=46 lines=8
cls
echo.
echo. ===== ��װ�Ҽ������͵� Kindle �豸��=====
echo.
echo. ���󣡸�ֵ����Ϊ�գ�
echo.
echo. ���� 3 ����Զ����ؿ�ʼ�˵���
ping localhost -n 3 1>nul 2>nul
goto menu