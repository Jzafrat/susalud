/*********************	
*0. Configuration for export
*********************	

clear all
pause on
set more off
set trace off
set maxvar 15000
set matsize 10000
set seed 123456789
set showbaselevels off
capture log close

*===============================================================================

* Loading ado files:
capture which estout
	if _rc ssc install estout, replace // Installing last official version
	adoupdate estout

capture which tabout
	if _rc ssc install tabout, replace // Installing last official verison
	adoupdate tabout // But, there is an lastest unofficial version

copy "https://tabout.net.au/downloads/b_version/tabout.txt" tabout3.ado, replace
	run "https://tabout.net.au/downloads/b_version/tabout.txt" // Execute the lastest (unofficial) version

** Scheme plotplain	& plotting 
net from  http://www.stata-journal.com/software/sj17-3/
	net install gr0070.pkg
	
net from http://www.stata-journal.com/software/sj4-3
	net install gr0002_3.pkg
	
set scheme plotplain, permanently

*===============================================================================
			 *----------------------------------------------------*
*------------ Program for stacking bivariate models in one column --------------*
			 *----------------------------------------------------*

capt prog drop appendmodels

*! version 1.0.0  14aug2007  Ben Jann
program appendmodels, eclass
		//using first equation of model
	version 8
		syntax namelist
		tempname b V tmp
		foreach name of local namelist {
			qui est restore `name'
			mat `tmp' = e(b)
			local eq1: coleq `tmp'
			gettoken eq1 : eq1
			mat `tmp' = `tmp'[1,"`eq1':"]
			local cons = colnumb(`tmp',"_cons")
			if `cons'<. & `cons'>1 {
				mat `tmp' = `tmp'[1,1..`cons'-1]
		}
		mat `b' = nullmat(`b') , `tmp'
		mat `tmp' = e(V)
		mat `tmp' = `tmp'["`eq1':","`eq1':"]
		if `cons'<. & `cons'>1 {
			mat `tmp' = `tmp'[1..`cons'-1,1..`cons'-1]
		}
		capt confirm matrix `V'
		if _rc {
			mat `V' = `tmp'
		} 
		else {
			mat `V' = ///
			( `V' , J(rowsof(`V'),colsof(`tmp'),0) ) \ /// 
			( J(rowsof(`tmp'),colsof(`V'),0) , `tmp' )
			}
		}
		local names: colfullnames `b'
		mat coln `V' = `names'
		mat rown `V' = `names'
		eret post `b' `V'
		eret local cmd "whatever"
end	
*/



*********************	
*1. Imports dataset
*********************	
*import excel "C:\Users\DAVID\Dropbox\David\Trabajos\1. TERMINADOS\SUSALUD\2024\Fin de año - David\4. Productos\1. Producto 1\0. Material suplementario\Database_4.xlsx", sheet("Sheet1") firstrow clear
import excel "C:\Users\USER\Downloads\Database_4.xlsx", sheet("Sheet1") firstrow clear





*Data cleaning
* Crear la variable de grupos de edad
gen grupo_edad = .

* Asignar los grupos de edad
replace grupo_edad = 1 if inrange(Cuálessuedad, 27, 30)
replace grupo_edad = 2 if inrange(Cuálessuedad, 31, 50)
replace grupo_edad = 3 if inrange(Cuálessuedad, 51, 65)
replace grupo_edad = 4 if Cuálessuedad > 65

* Etiquetar los grupos de edad
label define edad_grupos 1 "27-30" 2 "31-50" 3 "51-65" 4 "66+"
label values grupo_edad edad_grupos

* Verificar la creación de la variable
tab grupo_edad, m

label variable grupo_edad "2.- Grupo de edad"










* Convertir todos los nombres a mayúsculas
gen region_clean = upper(trim(Enquédepartamentovive))

* Corregir nombres comunes mal escritos
replace region_clean = "AREQUIPA" if inlist(region_clean, "AREQUIP", "AREQUIPA")
replace region_clean = "HUANUCO" if inlist(region_clean, "HUENUCO", "HUáNUCO")
replace region_clean = "SAN MARTIN" if inlist(region_clean, "SAN MARTIN", "SAN MARTÍN", "SAN MARTÍN", "SAN MARTIN  ", "SAN MARTíN")
replace region_clean = "LA LIBERTAD" if inlist(region_clean, "LA LIBERTAD", "LA LIBERTAD  ", "LA LIBERTAD ")
replace region_clean = "LAMBAYEQUE" if inlist(region_clean, "LAMBAYEQUE", "LAMBAYEQUE  ")
replace region_clean = "CAJAMARCA" if inlist(region_clean, "CAJAMARCA", "CAJAMARCA  ")
replace region_clean = "HUANCAVELICA" if inlist(region_clean, "HUANCAVELICA", "HUANCAVELICA  ")
replace region_clean = "UCAYALI" if inlist(region_clean, "UCAYALI", "UCAYALI  ")
replace region_clean = "PASCO" if inlist(region_clean, "PASCO", "PASCO  ")
replace region_clean = "JUNIN" if inlist(region_clean, "JUNIN", "JUNÍN  ", "JUNÍN", "JUNíN", "TARMA")
replace region_clean = "PIURA" if inlist(region_clean, "PIURA", "PIURA  ", "REGION PIURA")
replace region_clean = "TACNA" if inlist(region_clean, "TACNA", "TACNA  ")
replace region_clean = "CUSCO" if inlist(region_clean, "CUSCO", "CUSCO  ")
replace region_clean = "MOQUEGUA" if inlist(region_clean, "MOQUEGUA", "MOQUEGUA  ")
replace region_clean = "LORETO" if inlist(region_clean, "LORETO", "LORETO  ")
replace region_clean = "PUNO" if inlist(region_clean, "PUNO", "PUNI", "CABAñA")
replace region_clean = "LIMA" if inlist(region_clean, "LIMA", "SAN BORJA")
*Se considera a CABAÑA como Puno y SAN BORJA como LIMA; TARMA en junin


label variable region_clean "3.1.- ¿En qué departamento vive?"


* Verificar la estandarización
tab region_clean, m


























* Convertir todos los nombres a mayúsculas
gen provincia_clean = upper(trim(Enquéprovinciavive))

* Corregir nombres comunes mal escritos
replace provincia_clean = "AREQUIPA" if inlist(provincia_clean, "AREQUIPA", "AREQUIPA  ", "AREQUIPA ")
replace provincia_clean = "CALLAO" if inlist(provincia_clean, "CALLAO", "CALLAO  ")
replace provincia_clean = "CAJAMARCA" if inlist(provincia_clean, "CAJAMARCA", "CAJAMARCA  ", "CAJAMARCA ")
replace provincia_clean = "CHICLAYO" if inlist(provincia_clean, "CHICLAYO", "CHICLAYO  ")
replace provincia_clean = "CORONEL PORTILLO" if inlist(provincia_clean, "CORONEL PORTILLO", "CORONEL PORTILLO  ")
replace provincia_clean = "CUSCO" if inlist(provincia_clean, "CUSCO", "CUSCO  ")
replace provincia_clean = "HUANUCO" if inlist(provincia_clean, "HUANUCO", "HUENUCO", "HUáNUCO")
replace provincia_clean = "HUARA" if inlist(provincia_clean, "HUARA", "HUARA  ")
replace provincia_clean = "HUAURA" if inlist(provincia_clean, "HUAURA", "HUAURA  ", "HUAURA ")
replace provincia_clean = "HUAMANGA" if inlist(provincia_clean, "HUAMANGA", "HUAMANGA  ")
replace provincia_clean = "HUANCAVELICA" if inlist(provincia_clean, "HUANCAVELICA", "HUANCAVELICA  ")
replace provincia_clean = "HUANCAYO" if inlist(provincia_clean, "HUANCAYO", "HUANCAYO  ")
replace provincia_clean = "LIMA" if inlist(provincia_clean, "LIMA", "LIMA  ", "LIMa", "LIMA ", "LINA")
replace provincia_clean = "LEONCIO PRADO" if inlist(provincia_clean, "LEONCIO PRADO", "LEONCIO PRADO  ", "LEONCIO PRADO ")
replace provincia_clean = "MAYNAS" if inlist(provincia_clean, "MAYNAS", "MAYNAS  ")
replace provincia_clean = "PAITA" if inlist(provincia_clean, "PAITA", "PAITA  ")
replace provincia_clean = "PASCO" if inlist(provincia_clean, "PASCO", "PASCO  ")
replace provincia_clean = "PIURA" if inlist(provincia_clean, "PIURA", "PIURA  ")
replace provincia_clean = "PUNO" if inlist(provincia_clean, "PUNO", "PUNO  ")
replace provincia_clean = "SANTA" if inlist(provincia_clean, "SANTA", "SANTA  ")
replace provincia_clean = "SAN MARTIN" if inlist(provincia_clean, "SAN MARTIN", "SAN MARTÍN", "SAN MARTÍN", "SAN MARTIN  ", "SAN MARTíN")
replace provincia_clean = "SAN ROMAN" if inlist(provincia_clean, "SAN ROMAN", "SAN ROMÁN", "SAN ROMÁN ")
replace provincia_clean = "SULLANA" if inlist(provincia_clean, "SULLANA", "SULLANA  ")
replace provincia_clean = "TACNA" if inlist(provincia_clean, "TACNA", "TACNA  ")
replace provincia_clean = "TRUJILLO" if inlist(provincia_clean, "TRUJILLO", "TRUJILLO  ", "TRUJILLO ")
replace provincia_clean = "SAN ROMÁN" if inlist(provincia_clean, "SAN ROMáN")

label variable provincia_clean "3.2.- ¿En qué provincia vive?"

* Verificar la estandarización
tab provincia_clean, m









* Crear una nueva variable para los distritos normalizados
gen distrito_normalizado = trim(Enquédistritovive)

* Convertir todos los nombres a mayúsculas
replace distrito_normalizado = upper(distrito_normalizado)

* Corregir y normalizar valores
replace distrito_normalizado = "26 DE OCTUBRE" if inlist(distrito_normalizado, "26 DE OCTUBRE", "26 DE OCTUBRE  ")
replace distrito_normalizado = "ABANCAY" if inlist(distrito_normalizado, "ABANCAY", "ABANCAY ")
replace distrito_normalizado = "ALTO SELVA ALEGRE" if inlist(distrito_normalizado, "ALTO SELVA ALEGRE", "ALTO DE LA ALIANZA")
replace distrito_normalizado = "AYACUCHO" if inlist(distrito_normalizado, "AYACUCHO", "AYACUCHO ")
replace distrito_normalizado = "ATE" if inlist(distrito_normalizado, "ATE", "ATE VITARTE")
replace distrito_normalizado = "BANDA DE SHILCAYO" if inlist(distrito_normalizado, "BANDA DE SHILCAYO", "BANDA DE SHILCAYO  ")
replace distrito_normalizado = "CAJAMARCA" if inlist(distrito_normalizado, "CAJAMARCA", "CAJAMARCA ")
replace distrito_normalizado = "CASTILLA" if inlist(distrito_normalizado, "CASTILLA", "CASTILLA ")
replace distrito_normalizado = "CHICLAYO" if inlist(distrito_normalizado, "CHICLAYO", "CHICLAYO ", "CHACLAYO")
replace distrito_normalizado = "CHORRILLOS" if inlist(distrito_normalizado, "CHORRILLOS", "CHORRILLOS ", "CHORRILLOS  ", "CHORRILLLOS")
replace distrito_normalizado = "FERREÑAFE" if inlist(distrito_normalizado, "FERREÑAFE", "FERREÑAFE  ")
replace distrito_normalizado = "HUANCAVELICA" if inlist(distrito_normalizado, "HUANCAVELICA", "HUANCAVELICA  ")
replace distrito_normalizado = "HUANUCO" if inlist(distrito_normalizado, "HUANUCO", "HUANUCO ")
replace distrito_normalizado = "JESUS MARIA" if inlist(distrito_normalizado, "JESUS MARIA", "JESUS MARIA ", "JESUS MARIA  ", "JESUS NAZARENO", "JESUS MARíA", "JESúS MARíA")
replace distrito_normalizado = "JULIACA" if inlist(distrito_normalizado, "JULIACA", "JULIACA ")
replace distrito_normalizado = "LA MOLINA" if inlist(distrito_normalizado, "LA MOLINA", "LA MOLINA ")
replace distrito_normalizado = "LOS OLIVOS" if inlist(distrito_normalizado, "LOS OLIVOS", "LOS OLIVOS ", "LOS OLIVOS  ")
replace distrito_normalizado = "MORALES" if inlist(distrito_normalizado, "MORALES", "MORALES ")
replace distrito_normalizado = "PIURA" if inlist(distrito_normalizado, "PIURA", "PIURA ")
replace distrito_normalizado = "PUEBLO LIBRE" if inlist(distrito_normalizado, "PUEBLO LIBRE", "PUEBLO LIBRE ", "PUEBLO LIBRE  ", "PUENLO.LIBRE")
replace distrito_normalizado = "PUENTE PIEDRA" if inlist(distrito_normalizado, "PUENTE PIEDRA", "PUENTE PIEDRA ", "PUENTE PIEDRA  ")
replace distrito_normalizado = "RUPA-RUPA" if inlist(distrito_normalizado, "RUPA-RUPA", "RUPA- RUPA", "RUPA- RUPA  ", "RUPA- RUPA ")
replace distrito_normalizado = "SAN BORJA" if inlist(distrito_normalizado, "SAN BORJA", "SAN BORJA ")
replace distrito_normalizado = "SAN JUAN DE LURIGANCHO" if inlist(distrito_normalizado, "SAN JUAN DE LURIGANCHO", "SAN JUAN DE LURIGANCHO ")
replace distrito_normalizado = "SAN JUAN DE MIRAFLORES" if inlist(distrito_normalizado, "SAN JUAN DE MIRAFLORES", "SAN JUAN DE MIRAFLORES ")
replace distrito_normalizado = "SAN MARTIN DE PORRES" if inlist(distrito_normalizado, "SAN MARTIN DE PORRES", "SAN MARTIN DE PORRES ", "SPM")
replace distrito_normalizado = "SANTA ANITA" if inlist(distrito_normalizado, "SANTA ANITA", "SANTA ANITA ")
replace distrito_normalizado = "SULLANA" if inlist(distrito_normalizado, "SULLANA", "SULLANA ")
replace distrito_normalizado = "TARMA" if inlist(distrito_normalizado, "TARMA", "TARMA ")
replace distrito_normalizado = "TRUJILLO" if inlist(distrito_normalizado, "TRUJILLO", "TRUJILLO ")
replace distrito_normalizado = "VILLA EL SALVADOR" if inlist(distrito_normalizado, "VILLA EL SALVADOR", "VILLA EL SALVADOR ")
replace distrito_normalizado = "YANAHUARA" if inlist(distrito_normalizado, "YANAHUARA", "YANAHUARA ")
replace distrito_normalizado = "JOSE LEONARDO ORTIZ" if inlist(distrito_normalizado, "JOSE LEONSRDO ORTIZ")

label variable distrito_normalizado "3.3.- ¿En qué distrito vive?"


* Verificar la normalización
tab distrito_normalizado, m















* Crear una nueva variable para los nombres de los grupos étnicos
gen grupo_etnico = ""

* Asignar los nombres correspondientes según los códigos
replace grupo_etnico = "AIMARA" if DellistadomostradoConq == 2
replace grupo_etnico = "KANDOZI" if DellistadomostradoConq == 23
replace grupo_etnico = "QUECHUAS" if DellistadomostradoConq == 40
replace grupo_etnico = "URO" if DellistadomostradoConq == 49
replace grupo_etnico = "VACACOCHA" if DellistadomostradoConq == 50
replace grupo_etnico = "BLANCO" if DellistadomostradoConq == 57
replace grupo_etnico = "MESTIZO" if DellistadomostradoConq == 58
replace grupo_etnico = "ASIATICO DESCENDIENTE" if DellistadomostradoConq == 59

label variable grupo_etnico "6.- ¿Con que grupo étnico usted de identifica?"

* Verificar la asignación de los nombres
tab grupo_etnico, m








* Crear una nueva variable para la vivienda normalizada
gen vivienda_normalizada = ""

* Reemplazar y normalizar valores
replace vivienda_normalizada = "CASA FAMILIAR" if Laviviendaqueocupaensu == "Casa de hna" | ///
    Laviviendaqueocupaensu == "Casa familiar" | ///
    Laviviendaqueocupaensu == "Casa familiar (familia paterna)" | ///
    Laviviendaqueocupaensu == "FAMILIAR" | ///
    Laviviendaqueocupaensu == "Familiar" | ///
    Laviviendaqueocupaensu == "VIVIENDA DE PADRES" | ///
    Laviviendaqueocupaensu == "Vive en casa de su madre" | ///
    Laviviendaqueocupaensu == "Vivienda familiar" | ///
    Laviviendaqueocupaensu == "CASA DE LOS PADRES" | ///
    Laviviendaqueocupaensu == "Casa de los padres" | ///
    Laviviendaqueocupaensu == "Casa de padres" | ///
    Laviviendaqueocupaensu == "Casa de sus padres" | ///
    Laviviendaqueocupaensu == "Casa de un familiar" | ///
    Laviviendaqueocupaensu == "De mis padres" | ///
    Laviviendaqueocupaensu == "De sus padres" | ///
	Laviviendaqueocupaensu == "CASA DE LOS PADRES " | ///
	Laviviendaqueocupaensu == "CASA DE MIS PADRES " | ///
	Laviviendaqueocupaensu == "Casa de un familiar " | ///
	Laviviendaqueocupaensu == "De sus padres "

replace vivienda_normalizada = "ALQUILADA" if Laviviendaqueocupaensu == "¿Alquilada?"
replace vivienda_normalizada = "CEDIDA" if Laviviendaqueocupaensu == "¿Cedida por otro hogar o institutción?"
replace vivienda_normalizada = "PROPIA, PAGANDO" if Laviviendaqueocupaensu == "¿Propia, pagando a plazos o cuotas?"
replace vivienda_normalizada = "PROPIA, TOTALMENTE PAGADA" if Laviviendaqueocupaensu == "¿Propia, totalmente pagada?"
replace vivienda_normalizada = "OTROS" if Laviviendaqueocupaensu == "Heredada" | ///
    Laviviendaqueocupaensu == "Herencia de mi suegro" | ///
    Laviviendaqueocupaensu == "Propia/herencia"

label variable vivienda_normalizada "7.- La vivienda que ocupa en su hogar es"
	
* Verificar la normalización
tab vivienda_normalizada, m





* Crear variables para cada idioma
gen ingles = 0
gen frances = 0
gen portugues = 0
gen quechua = 0
gen otra_idioma_extranjero = 0
gen otra_lengua_originaria = 0

* Asignar 1 a las variables correspondientes si el idioma está presente
replace ingles = 1 if regexm(Conrespectoaldominiodeo, "Inglés")
replace frances = 1 if regexm(Conrespectoaldominiodeo, "Francés")
replace portugues = 1 if regexm(Conrespectoaldominiodeo, "Portugués")
replace quechua = 1 if regexm(Conrespectoaldominiodeo, "Quechua")
replace otra_idioma_extranjero = 1 if regexm(Conrespectoaldominiodeo, "Otra Idioma extranjero")
replace otra_lengua_originaria = 1 if regexm(Conrespectoaldominiodeo, "Otra Lengua originaria")

* Crear una etiqueta de valores para "No" y "Sí"
label define yesno 0 "No" 1 "Sí"

* Asignar la etiqueta de valores a las variables
label values ingles yesno
label values frances yesno
label values portugues yesno
label values quechua yesno
label values otra_idioma_extranjero yesno
label values otra_lengua_originaria yesno

* Verificar la creación y etiquetado de las variables
tab ingles, m
tab frances, m
tab portugues, m
tab quechua, m
tab otra_idioma_extranjero, m
tab otra_lengua_originaria, m













* Crear la nueva variable de grupos
gen grupo_dependientes = .

* Asignar los grupos
replace grupo_dependientes = 0 if Cuántaspersonasdependen == 0
replace grupo_dependientes = 1 if inrange(Cuántaspersonasdependen, 1, 3)
replace grupo_dependientes = 2 if Cuántaspersonasdependen > 3

* Asignar el nombre largo como etiqueta a la variable
label variable grupo_dependientes "11.- ¿Cuántas personas dependen económicamente de usted?"


* Aplicar el mismo label de Cuántaspersonasdependen a grupo_dependientes
label define dependientes 0 "0 personas" 1 "1-3 personas" 2 "Más de 3 personas", modify
label values grupo_dependientes dependientes

* Verificar la creación de la variable
tab grupo_dependientes, m
















* Normalizar la variable
gen universidad_normalizada = trim(Enquéuniversidadsetitu)

* Convertir a mayúsculas para estandarizar
replace universidad_normalizada = upper(universidad_normalizada)

* Simplificar nombres comunes de universidades
replace universidad_normalizada = "UNIVERSIDAD NACIONAL SAN AGUSTÍN" if regexm(universidad_normalizada, "SAN AGUSTÍN")
replace universidad_normalizada = "UNIVERSIDAD CATÓLICA DE SANTA MARÍA" if regexm(universidad_normalizada, "CATÓLICA DE SANTA MARÍA")
replace universidad_normalizada = "UNIVERSIDAD NACIONAL MAYOR DE SAN MARCOS" if regexm(universidad_normalizada, "MAYOR DE SAN MARCOS")
replace universidad_normalizada = "UNIVERSIDAD NACIONAL DE PIURA" if regexm(universidad_normalizada, "NACIONAL DE PIURA")
replace universidad_normalizada = "UNIVERSIDAD NACIONAL FEDERICO VILLARREAL" if regexm(universidad_normalizada, "FEDERICO VILLARREAL")
replace universidad_normalizada = "UNIVERSIDAD SAN MARTIN DE PORRES" if regexm(universidad_normalizada, "SAN MARTIN DE PORRES")
replace universidad_normalizada = "UNIVERSIDAD PRIVADA ANTENOR ORREGO" if regexm(universidad_normalizada, "ANTENOR ORREGO")
replace universidad_normalizada = "UNIVERSIDAD NACIONAL DE TRUJILLO" if regexm(universidad_normalizada, "NACIONAL DE TRUJILLO")
replace universidad_normalizada = "UNIVERSIDAD NACIONAL DEL ALTIPLANO" if regexm(universidad_normalizada, "NACIONAL DEL ALTIPLANO")
replace universidad_normalizada = "UNIVERSIDAD NACIONAL SAN ANTONIO ABAD DEL CUSCO" if regexm(universidad_normalizada, "SAN ANTONIO ABAD DEL CUSCO")
replace universidad_normalizada = "UNIVERSIDAD NACIONAL SAN LUIS GONZAGA DE ICA" if regexm(universidad_normalizada, "SAN LUIS GONZAGA DE ICA")
replace universidad_normalizada = "UNIVERSIDAD NACIONAL DE LA AMAZONÍA PERUANA" if regexm(universidad_normalizada, "AMAZONÍA PERUANA")
replace universidad_normalizada = "UNIVERSIDAD NACIONAL PEDRO RUIZ GALLO" if regexm(universidad_normalizada, "PEDRO RUIZ GALLO")
replace universidad_normalizada = "UNIVERSIDAD PRIVADA DE TACNA" if regexm(universidad_normalizada, "PRIVADA DE TACNA")
replace universidad_normalizada = "UNIVERSIDAD PERUANA CAYETANO HEREDIA" if regexm(universidad_normalizada, "CAYETANO HEREDIA")
replace universidad_normalizada = "UNIVERSIDAD CESAR VALLEJO" if regexm(universidad_normalizada, "CESAR VALLEJO")
replace universidad_normalizada = "UNIVERSIDAD SAN PEDRO" if regexm(universidad_normalizada, "SAN PEDRO")
replace universidad_normalizada = "UNIVERSIDAD PRIVADA SAN JUAN BAUTISTA" if regexm(universidad_normalizada, "SAN JUAN BAUTISTA")

* Asignar un label a la nueva variable
label variable universidad_normalizada "13.- ¿En qué universidad se tituló?"

* Verificar la normalización
tab universidad_normalizada, m













* Crear una nueva variable de grupos de años
gen grupo_titulo = .

*Aquí hay un error, porque puso 20, y debio ser 2020.
replace Enquéañoobtuvosutítul=2020 if Enquéañoobtuvosutítul==20

* Asignar los grupos
replace grupo_titulo = 1 if inrange(Enquéañoobtuvosutítul, 2020, 2024)  // Grupo de 2020 a 2024
replace grupo_titulo = 2 if inrange(Enquéañoobtuvosutítul, 2010, 2019)  // Grupo de 2010 a 2019
replace grupo_titulo = 3 if inrange(Enquéañoobtuvosutítul, 2000, 2009)  // Grupo de 2000 a 2009
replace grupo_titulo = 4 if inrange(Enquéañoobtuvosutítul, 1990, 1999)  // Grupo de 1990 a 1999
replace grupo_titulo = 5 if Enquéañoobtuvosutítul < 1990                // Grupo antes de 1990

* Etiquetar los grupos
label define grupo_titulo_label 1 "2020-2024" 2 "2010-2019" 3 "2000-2009" 4 "1990-1999" 5 "Antes de 1990"
label values grupo_titulo grupo_titulo_label

* Asignar un label a la nueva variable
label variable grupo_titulo "14.- ¿En qué año obtuvo su título universitario?" 

* Verificar la creación de la variable
tab grupo_titulo, m
















* Crear variables binarias para cada condición
gen actualmente_estudia_maestria = 0
gen actualmente_estudia_doctorado = 0
gen ha_concluido_maestria = 0
gen ninguno = 0
gen tiene_maestria_con_titulo = 0
gen ha_concluido_doctorado = 0
gen tiene_doctorado_con_titulo = 0

* Asignar 1 si la condición está presente
replace actualmente_estudia_maestria = 1 if regexm(Respectoalosestudiosde, "Actualmente estudia alguna maestría")
replace actualmente_estudia_doctorado = 1 if regexm(Respectoalosestudiosde, "Actualmente estudia algún doctorado")
replace ha_concluido_maestria = 1 if regexm(Respectoalosestudiosde, "Ha concluido el estudio de alguna maestría")
replace tiene_maestria_con_titulo = 1 if regexm(Respectoalosestudiosde, "Tiene maestría con título")
replace ha_concluido_doctorado = 1 if regexm(Respectoalosestudiosde, "Ha concluido el estudio de algún doctorado")
replace tiene_doctorado_con_titulo = 1 if regexm(Respectoalosestudiosde, "Tiene doctorado con título")

* Asignar la etiqueta a las nuevas variables
label values actualmente_estudia_maestria yesno
label values actualmente_estudia_doctorado yesno
label values ha_concluido_maestria yesno
label values tiene_maestria_con_titulo yesno
label values ha_concluido_doctorado yesno
label values tiene_doctorado_con_titulo yesno

* Verificar las variables creadas
tab actualmente_estudia_maestria, m
tab actualmente_estudia_doctorado, m
tab ha_concluido_maestria, m
tab tiene_maestria_con_titulo, m
tab ha_concluido_doctorado, m
tab tiene_doctorado_con_titulo, m
















* Crear variables binarias para cada factor con prefijo p26_
gen p26_cambio_actividad = 0
gen p26_estado_salud = 0
gen p26_estabilidad_laboral = 0
gen p26_vida_familiar = 0
gen p26_oportunidades_capacitacion = 0
gen p26_mejora_horario = 0
gen p26_mejora_trato_clima_laboral = 0
gen p26_mejora_sueldo = 0
gen p26_posibilidad_teletrabajo = 0
gen p26_mejora_fisico_trabajo = 0
gen p26_percepcion_corrupcion = 0
gen p26_no_desea_cambiar = 0
gen p26_no_quiere_cambiar = 0

* Asignar 1 si el factor está presente
replace p26_cambio_actividad = 1 if regexm(Quéfactoresinfluiríanmá, "Cambio de actividad")
replace p26_estado_salud = 1 if regexm(Quéfactoresinfluiríanmá, "Estado de salud")
replace p26_estabilidad_laboral = 1 if regexm(Quéfactoresinfluiríanmá, "Mayor estabilidad laboral")
replace p26_vida_familiar = 1 if regexm(Quéfactoresinfluiríanmá, "Mayores facilidades para su vida familiar")
replace p26_oportunidades_capacitacion = 1 if regexm(Quéfactoresinfluiríanmá, "Mayores oportunidades de estudios y capacitación")
replace p26_mejora_horario = 1 if regexm(Quéfactoresinfluiríanmá, "Mejora de horario")
replace p26_mejora_trato_clima_laboral = 1 if regexm(Quéfactoresinfluiríanmá, "Mejora del trato y clima laboral")
replace p26_mejora_sueldo = 1 if regexm(Quéfactoresinfluiríanmá, "Mejora de sueldo")
replace p26_posibilidad_teletrabajo = 1 if regexm(Quéfactoresinfluiríanmá, "Posibilidad de teletrabajo")
replace p26_mejora_fisico_trabajo = 1 if regexm(Quéfactoresinfluiríanmá, "Mejora del ambiente físico de trabajo")
replace p26_percepcion_corrupcion = 1 if regexm(Quéfactoresinfluiríanmá, "Percepción de deshonestidad y corrupción en la gestión de la institución")
replace p26_no_desea_cambiar = 1 if regexm(Quéfactoresinfluiríanmá, "No desea cambiar de trabajo")
replace p26_no_quiere_cambiar = 1 if regexm(Quéfactoresinfluiríanmá, "No quiere cambiar le gusta en donde esta")

* Asignar la etiqueta a las nuevas variables
label values p26_cambio_actividad yesno
label values p26_estado_salud yesno
label values p26_estabilidad_laboral yesno
label values p26_vida_familiar yesno
label values p26_oportunidades_capacitacion yesno
label values p26_mejora_horario yesno
label values p26_mejora_trato_clima_laboral yesno
label values p26_mejora_sueldo yesno
label values p26_posibilidad_teletrabajo yesno
label values p26_mejora_fisico_trabajo yesno
label values p26_percepcion_corrupcion yesno
label values p26_no_desea_cambiar yesno
label values p26_no_quiere_cambiar yesno

tab1  p26_cambio_actividad p26_estado_salud p26_estabilidad_laboral p26_vida_familiar p26_oportunidades_capacitacion p26_mejora_horario p26_mejora_trato_clima_laboral p26_mejora_sueldo p26_posibilidad_teletrabajo p26_mejora_fisico_trabajo p26_percepcion_corrupcion p26_no_desea_cambiar p26_no_quiere_cambiar, m














*************
*Aquí hay errores en la variable, ya que hay 21 casos donde estan trabajando antes de su titulo.
* Crear la nueva variable de grupos
gen grupo_anios_laborando = .

* Calcular el tiempo desde la obtención del título
gen tiempo_desde_titulo = 2024 - Enquéañoobtuvosutítul

* Asignar los grupos según los rangos
replace grupo_anios_laborando = 1 if inrange(Cuántosañosvienelabora, 1, 4)  // Grupo 1-4 años
replace grupo_anios_laborando = 2 if inrange(Cuántosañosvienelabora, 5, 9)  // Grupo 5-9 años
replace grupo_anios_laborando = 3 if inrange(Cuántosañosvienelabora, 10, 14)  // Grupo 10-14 años
replace grupo_anios_laborando = 4 if Cuántosañosvienelabora >= 15 & Cuántosañosvienelabora <= 40  // Grupo 15 a más años

* Colocar como missing si el tiempo desde el título es mayor que los años laborando
replace grupo_anios_laborando = . if Cuántosañosvienelabora >= tiempo_desde_titulo

* Etiquetar los grupos
label define grupo_anios_label 1 "1-4 años" 2 "5-9 años" 3 "10-14 años" 4 "15 a más años"
label values grupo_anios_laborando grupo_anios_label

* Verificar la creación de la variable
tab grupo_anios_laborando, m

* Eliminar la variable temporal
drop tiempo_desde_titulo












* Crear la nueva variable de grupos de horas trabajadas
gen grupo_horas_trabajadas = .

* Asignar los grupos según los rangos especificados
replace grupo_horas_trabajadas = 1 if inrange(EnpromedioCuántashoras, 1, 35)   // Grupo 1-35 horas
replace grupo_horas_trabajadas = 2 if inrange(EnpromedioCuántashoras, 36, 48)  // Grupo 36-48 horas
replace grupo_horas_trabajadas = 3 if inrange(EnpromedioCuántashoras, 49, 56)  // Grupo 49-56 horas
replace grupo_horas_trabajadas = 4 if inrange(EnpromedioCuántashoras, 57, 72)  // Grupo 57-72 horas
replace grupo_horas_trabajadas = 5 if inrange(EnpromedioCuántashoras, 73, 80)  // Grupo 73-80 horas

* Colocar como missing si es más de 85 horas
replace grupo_horas_trabajadas = . if EnpromedioCuántashoras > 81

* Etiquetar los grupos
label define grupo_horas_label 1 "1-35 horas" 2 "36-48 horas" 3 "49-56 horas" 4 "57-72 horas" 5 "73-80 horas"
label values grupo_horas_trabajadas grupo_horas_label

* Verificar la creación de la variable
tab grupo_horas_trabajadas, m














* Crear la nueva variable de grupos de días de descanso médico
gen p46_grupo_dias_descanso = .

* Asignar los grupos según los rangos especificados
replace p46_grupo_dias_descanso = 1 if Enlosúltimos12mesesC == 0      // Grupo 0 días
replace p46_grupo_dias_descanso = 2 if inrange(Enlosúltimos12mesesC, 1, 20)  // Grupo 1-20 días
replace p46_grupo_dias_descanso = 3 if Enlosúltimos12mesesC >= 21     // Grupo 21 o más días

* Etiquetar los grupos
label define p46_grupo_dias_descanso_label 1 "0 días" 2 "1-20 días" 3 "21 o más días"
label values p46_grupo_dias_descanso p46_grupo_dias_descanso_label

* Asignar un label a la nueva variable
label variable p46_grupo_dias_descanso "46.- En los últimos 12 meses, ¿Cuántos días de descanso médico ha tenido?"

* Verificar la creación de la variable
tab p46_grupo_dias_descanso, m








* JENKINS (JSS_4)
* Renombrar las variables
rename Conrelaciónalúltimomes jss_1
rename CE jss_2
rename CF jss_3
rename CG jss_4

* Convertir las variables string a numéricas con etiquetas
encode jss_1, gen(p56_jss1)
encode jss_2, gen(p56_jss2)
encode jss_3, gen(p56_jss3)
encode jss_4, gen(p56_jss4)

* Definir las etiquetas de valores
label define jss_label 1 "No me ocurre" 2 "Me ocurre 1-3 días" 3 "Me ocurre 4-7 días" 4 "Me ocurre 8-14 días" 5 "Me ocurre 15-21 días" 6 "Me ocurre 22-31 días"

* Aplicar las etiquetas a las variables
label values p56_jss1 jss_label
label values p56_jss2 jss_label
label values p56_jss3 jss_label
label values p56_jss4 jss_label

* Verificar la recodificación
tab p56_jss1, m
tab p56_jss2, m
tab p56_jss3, m
tab p56_jss4, m











* Convertir la variable "Durantelas2últimasseman" a una variable numérica y renombrarla a "p53_phq1"
gen p53_phq1 = .
replace p53_phq1 = 0 if Durantelas2últimasseman == "Nunca"
replace p53_phq1 = 1 if Durantelas2últimasseman == "Varios días"
replace p53_phq1 = 2 if Durantelas2últimasseman == "Más de la mitad de los días"
replace p53_phq1 = 3 if Durantelas2últimasseman == "Casi todo los días"

* Convertir la variable "BZ" a una variable numérica y renombrarla a "p53_phq2"
gen p53_phq2 = .
replace p53_phq2 = 0 if BZ == "Nunca"
replace p53_phq2 = 1 if BZ == "Varios días"
replace p53_phq2 = 2 if BZ == "Más de la mitad de los días"
replace p53_phq2 = 3 if BZ == "Casi todo los días"

* Convertir la variable "CA" a una variable numérica y renombrarla a "p54_gad1"
gen p54_gad1 = .
replace p54_gad1 = 0 if CA == "Nunca"
replace p54_gad1 = 1 if CA == "Varios días"
replace p54_gad1 = 2 if CA == "Más de la mitad de los días"
replace p54_gad1 = 3 if CA == "Casi todo los días"

* Convertir la variable "CB" a una variable numérica y renombrarla a "p54_gad24"
gen p54_gad2 = .
replace p54_gad2 = 0 if CB == "Nunca"
replace p54_gad2 = 1 if CB == "Varios días"
replace p54_gad2 = 2 if CB == "Más de la mitad de los días"
replace p54_gad2 = 3 if CB == "Casi todo los días"


rename Cómocalificaríaustedsu p79_1
rename DA p79_2
rename DB p79_3
rename Respectoasutrabajoenes p81_1
rename DD p81_2
rename DE p81_3
rename DF p81_4
rename DG p81_5
rename DH p81_6
rename DI p81_7
rename DJ p81_8
rename DK p81_9
rename DL p81_10
rename DM p81_11
rename DN p81_12
rename DO p81_13
rename DP p81_14
rename DQ p81_15
rename DR p81_16
rename Enrelaciónconsuactivid p82_1
rename DT p82_2
rename DU p82_3
rename DV p82_4
rename DW p82_5
rename DX p82_6
rename Conrelaciónalequipodeg p83_1
rename DZ p83_2
rename EA p83_3
rename EB p83_4
rename EC p83_5
rename ED p83_6
rename EE p83_7
rename EF p83_8
rename Acontinuaciónsepresentan p85_SWLS1
rename EH p85_SWLS2
rename EI p85_SWLS3
rename EJ p85_SWLS4
rename EK p85_SWLS5

rename Porfavorseleccioneopul p49_burnout1
rename BG p49_burnout2
rename BH p49_burnout3
rename BI p49_burnout4
rename BJ p49_burnout5
rename BK p49_burnout6
rename BL p49_burnout7
rename BM p49_burnout8
rename BN p49_burnout9
rename BO p49_burnout10
rename BP p49_burnout11
rename BQ p49_burnout12
rename BR p49_burnout13
rename BS p49_burnout14

rename Encuantoasumovilidadh EQ5D5L_1
rename Encuantoasucuidadopers EQ5D5L_2
rename Encuantoasusactividades EQ5D5L_3
rename Encuantoaldolormalestar EQ5D5L_4
rename Encuantoasuansiedaddep EQ5D5L_5

rename Indiqueenlaescalasuest p57_EQVAS










* Codificar EQ5D5L_1 (Movilidad)
gen EQ5D5L_1_num = .
replace EQ5D5L_1_num = 1 if EQ5D5L_1 == "No tengo problemas para caminar"
replace EQ5D5L_1_num = 2 if EQ5D5L_1 == "Tengo problemas leves para caminar"
replace EQ5D5L_1_num = 3 if EQ5D5L_1 == "Tengo problemas moderados para caminar"
replace EQ5D5L_1_num = 4 if EQ5D5L_1 == "Tengo problemas graves para caminar"
replace EQ5D5L_1_num = 5 if EQ5D5L_1 == "Soy incapaz de caminar"

* Codificar EQ5D5L_2 (Cuidado personal)
gen EQ5D5L_2_num = .
replace EQ5D5L_2_num = 1 if EQ5D5L_2 == "No tengo problemas para lavarme o vestirme"
replace EQ5D5L_2_num = 2 if EQ5D5L_2 == "Tengo problemas leves para lavarme o vestirme"
replace EQ5D5L_2_num = 3 if EQ5D5L_2 == "Tengo problemas moderados para lavarme o vestirme"
replace EQ5D5L_2_num = 4 if EQ5D5L_2 == "Tengo problemas graves para lavarme o vestirme"
replace EQ5D5L_2_num = 5 if EQ5D5L_2 == "Soy incapaz de lavarme o vestirme"

* Codificar EQ5D5L_3 (Actividades cotidianas)
gen EQ5D5L_3_num = .
replace EQ5D5L_3_num = 1 if EQ5D5L_3 == "No tengo problemas para realizar mis actividades cotidianas"
replace EQ5D5L_3_num = 2 if EQ5D5L_3 == "Tengo problemas leves para realizar mis actividades cotidianas"
replace EQ5D5L_3_num = 3 if EQ5D5L_3 == "Tengo problemas moderados para realizar mis actividades cotidianas"
replace EQ5D5L_3_num = 4 if EQ5D5L_3 == "Tengo problemas graves para realizar mis actividades cotidianas"
replace EQ5D5L_3_num = 5 if EQ5D5L_3 == "Soy incapaz de realizar mis actividades cotidianas"

* Codificar EQ5D5L_4 (Dolor/malestar)
gen EQ5D5L_4_num = .
replace EQ5D5L_4_num = 1 if EQ5D5L_4 == "No tengo dolor ni malestar"
replace EQ5D5L_4_num = 2 if EQ5D5L_4 == "Tengo dolor o malestar leve"
replace EQ5D5L_4_num = 3 if EQ5D5L_4 == "Tengo dolor o malestar moderado"
replace EQ5D5L_4_num = 4 if EQ5D5L_4 == "Tengo dolor o malestar severo"
replace EQ5D5L_4_num = 5 if EQ5D5L_4 == "Tengo dolor o malestar extremo"

* Codificar EQ5D5L_5 (Ansiedad/depresión)
gen EQ5D5L_5_num = .
replace EQ5D5L_5_num = 1 if EQ5D5L_5 == "No estoy angustiado ni deprimido"
replace EQ5D5L_5_num = 2 if EQ5D5L_5 == "Estoy levemente angustiado o deprimido"
replace EQ5D5L_5_num = 3 if EQ5D5L_5 == "Estoy moderadamente angustiado o deprimido"
replace EQ5D5L_5_num = 4 if EQ5D5L_5 == "Estoy muy angustiado o deprimido"
replace EQ5D5L_5_num = 5 if EQ5D5L_5 == "Estoy extremadamente angustiado o deprimido"




/*

* Recodificar de cinco niveles a tres niveles
replace EQ5D5L_1_num = 3 if EQ5D5L_1_num == 4 | EQ5D5L_1_num == 5
replace EQ5D5L_1_num = 2 if EQ5D5L_1_num == 2 | EQ5D5L_1_num == 3
replace EQ5D5L_2_num = 3 if EQ5D5L_2_num == 4 | EQ5D5L_2_num == 5
replace EQ5D5L_2_num = 2 if EQ5D5L_2_num == 2 | EQ5D5L_2_num == 3
replace EQ5D5L_3_num = 3 if EQ5D5L_3_num == 4 | EQ5D5L_3_num == 5
replace EQ5D5L_3_num = 2 if EQ5D5L_3_num == 2 | EQ5D5L_3_num == 3
replace EQ5D5L_4_num = 3 if EQ5D5L_4_num == 4 | EQ5D5L_4_num == 5
replace EQ5D5L_4_num = 2 if EQ5D5L_4_num == 2 | EQ5D5L_4_num == 3
replace EQ5D5L_5_num = 3 if EQ5D5L_5_num == 4 | EQ5D5L_5_num == 5
replace EQ5D5L_5_num = 2 if EQ5D5L_5_num == 2 | EQ5D5L_5_num == 3

* Ahora intenta de nuevo el comando
eq5d EQ5D5L_1_num EQ5D5L_2_num EQ5D5L_3_num EQ5D5L_4_num EQ5D5L_5_num, country(US)
*/








gen PHQ2 = p53_phq1 + p53_phq2
gen GAD2 = p54_gad1 + p54_gad2
gen JSS4 =  p56_jss1 + p56_jss2 + p56_jss3 + p56_jss4

gen ESAPG = p82_1 + p82_2 + p82_3 + p82_4 + p82_5 + p82_6
gen ESGSS = p83_1 + p83_2 + p83_3 + p83_4 + p83_5 + p83_6 + p83_7 + p83_8

gen ESCTCS_Individuales =  p81_1 + p81_3 + p81_4 + p81_5 + p81_6 + p81_8 + p81_9 + p81_13
gen ESCTCS_Estructurales =  p81_11 + p81_12 + p81_14

gen SWLS = p85_SWLS1 + p85_SWLS2 + p85_SWLS3 + p85_SWLS4 + p85_SWLS5



gen MBI_AgotamientoEmocional = p49_burnout1 + p49_burnout2 + p49_burnout3 + p49_burnout4 + p49_burnout5
gen MBI_Despersonalizacion = p49_burnout6 + p49_burnout7 + p49_burnout8
gen MBI_Realizacion_Personal = p49_burnout9 + p49_burnout10 + p49_burnout11 + p49_burnout12 + p49_burnout13 + p49_burnout14




summarize PHQ2 GAD2 JSS4 ESAPG ESGSS ESCTCS_Individuales ESCTCS_Estructurales SWLS MBI_AgotamientoEmo



gen depression = 0 
replace depression = 1 if PHQ2>=2
label define depression 0 "No" 1 "Si"
tab depression, m


gen anxiety = 0 
replace anxiety = 1 if GAD2>=2
label define anxiety 0 "No" 1 "Si"
tab anxiety, m



* Crear la nueva variable dicotómica pp59_agredido_fisica
gen pp59_agredido_fisica = .

* Asignar valores a la variable según las categorías
replace pp59_agredido_fisica = 0 if Algunavezdurantesuvida == "No"
replace pp59_agredido_fisica = 1 if inlist(Algunavezdurantesuvida, "Si, más de una vez", "Si, sólo una vez")

* Verificar la variable
tab pp59_agredido_fisica, m

* Asignar etiquetas a la variable dicotómica
label define agredido_lbl 0 "No" 1 "Si"
label values pp59_agredido_fisica agredido_lbl

label variable pp59_agredido_fisica "59.- ¿Alguna vez durante su vida profesional ha sido agredido/a fisicamente en su lugar de trabajo?"


* Verificar la variable con las etiquetas aplicadas
tab pp59_agredido_fisica, m







* Crear la nueva variable dicotómica pp61_agredido_lugartrabajo
gen pp61_agredido_lugartrabajo = .

* Asignar valores a la variable según las categorías
replace pp61_agredido_lugartrabajo = 0 if Enlosúltimos12mesesUs == "No"
replace pp61_agredido_lugartrabajo = 1 if inlist(Enlosúltimos12mesesUs, "Si, sólo una vez", "Sí, más de una vez")

* Verificar la variable
tab pp61_agredido_lugartrabajo, m

* Asignar etiquetas a la variable dicotómica
label define agredido_lugartrabajo_lbl 0 "No" 1 "Si"
label values pp61_agredido_lugartrabajo agredido_lugartrabajo_lbl
label variable pp61_agredido_lugartrabajo "61.- En los últimos 12 meses,¿Usted ha sido agredido/a fisicamente en su lugar de trabajo?"

* Verificar la variable con las etiquetas aplicadas
tab pp61_agredido_lugartrabajo, m








* Crear la nueva variable dicotómica pp64_insultado
gen pp64_insultado = .

* Asignar valores a la variable según las categorías
replace pp64_insultado = 0 if CN == "No"
replace pp64_insultado = 1 if inlist(CN, "Si, más de una vez", "Si, sólo una vez")

* Verificar la variable
tab pp64_insultado, m

* Asignar etiquetas a la variable dicotómica
label define insultado_lbl 0 "No" 1 "Si"
label values pp64_insultado insultado_lbl
label variable pp64_insultado "64.- ¿Alguna vez durante su vida profesional ha sido insultado en su lugar de trabajo?"

* Verificar la variable con las etiquetas aplicadas
tab pp64_insultado, m







* Crear la nueva variable dicotómica pp66_insultado_12m
gen pp66_insultado_12m = .

* Asignar valores a la variable según las categorías
replace pp66_insultado_12m = 0 if Enlosúltimos12mesesus == "No"
replace pp66_insultado_12m = 1 if inlist(Enlosúltimos12mesesus, "Si, más de una vez", "Si, sólo una vez")

* Verificar la variable
tab pp66_insultado_12m, m

* Asignar etiquetas a la variable dicotómica
label define insultado_12m_lbl 0 "No" 1 "Si"
label values pp66_insultado_12m insultado_12m_lbl
label variable pp66_insultado_12m "66.- En los últimos 12 meses, usted ¿Ha sido insultado en su lugar de trabajo?"

* Verificar la variable con las etiquetas aplicadas
tab pp66_insultado_12m, m









* Crear la nueva variable dicotómica pp69_amenazado
gen pp69_amenazado = .

* Asignar valores a la variable según las categorías
replace pp69_amenazado = 0 if CR == "No"
replace pp69_amenazado = 1 if inlist(CR, "Si, más de una vez", "Si, sólo una vez")

* Verificar la variable
tab pp69_amenazado, m

* Asignar etiquetas a la variable dicotómica
label define amenazado_lbl 0 "No" 1 "Si"
label values pp69_amenazado amenazado_lbl
label variable pp69_amenazado "69.- ¿Alguna vez durante su vida profesional ha sido amenazado en su lugar de trabajo?"

* Verificar la variable con las etiquetas aplicadas
tab pp69_amenazado, m












* Crear la nueva variable dicotómica pp71_amenazado_12m
gen pp71_amenazado_12m = .

* Asignar valores a la variable según las categorías
replace pp71_amenazado_12m = 0 if CT == "No"
replace pp71_amenazado_12m = 1 if inlist(CT, "Si, más de una vez", "Si, sólo una vez")

* Verificar la variable
tab pp71_amenazado_12m, m

* Asignar etiquetas a la variable dicotómica
label define amenazado_12m_lbl 0 "No" 1 "Si"
label values pp71_amenazado_12m amenazado_12m_lbl
label variable pp71_amenazado_12m "71.- En los últimos 12 meses, usted ¿Ha sido amenazado en su lugar de trabajo?"

* Verificar la variable con las etiquetas aplicadas
tab pp71_amenazado_12m, m












* Crear la nueva variable dicotómica pp74_acoso_sexual
gen pp74_acoso_sexual = .

* Asignar valores a la variable según las categorías
replace pp74_acoso_sexual = 0 if CV == "No"
replace pp74_acoso_sexual = 1 if inlist(CV, "Si, más de una vez", "Si, sólo una vez")

* Verificar la variable
tab pp74_acoso_sexual, m

* Asignar etiquetas a la variable dicotómica
label define acoso_sexual_lbl 0 "No" 1 "Si"
label values pp74_acoso_sexual acoso_sexual_lbl
label variable pp74_acoso_sexual "74.- ¿Alguna vez durante su vida profesional ha sido acosado/a sexualmente en su lugar de trabajo?"

* Verificar la variable con las etiquetas aplicadas
tab pp74_acoso_sexual, m











* Crear la nueva variable dicotómica pp76_acoso_sexual_12m
gen pp76_acoso_sexual_12m = .

* Asignar valores a la variable según las categorías
replace pp76_acoso_sexual_12m = 0 if CX == "No"
replace pp76_acoso_sexual_12m = 1 if inlist(CX, "Si, sólo una vez")

* Verificar la variable
tab pp76_acoso_sexual_12m, m

* Asignar etiquetas a la variable dicotómica
label define acoso_sexual_12m_lbl 0 "No" 1 "Si"
label values pp76_acoso_sexual_12m acoso_sexual_12m_lbl
label variable pp76_acoso_sexual_12m "76.- En los últimos 12 meses, usted ¿Ha sido acosado/a sexualmente en su lugar de trabajo?"

* Verificar la variable con las etiquetas aplicadas
tab pp76_acoso_sexual_12m, m











* Renombrar la variable existente para mantener la consistencia en el nombre
gen pp91_satisfaccion = Encuantoalrolqueviene

* Asignar etiquetas a los valores de la variable pp91_satisfaccion
label define satisfaccion_lbl 1 "Muy Insatisfecho" 2 "Insatisfecho" 3 "Indiferente/Neutro" 4 "Satisfecho" 5 "Muy Satisfecho"

* Aplicar las etiquetas a la variable
label values pp91_satisfaccion satisfaccion_lbl
label variable pp91_satisfaccion "91.- En cuanto al rol que viene cumpliendo SUSALUD, ¿Cuál es su nivel de satisfacción?"

* Verificar la nueva variable con sus etiquetas
tab pp91_satisfaccion, m









* Crear una nueva variable numérica basada en la variable original
gen pp92_corrupcion = .

* Asignar valores numéricos según las categorías
replace pp92_corrupcion = 5 if Cuáleselniveldecorrup == "Muy alto"
replace pp92_corrupcion = 4 if Cuáleselniveldecorrup == "Alto"
replace pp92_corrupcion = 3 if Cuáleselniveldecorrup == "Moderado"
replace pp92_corrupcion = 2 if Cuáleselniveldecorrup == "Bajo"
replace pp92_corrupcion = 1 if Cuáleselniveldecorrup == "Muy Bajo"

* Etiquetar las categorías
label define nivel_corrupcion_lbl 1 "Muy Bajo" 2 "Bajo" 3 "Moderado" 4 "Alto" 5 "Muy alto"

* Asignar las etiquetas a la variable numérica
label values pp92_corrupcion nivel_corrupcion_lbl
label variable pp92_corrupcion "92.- ¿Cuál es el nivel de corrupción que usted percibe en el sistema de salud del Perú?"

* Verificar los resultados
tab pp92_corrupcion, m nola



gen pp92_corrupcion_dico = 0 if pp92_corrupcion==1 | pp92_corrupcion==2 | pp92_corrupcion==3
replace pp92_corrupcion_dico = 1 if pp92_corrupcion==4 | pp92_corrupcion==5
* Asignar etiquetas a la variable dicotómica
label define pp92_corrupcion_dico 0 "Muy Bajo, Bajo o Moderado" 1 "Alto o Muy alto"
label values pp92_corrupcion_dico pp92_corrupcion_dico
label variable pp92_corrupcion_dico "92.- ¿Cuál es el nivel de corrupción que usted percibe en el sistema de salud del Perú?"

* Verificar la variable con las etiquetas aplicadas
tab pp92_corrupcion_dico, m






* Crear la nueva variable dicotómica
gen pp93_victima_discriminacion = 0

* Asignar el valor 1 a las categorías que indican discriminación
replace pp93_victima_discriminacion = 1 if inlist(Enlosúltimos12meses, "Sí, he sido víctima de discriminación en un establecimiento de salud público", ///
                                                 "Sí, he sido víctima de discriminación en un establecimiento de salud privado", ///
                                                 "Sí, he sido víctima de discriminación en establecimientos de salud tanto públicos como privados.")

label variable pp93_victima_discriminacion "93.- ¿ En los últimos 12 meses, usted ha sido víctima de algún acto de discriminación en el sistema de salud peruano?"												 
												 
* Verificar los resultados
tab pp93_victima_discriminacion, m






tab1  pp59_agredido_fisica pp61_agredido_lugartrabajo pp64_insultado pp66_insultado_12m pp69_amenazado pp71_amenazado_12m pp74_acoso_sexual pp76_acoso_sexual_12m pp91_satisfaccion pp92_corrupcion pp93_victima_discriminacion, m
















*Sociodemograficas
gen sex = .
replace sex = 0 if Cuálessusexo == "Mujer"
replace sex = 1 if Cuálessusexo == "Varón"

label variable sex "Sexo: Mujer=0, Varón=1"

















*********************	
*1. Criterios de inclusión
*********************	
drop Ingresesusnombresyapellidos

keep  grupo_edad region_clean provincia_clean distrito_normalizado grupo_etnico vivienda_normalizada ingles frances portugues quechua otra_idioma_extranjero otra_lengua_originaria grupo_dependientes universidad_normalizada grupo_titulo actualmente_estudia_maestria actualmente_estudia_doctorado ha_concluido_maestria ninguno tiene_maestria_con_titulo ha_concluido_doctorado tiene_doctorado_con_titulo p26_cambio_actividad p26_estado_salud p26_estabilidad_laboral p26_vida_familiar p26_oportunidades_capacitacion p26_mejora_horario p26_mejora_trato_clima_laboral p26_mejora_sueldo p26_posibilidad_teletrabajo p26_mejora_fisico_trabajo p26_percepcion_corrupcion p26_no_desea_cambiar p26_no_quiere_cambiar grupo_anios_laborando grupo_horas_trabajadas p46_grupo_dias_descanso p56_jss1 p56_jss2 p56_jss3 p56_jss4 p53_phq1 p53_phq2 p54_gad1 p54_gad2 EQ5D5L_1_num EQ5D5L_2_num EQ5D5L_3_num EQ5D5L_4_num EQ5D5L_5_num PHQ2 GAD2 JSS4 ESAPG ESGSS ESCTCS_Individuales ESCTCS_Estructurales SWLS MBI_AgotamientoEmocional MBI_Despersonalizacion MBI_Realizacion_Personal pp59_agredido_fisica pp61_agredido_lugartrabajo pp64_insultado pp66_insultado_12m pp69_amenazado pp71_amenazado_12m pp74_acoso_sexual pp76_acoso_sexual_12m pp91_satisfaccion pp92_corrupcion pp93_victima_discriminacion








*********************	
*2. Save
*********************	
save "C:\Users\USER\Downloads\Database_4.dta", replace












*********************	
*3. Analysis
*********************	

*Corrupción
poisson pp92_corrupcion i.sex i.grupo_edad i.depression i.anxiety JSS4 ESAPG ESGSS ESCTCS_Individuales ESCTCS_Estructurales SWLS MBI_AgotamientoEmocional MBI_Despersonalizacion MBI_Realizacion_Personal, irr cformat(%9.2f)


*Discriminación
poisson pp93_victima_discriminacion i.sex i.grupo_edad i.depression i.anxiety JSS4 ESAPG ESGSS ESCTCS_Individuales ESCTCS_Estructurales SWLS MBI_AgotamientoEmocional MBI_Despersonalizacion MBI_Realizacion_Personal, irr cformat(%9.2f)


*Violencia fisica
poisson pp59_agredido_fisica i.sex i.grupo_edad i.depression i.anxiety JSS4 ESAPG ESGSS ESCTCS_Individuales ESCTCS_Estructurales SWLS MBI_AgotamientoEmocional MBI_Despersonalizacion MBI_Realizacion_Personal, irr cformat(%9.2f)
*Insultado
poisson pp64_insultado i.sex i.grupo_edad i.depression i.anxiety JSS4 ESAPG ESGSS ESCTCS_Individuales ESCTCS_Estructurales SWLS MBI_AgotamientoEmocional MBI_Despersonalizacion MBI_Realizacion_Personal, irr cformat(%9.2f)
*Amenazado
poisson pp69_amenazado i.sex i.grupo_edad i.depression i.anxiety JSS4 ESAPG ESGSS ESCTCS_Individuales ESCTCS_Estructurales SWLS MBI_AgotamientoEmocional MBI_Despersonalizacion MBI_Realizacion_Personal, irr cformat(%9.2f)
*Acoso sexual
poisson pp74_acoso_sexual i.sex i.grupo_edad i.depression i.anxiety JSS4 ESAPG ESGSS ESCTCS_Individuales ESCTCS_Estructurales SWLS MBI_AgotamientoEmocional MBI_Despersonalizacion MBI_Realizacion_Personal, irr cformat(%9.2f)

  
  
  
  


/*
*********************	
*6. Table 1. Sociodemografic characteristics
*********************	

*Definir macro global de variables categoricas:
global catvars_table1 Turno Cuálessuprofesión Cuálessusexo Cuálessuestadociviloc grupo_edad grupo_etnico vivienda_normalizada grupo_dependientes grupo_titulo

******* Ejecutar comando que crea tabla
tabout $catvars_table1 Cuálessuprofesión using table1.xlsx, /// 
		replace c(freq col) clab(No. %) f(0c 1p) style(xlsx) font(bold) /// 
		ptotal(none) stats(chi2) stpos(col) ppos(only) plab(P value) /// 
		title(Tabla 1. Características sociodemográficas.) /// 
		fn(Nota: n=número, %=Porcentaje, valor p mediante la prueba Chi-cuadrado.) twidth(14) sheet(Table1)

		
		
		
		
		
		
*Guardar base de datos
save "C:\Users\DAVID\Dropbox\David\Trabajos\1. TERMINADOS\SUSALUD\2024\Fin de año - David\4. Productos\1. Producto 1\0. Material suplementario\Database.dta", replace

		
		
		
		

