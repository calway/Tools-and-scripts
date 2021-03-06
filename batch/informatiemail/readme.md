## Informatiemail procedure ##

Met deze procedure worden informatie emails verstuurd op basis van keuzes in het belscript en statussen die in deze procedure zijn ingesteld. 
> **06-04-2020**: We bezig met de transitie van templates op disk naar templates via de BODY variabele. Om dit te laten werken moeten de plaatjes die in de email worden gebruikt via internet (externe url) bereikbaar zijn. Voor huidige klanten is daarom een transitie pad ingebouwd in deze versie.

#### Configuratie ####
Configuratie gebeurd via de variables sectie in de .config. Via de variabele `EXP_FIELD` wordt ingesteld welk veld (prefix) gebruikt moet worden. 
Door hier `INFO` in te plaatsen zoekt dit proces naar een script veld `INFO` in de bellijst en een `EXP_INFO` karakter(16) veld. 
Als de beller de mogelijkheid krijgt om de email aan te passen dan moet er een veld `INFO_EMAIL_INTRO` zijn, en voor TO wordt gekeken naar een veld `INFO_EMAIL_TO`

De belopdrachten die voor de informatievraag in aanmerking komen worden met hun ID's opgegeven in de variabele `EXP_STATIDS`. Dit kan een komma gescheiden lijst met statid's van de CallPro belopdrachtstatussen.

Indien alle emails altijd via BCC naar een backoffice mailbox moeten kan dit in de .config file worden toegevoegd (zien de comment).
Door een beperking in de fulfilment module staat op 1 plaats, in de `<attachment>` tag een harde verwijzing naar het scriptveld `INFO`.

Deze procedure kijkt naar diverse variabelen voor de sturing. 
Deze worden zowel op campagne, als op scriptdefinitie gezocht waarbij de campagne voorrang heeft boven de scriptdefinitie.


## Randvoorwaarden ##

1. De informatiemail procedure staat in een sub-folder van de fulfilment autoscan folder, we noemen deze vanaf nu root-folder.
2. In het belscript wordt de veld prefix `INFO` gebruikt (zie ook navolgende punten).
3. De scriptdefinitie heeft de volgende velden: `INFO`, `EXP_INFO`, `INFO_EMAIL_TO`, `INFO_EMAIL_INTRO`  
    1. Het `INFO` veld is lang genoeg om de paden van alle te kiezen bijlagen te bevatten, gescheiden door een + Dit werkt het eenvoudigst als het veld type `Memo` wordt gemaakt!  
    2. Het veld `EXP_INFO` is karakater(16) hier wordt de datum/tijd als `dd-MM-yyyy HH:mm` in gezet na de export.
4. In de root-folder uit punt 1 is een folder aangemaakt "templates" met per ID v/d scriptdefintie een folder.  
    1. In de folder van punt 4 is een "email" sub-folder aanwezig met de complete email template, de template staat in de file "index.html" eventuele plaatjes die nodig zijn staan allemaal in de email folder of evt. sub-folders en worden vanuit de index.html gerefereert met een relatief pad ten opzichte van de "email" folder.  
    2. In de folder van punt 4 is een "attachments" folder aanwezig met de verschillende bijlagen die kunnen worden gekozen in het belscript. Voor de eenvoud kan beter worden gewerkt met korte eenvoudige bestandsnamen.
5. In de email.config file wordt in de variables sectie een variabele `EXP_STATIDS` comma gescheiden de ID's v/d statussen opgegeven die met de informatiemail procedure worden verwerkt.
6. Instellingen kunnen op campagne niveau of scriptdefinitie niveau worden gedaan waarbij eerst de campagne, en daarna de scriptdefinitie wordt gebruikt.  
    1. campagne variabele `INFO.EMAIL.TO`, daarna op scriptdefintie `INFO.EMAIL.TO` en daarna uit het belscript `INFO_EMAIL_TO` veld.  
    2. `INFO.EMAIL.NAME` als weergave naam voor het afzender adres  
    3. `INFO.EMAIL.FROM` als email adres voor de afzender 
    4. `INFO.EMAIL.CC`
    5. `INFO.EMAIL.BCC`  
    6. `INFO.EMAIL.SUBJECT`  
    7. `INFO.EMAIL.BODY` (optional) Als deze variable aanwezig is dan wordt de inhoud als html email template gebruikt in plaats van de file (stap 4) die de TEMPLATE variabele aanwijst (index.html). Als deze variabele niet aanwezig is wordt een file op disk gebruikt.
    8. `INFO.EMAIL.INTRO` bevat een template voor het variabele deel uit de email template (als dat wordt gebruikt) De werkelijke inhoud die gebruikt wordt komt dan in het belscript veld `INFO_EMAIL_INTRO` te staan. Dit stuk wordt in de email template zoals bedoeld bij punt 4.1 gebruikt om het variabele deel te vullen.
    9. `INFO.EMAIL.TEMPLATE` (optioneel) Als gezet bevat dit de naam van een alternatieve template html file. Standaard wordt (index.html) gebruikt. Door deze bijvoorbeeld op de campagne te zetten kan met verschillende templates per campagne gewerkt worden.
7. De bijlagen worden in het belscript gekozen via checkboxes en de waarde wordt bewaard in het belscript veld `INFO`. Stel we kiezen 2 bijlagen A.pdf en B.docx dan staat in het veld `A.pdf+B.docx`. Als we werken met script definitie ID=1500 zou in de folder templates\1500\attachments 2 bestanden A.pdf en B.docx moeten staan. Deze worden beide als bijlage aan de email toegevoegd. 

## Scriptdefinitie velden ##

veldnaam | type | inhoud
---------|------|-------
INFO | Memo | Dit veld wordt gewoon gemaakt, voor meerdere attachments moet dit een checkbox zijn. Anders een Combobox
INFO_EMAIL_INTRO | Memo | Dit veld wordt niet afgebeeld, CustomHTML en Vraag zijn leeg  
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

<a class="button" href="javascript:showDialog('DIALOG_INFO_EMAIL_INTRO')">Wijzig email bericht</a>
<a class="button" onclick="setFieldValue('script_info_email_intro','');">Standaard tekst</a>

<script src="//cdn.ckeditor.com/4.11.3/basic/ckeditor.js"></script>
<!-- Begin: Dialog for editing the email template -->
<div data-role="dialog" data-overlay="true" data-overlay-color="op-dark" data-close-button="true" data-on-dialog-close="dialog_info_intro_template_close" id="DIALOG_INFO_EMAIL_INTRO">
<div class="container">
<h4 class="text-light">Wijzig de standaard email tekst</h4>
<textarea name="script_info_email_intro"  class="ckeditor"></textarea>
</div>
</div>

<script>
var TEMPLATE_INFO_EMAIL_INTRO = '%VARIABLE.INFO.EMAIL.INTRO \LS \RE"'","\'" %';
	function showDialog(id){
		var dialog = $("#"+id).data('dialog');
		if (!dialog.element.data('opened')) {
// Insert the template if the field is empty only!
if(getFieldValue("script_info_email_intro")=="") {
setFieldValue("script_info_email_intro",TEMPLATE_INFO_EMAIL_INTRO);
}
			// Alsway refresh the editor before displaying
			CKEDITOR.instances['script_info_email_intro'].setData();
			dialog.open();
		} else {
			dialog.close();

		}
	}

function dialog_info_intro_template_close()
{
// Make sure we update the scriptfield when we close the dialog.
// ckeditor uses a parallel control not the original textarea
setFieldValue("script_info_email_intro", CKEDITOR.instances['script_info_email_intro'].getData());
}
</script>
<!-- End: Dialog for editing the email template -->
```