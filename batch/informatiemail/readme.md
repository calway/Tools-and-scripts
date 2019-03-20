## Informatiemail procedure ##

#### Configuratie ####
Configuratie via de email.bat door in te stellen welk veld (prefix) gebruikt moet worden (`INFO_FIELD` variabele). 
Door hier `INFO` in te plaatsen zoekt dit proces naar een script veld `INFO` in de bellijst en een `EXP_INFO` karakter(16) veld. 
Als de beller de mogelijkheid krijgt om de email aan te passen dan moet er een veld `INFO_EMAIL_BODY` zijn, en voor TO wordt gekeken naar een veld `INFO_EMAIL_TO`

De belopdrachten die voor de informatievraag in aanmerking komen worden met hun ID's opgegeven in de variabele `INFO_STATIDS` in de email.bat. 
Dit kan een komma gescheiden lijstje met statid's van CallPro zijn.

Connectionstring en MailServer instellingen als gebruikelijk in de email.config. Indien alle emails altijd via BCC naar een backoffice mailbox moeten kan dit in de .config file worden toegevoegd (zien de comment).
Door een beperking in de fulfilment module staat op 1 plaats, in de `<attachment>` tag een harde verwijzing naar het scriptveld `INFO`.

Deze procedure kijkt naar diverse variabelen voor de sturing. 
Deze worden zowel op campagne, als op scriptdefinitie gezocht waarbij de campagne voorrang heeft boven de scriptdefinitie.


## Randvoorwaarden ##

1. De informatiemail procedure staat op schijf in folder (bijvoorbeeld c:\data\batch\informatiemail)
2. In het belscript wordt de veld prefix `INFO` gebruikt (zie ook navolgende punten).
3. De scriptdefinitie heeft de volgende velden: `INFO`, `EXP_INFO`, `INFO_EMAIL_TO`, `INFO_EMAIL_BODY`  
3.1. Het `INFO` veld is lang genoeg om de paden van alle te kiezen bijlagen te bevatten, gescheiden door een + Dit werkt het eenvoudgst als het veld type `Memo` wordt gemaakt!  
3.2. Het veld `EXP_INFO` is karakater(16) hier wordt de datum/tijd als `dd-MM-yyyy HH:mm` in gezet na de export.
4. In de root folder uit punt 1 is een folder aangemaakt "templates" met per ID v/d scriptdefintie een folder.  
4.1. In de folder van punt 4 is een "email" sub-folder aanwezig met de complete email template, de template staat in de file "index.html" eventuele plaatjes die nodig zijn staan allemaal in de email folder of evt. subfolders en worden vanuit de index.html gerefereerd met een relatied pad ten opzichte van de "email" folder.  
4.2. In de folder van punt 4 is een "attachments" folder aanwezig met de verschillende bijlagen die kunnen worden gekozen in het belscript. Voor de eenvoud kan beter worden gewerkt met korte eenvoudige bestandsnamen.
5. In de email.bat start file wordt in de environment variabele `INFO_STATIDS` comma gescheiden de ID's v/d statussen opgegeven die met de informatiemail procedure worden verwerkt.
6. Instellingen kunnen op campagne niveau of scriptdefintie niveau worden gedaan waarbij eerst de campgne, en daarna de scriptdefinitie wordt gebruikt.  
6.1. campagne variabele `INFO.EMAIL.TO`, daarna op scriptdefintie `INFO.EMAIL.TO` en daarna uit het belscript `INFO_EMAIL_TO` veld.  
6.2. `INFO.EMAIL.NAME` als weergave naam voor het afzender adres  
6.3. `INFO.EMAIL.FROM` als email adres voor de afzender  
6.4. `INFO.EMAIL.BCC`  
6.5. `INFO.EMAIL.SUBJECT`  
6.6. `INFO.EMAIL.BODY` bevat een template voor het variabele deel uit de email template (als dat wordt gebruikt) De werkelijke inhoud die gebruikt wordt komt dan in het belscript veld `INFO_EMAIL_BODY` te staan. Dit stuk wordt in de email template zoals bedoeld bij punt 4.1 gebruikt om het variabele deel te vullen.
7. De bijlagen worden in het belscript gekozen via checkboxes en de waarde wordt bewaard in het belscript veld `INFO`. Stel we kiezen 2 bijlagen A.pdf en B.docx dan staat in het veld `A.pdf+B.docx`. Als we werken met script definitie ID=1500 zou in de folder templates\1500\attachements 2 bestanden A.pdf en B.docx moeten staan. Deze worden beide als bijlage aan de email toegevoegd.

## Scriptdefinitie velden ##

veldnaam | type | inhoud
---------|------|-------
INFO | Memo | Dit veld wordt gewoon gemaakt, voor meerdere attachments moet dit een checkbox zijn. Anders een Combobox
INFO_EMAIL_BODY | Memo | Dit veld wordt niet afgebeeld, CustomHTML en Vraag zijn leeg  
EXP_INFO | Karakter(16) | Dit vald kan zowel zichtbaar/readonly als onzichtbaar op de pagina staan. 
INFO_EMAIL_TO | Karakter(50) | Dit veld wordt gebruikt als TO veld voor de email. Het wordt afgebeeld als Custom HTML en geeft ook alle andere opmaak weer voor template editing. Hier wordt gebruik gemaakt van andere belopdrachte velden die email adressen bevatten om een keuzelijst af te beelden. Verder wordt CKEditor gebruikt om de template te bewerken.

Custom HTML:
```
<select id="script_info_email_to" class="input-control" onfocus="FillControlFromScriptFields()">
</select>

<script type="text/javascript">
function FillControlFromScriptFields() 
{
// get a control reference
var control = document.getElementById("script_info_email_to");
// get current selected item
var selectedIndex = control.selectedIndex;
// clear the control's option list
control.options.length = 0;

// add value to control from script field "script_comp_email"
var emailaddress = getFieldValue("script_comp_email");
if(emailaddress>"") {
  var o=document.createElement('option');
  o.text=emailaddress;
  control.options.add(o);
}
// add value to control from script field "script_name_email"
var emailaddress = getFieldValue("script_name_email");
if(emailaddress>"") {
  var o=document.createElement('option');
  o.text=emailaddress;
  control.options.add(o);
}

// check whether we could reset the item index and do so.
if(control.length==0) {
  var o=document.createElement('option');
  o.text="-- Er zijn geen email adressen beschikbaar --";
  o.value=""
  control.options.add(o);
}
else if(control.length>=selectedIndex)
{
  control.selectedIndex = selectedIndex;
}
}
</script>

<a class="button" href="javascript:showDialog('DIALOG_INFO_EMAIL_BODY')">Wijzig email bericht</a>
<a class="button" onclick="setFieldValue('script_info_email_body','');">Standaard tekst</a>

<script src="//cdn.ckeditor.com/4.11.3/basic/ckeditor.js"></script>
<!-- Begin: Dialog for editing the email template -->
<div data-role="dialog" data-overlay="true" data-overlay-color="op-dark" data-close-button="true" data-on-dialog-close="dialog_info_body_template_close" id="DIALOG_INFO_EMAIL_BODY">
<div class="container">
<h4 class="text-light">Wijzig de standaard email tekst</h4>
<textarea name="script_info_email_body"  class="ckeditor"></textarea>
</div>
</div>

<script>
// Here we use an unsupported feature of autoscript - server-side merge-fields
var TEMPLATE_INFO_EMAIL_BODY = '%VARIABLE.INFO.EMAIL.BODY \LS \RE"'","\'" %';
	function showDialog(id){
		var dialog = $("#"+id).data('dialog');
		if (!dialog.element.data('opened')) {
// Insert the template if the field is empty only!
if(getFieldValue("script_info_email_body")=="") {
setFieldValue("script_info_email_body",TEMPLATE_INFO_EMAIL_BODY);
}
			// Alsway refresh the editor before displaying
			CKEDITOR.instances['script_info_email_body'].setData();
			dialog.open();
		} else {
			dialog.close();

		}
	}

function dialog_info_body_template_close()
{
// Make sure we update the scriptfield when we close the dialog.
// ckeditor uses a parallel control not the original textarea
setFieldValue("script_info_email_body", CKEDITOR.instances['script_info_email_body'].getData());
}
</script>
<!-- End: Dialog for editing the email template -->
```