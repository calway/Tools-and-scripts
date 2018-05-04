@Echo Off
Set ProgPath=c:\Program Files (x86)\Calway Nederland B.V
Set DataPath=d:\data\batch\informatiemail

Set EXP_FIELD=INFO
Set EXP_STATIDS=2000,2001,2321
PushD %DataPath%
"%ProgPath%\MergeTool\MergeTool" email.config
Goto Done

:Done
PopD

:Exit
