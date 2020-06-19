Als je editor dit ondersteunt zoals Visual Studio en VS Code kun je met regex heel handig en snel javascript code aanpassen. 


Bij de conversie van hele oude scripts bijvoorbeeld waarbij een oude getFieldValue functie werd gebruikt, en het gedrag hiervan inmiddels problematisch wordt omdat de eerste parameter
alleen een object kan zijn als er een html contr9ol is met een id met de betreffende naam. Voorheen werkte die (in IE) ook met name controls.

```
Gebruik: Vind alle functie aanroepen met getFieldValue(script_name_last) en vervang deze door getFieldValue("name_last")
Find: getFieldValue\(([^")]+)\)
Replace: getFieldValue("$1")
```

```
Gebruik: Vind alle functie aanroepen met setFieldValue(script_name_last, WaardeOfExpressie) en vervang deze door setFieldValue("script_name_last", WaardeOfExpressie)
Find: setFieldValue\(([^",]+),([^)]+)\)
Replace: setFieldValue("$1",$2)
```
