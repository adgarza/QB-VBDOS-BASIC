' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' '
' Analizador de Expresiones Matem ticas Versi¢n 1.0b      '
'                                                         '
' M¢dulo que se encarga de obtener una cadena, analizarla '
' matem ticamente y proporcionar el resultado de la       '
' operaci¢n hecha. Aseg£rate que incluyes en el proyecto  '
' las declaraciones de funciones. Si no lo haces, podr¡as '
' no conseguir resultados de este m¢dulo.                 '
'                                                         '
' Realizado originalmente en Visual Basic 4.0 y traducido '
' a QBASIC por A. David Garza Mar¡n                       '
' e-mail: adgarza@spin.com.mx                             '
' GMD MicroSistemas, M‚xico                               '
' Tel: 693-6658 y 692-6072                                '
' ******************************************************* '
' Eres libre de utilizar y modificar este c¢digo para     '
' adaptarlo a tus necesidades. Pero por favor, no me      '
' quites el cr‚dito que me corresponda. Me tard‚ algunas  '
' horas en su generaci¢n y creo que merezco tal cr‚dito.  '
'                                                         '
' Env¡ame un mensaje a mi direcci¢n electr¢nica en:       '
' adgarza@spin.com.mx para reportarme errores o comentar  '
' lo que desees respecto a esta clase o Visual Basic.     '
' ******************************************************* '
' MODIFICACIONES:                                         '
'                                                         '
' Fecha   | Revisi¢n                                      '
' --------+---------------------------------------------- '
' 16/06/97| Se a¤ade un dato miembro Error que lleva un   '
'         | control de los errores ocurridos en los m‚to- '
'         | dos.
' 18/06/97| Se a¤ade el c¢digo de error 8, "No se puede   '
'         | dividir entre cero" al conjunto de errores.   '
' 14/12/98| Se corrigen algunos bug's relacionados con    '
'         | operaciones con numeros con signo.            '
' 15/12/98| Se a¤ade un metodo llamado CalculaFormula, el '
'         | cual elimina los espacios y verifica la ley de'
'         | los signos                                    '
'         | Modificaciones hechas por Alejandro Ju rez B. '
'         | dsoft@mpsnet.com.mx                           '
' 15/12/98| Se cambia a privada la funci¢n CalculaFormula '
'         | (adgarza).                                    '
' 21/05/99| Se traduce a QBASIC en forma de m¢dulo.       '
'         | (adgarza).                                    '
' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' '

' OPTION EXPLICIT
' $DYNAMIC
DEFINT A-Z

' -----Copia estas declaraciones en tus m¢dulos ----
DECLARE SUB Constructor ()
DECLARE SUB Destructor ()
DECLARE SUB doLimpiaVar ()
DECLARE SUB doRemVar (Variable AS STRING)
DECLARE SUB getObtieneVar ()
DECLARE SUB setExpresion (strCualExpresionEvaluar AS STRING)
DECLARE SUB setNuevaVar (strNombre AS STRING)
DECLARE SUB setNuevoValor (varVariable AS STRING, varValor AS DOUBLE)
DECLARE FUNCTION AnalizaExpr# ()
DECLARE FUNCTION Expresion$ ()
DECLARE FUNCTION CErr% ()
DECLARE FUNCTION CuentaVar% ()
DECLARE FUNCTION DErr$ ()
DECLARE FUNCTION NombreVar$ (iCualVariable AS INTEGER)
DECLARE FUNCTION Valor# (varVariable AS STRING)
' -----La copia es hasta aqu¡. Las dem s declaraciones no es necesario que las copies

' ******** Funciones locales *********************
DECLARE FUNCTION SinAcentos% (strCadena AS STRING)
DECLARE FUNCTION BuscaVar% (CualVar AS STRING)
DECLARE FUNCTION CalculaFormula# (strFormula AS STRING)
DECLARE FUNCTION AnalisisFormula# (strFormula AS STRING)
DECLARE FUNCTION NumDer# (strCadena AS STRING, iPos AS INTEGER, iPosD AS INTEGER)
DECLARE FUNCTION NumIzq# (strCadena AS STRING, iPos AS INTEGER, iPosI AS INTEGER)
DECLARE FUNCTION SustituyeVars$ ()
DECLARE FUNCTION VerificaVar% ()
' ************************************************

' Valor de 32 bits
TYPE RegistroVar
  Nombre AS STRING * 24
  Valor AS STRING * 8
END TYPE

DIM aregVariables(0 TO 0) AS RegistroVar ' Las variables de la operaci¢n
DIM strExpresion AS STRING              ' La cadena que se analizar 
DIM iError AS INTEGER                    ' El error ocurrido

' Constantes
CONST False = 0
CONST True = NOT False


' ********* Ciclo del programa principal ********
DIM strCadena AS STRING
DIM t AS STRING
DIM i AS INTEGER
DIM x AS INTEGER
DIM dblValor AS DOUBLE

CLS  ' Limpia la pantalla

' Ejec£tese el siguiente procedimiento antes de
'  cualquier otro procedimiento o funci¢n del m¢dulo.
Constructor

' Repita hasta obtener una N
PRINT "Programa que eval£a expresiones matem ticas simples. Teclea una"
PRINT "expresi¢n matem tica y oprime Enter para ver su resultado. Lee"
PRINT "el archivo LEASEYA.TXT (texto plano) para ver detalles de su uso."
PRINT "Puedes agregar variables a la expresi¢n."
PRINT
PRINT "This program interprets simple mathematical expressions. Write"
PRINT "one at the prompt and press Enter to see the results. Read the"
PRINT "file LEASEYA.TXT for further details (SPANISH). You can use"
PRINT "variables in the expression."
PRINT
DO
  doLimpiaVar                                 ' Limpia las variables
  INPUT "¨Cadena por evaluar"; strCadena      ' Obtiene la cadena
  setExpresion strCadena                     ' Asigna la cadena al m¢dulo
  getObtieneVar                               ' Obtiene las posibles variables
  x = CuentaVar                               ' Cuenta las variables obtenidas
  
  IF x > 0 THEN                               ' Si encontr¢ variables, pida sus valores.
    FOR i = 1 TO x                            ' Tantos valores, como variables haya.
      PRINT "¨Valor de " + NombreVar(i);      ' Muestre el nombre de la variable cuyo valor se solicita
      INPUT dblValor                          ' Capture el valor
      setNuevoValor LTRIM$(STR$(i)), dblValor ' As¡gnelo a la variable
    NEXT i
  END IF
  PRINT USING "###,###,###,###.####"; AnalizaExpr ' Muestre el resultado

  IF CErr > 0 THEN                                   ' ¨Ocurri¢ alg£n error?
    PRINT "Ocurri¢ el error" + STR$(CErr) + ": " + DErr  ' Muestre el mensaje de error
    PRINT
  END IF

  PRINT "¨Otra vez? (S/N)"                    ' ¨Desea volver a probar?
  PRINT
  DO
    t = INKEY$
  LOOP UNTIL UCASE$(t) = "S" OR UCASE$(t) = "N"  ' Obtenga S o N
LOOP UNTIL UCASE$(t) = "N"

' Aunque no es estrictamente necesario hacerlo, s¡ es
'  recomendable liberar los recursos utilizados por el
'  m¢dulo.
Destructor
PRINT "Fin del programa"                       ' Fin del programa
END

REM $STATIC
DEFSNG A-Z
' Lleva a cabo el an lisis de la f¢rmula
FUNCTION AnalisisFormula# (strFormula AS STRING)
  ' Var
  DIM dblNum1 AS DOUBLE
  DIM dblNum2 AS DOUBLE
  DIM dblRes AS DOUBLE
  DIM iOperacion AS INTEGER
  DIM strOperacion AS STRING * 1
  DIM strSigno AS STRING * 2
  DIM iPos AS INTEGER, iPosI AS INTEGER, iPosD AS INTEGER
  DIM iCuantosPar AS INTEGER, iPosParI AS INTEGER, iPosParD AS INTEGER
  CONST strSimbolo = "^^*/+-"  ' S¡mbolos que reconoce (Del m s importante al menos)
  SHARED iError AS INTEGER
  
  ' Crea una Sub-Cadena con los valores entre par‚ntesis
  iPos = 0
  iError = 0
  DO
    iPosParI = INSTR(strFormula, "(")
    IF iPosParI > 0 THEN
      iCuantosPar = 1
      iPosParD = iPosParI + 1
      DO UNTIL (MID$(strFormula, iPosParD, 1) = ")" AND iCuantosPar = 1) OR iPosParD > LEN(strFormula)
        IF MID$(strFormula, iPosParD, 1) = "(" THEN
          iCuantosPar = iCuantosPar + 1
        ELSEIF MID$(strFormula, iPosParD, 1) = ")" THEN
          iCuantosPar = iCuantosPar - 1
        END IF
        iPosParD = iPosParD + 1
      LOOP
      IF iPosParD > LEN(strFormula) THEN
        iError = 6
        EXIT FUNCTION
      END IF
      dblRes = AnalisisFormula(MID$(strFormula, iPosParI + 1, iPosParD - (iPosParI + 1)))
      strFormula = LEFT$(strFormula, iPosParI - 1) + LTRIM$(STR$(dblRes)) + MID$(strFormula, iPosParD + 1)
    END IF
  LOOP UNTIL iPosParI = 0
  
  ' Hace la operaci¢n
  iOperacion = 1
  DO
    strSigno = MID$(strSimbolo, (2 * (iOperacion - 1) + 1), 2)
    
    'Si uno de los operadores ( ^^ */ +- ) esta dentro de la operaci¢n
    IF INSTR(strFormula, LEFT$(strSigno, 1)) > 0 OR INSTR(strFormula, RIGHT$(strSigno, 1)) > 0 THEN
    
      'Si el primer operador (^*+) existe y se encuentra antes que el segundo operador (^/-)
      IF INSTR(strFormula, LEFT$(strSigno, 1)) <= INSTR(strFormula, RIGHT$(strSigno, 1)) AND INSTR(strFormula, LEFT$(strSigno, 1)) <> 0 THEN
        iPos = INSTR(strFormula, LEFT$(strSigno, 1))
        strOperacion = LEFT$(strSigno, 1)
        
      'Si el segundo operador(^/-) existe
      ELSEIF INSTR(strFormula, RIGHT$(strSigno, 1)) = 0 THEN
        iPos = INSTR(strFormula, LEFT$(strSigno, 1))
        strOperacion = LEFT$(strSigno, 1)
        
      'Si el primer operador (^*+) existe y se encuentra despues del segundo (^/-)
      ELSEIF INSTR(strFormula, LEFT$(strSigno, 1)) > INSTR(strFormula, RIGHT$(strSigno, 1)) AND INSTR(strFormula, LEFT$(strSigno, 1)) > 0 THEN
      
        'Si el primer caracter en la formula es un signo negativo, realiza la operacion con el operador de la izquierda (^*+)
        IF LEFT$(strFormula, 1) = "-" THEN
           iPos = INSTR(strFormula, LEFT$(strSigno, 1))
           strOperacion = LEFT$(strSigno, 1)
        ELSE 'de lo contrario realiza la operaci¢n con el operador de la derecha (^/-)
           iPos = INSTR(strFormula, RIGHT$(strSigno, 1))
           strOperacion = RIGHT$(strSigno, 1)
        END IF
      ELSE
        'La operaci¢n se realizar  con el operador de la derecha (^/-)
        strOperacion = RIGHT$(strSigno, 1)
        
        'Pero si el primer caracter es un signo negativo, realizar la operaci¢n con el operador de la derecha (^/-)
        IF LEFT$(strFormula, 1) = "-" THEN
           iPos = INSTR(2, strFormula, RIGHT$(strSigno, 1))
        ELSE
           iPos = INSTR(strFormula, RIGHT$(strSigno, 1))
        END IF
      END IF
        
      'Si es 1 lo mas probable es que se trate de un numero con signo negativo
      IF iPos > 1 THEN
        dblNum1 = NumIzq(strFormula, iPos, iPosI)
        dblNum2 = NumDer(strFormula, iPos, iPosD)
        SELECT CASE strOperacion
          CASE "^": dblRes = dblNum1 ^ dblNum2
          CASE "*": dblRes = dblNum1 * dblNum2
          CASE "/"
            IF dblNum2 = 0 THEN
              iError = 8
              dblRes = 0
            ELSE
              dblRes = dblNum1 / dblNum2
            END IF
          CASE "+": dblRes = dblNum1 + dblNum2
          CASE "-": dblRes = dblNum1 - dblNum2
        END SELECT
        
        'Si el primer car cter es un signo negativo y la operaci¢n a realizar es una suma
        IF LEFT$(strFormula, 1) = "-" AND strOperacion = "+" THEN
           'Si la posicion del operador es mayor que 1
           IF iPosI > 1 THEN 'Hay un numero negativo a la izq, por lo que hay que forzar la suma agragando el operador
              strFormula = LEFT$(strFormula, iPosI - 1) + strOperacion + LTRIM$(STR$(dblRes)) + MID$(strFormula, iPosD + 1)
           ELSE
              strFormula = LEFT$(strFormula, iPosI - 1) + LTRIM$(STR$(dblRes)) + MID$(strFormula, iPosD + 1)
           END IF
        ELSE
           strFormula = LEFT$(strFormula, iPosI - 1) + LTRIM$(STR$(dblRes)) + MID$(strFormula, iPosD + 1)
        END IF
        
      ELSE
        iOperacion = iOperacion + 1
      END IF
    ELSE
      iOperacion = iOperacion + 1
    END IF
  LOOP UNTIL iOperacion > 3

  AnalisisFormula = VAL(strFormula)

END FUNCTION

' Procedimiento p£blico para establecer si se realiza
'  el an lisis de la f¢rmula.
FUNCTION AnalizaExpr#
  ' Var
  DIM strFormulacion AS STRING
  SHARED iError AS INTEGER
  SHARED strExpresion AS STRING

  iError = 0
  IF strExpresion <> "" THEN
    IF SinAcentos(strExpresion) THEN
      getObtieneVar  ' Vuelve a verificar por si acaso
      IF VerificaVar THEN
        strFormulacion = SustituyeVars ' Hace una sustitución de variables
        AnalizaExpr = CalculaFormula(strFormulacion)
      ELSE
        iError = 4
        AnalizaExpr = 0
      END IF
    END IF
  ELSE
    iError = 5
    AnalizaExpr = 0
  END IF
END FUNCTION

FUNCTION BuscaVar% (CualVar AS STRING)
  ' Var
  DIM i AS INTEGER
  DIM x AS INTEGER
  DIM strCualVar AS STRING
  SHARED aregVariables() AS RegistroVar

  strCualVar = UCASE$(CualVar)
  i = 0
  x = UBOUND(aregVariables)
  IF x > 0 THEN
    DO
      i = i + 1
    LOOP UNTIL UCASE$(RTRIM$(aregVariables(i).Nombre)) = strCualVar OR i = x

    IF UCASE$(RTRIM$(aregVariables(i).Nombre)) <> strCualVar THEN
      i = 0
    END IF
  END IF

  BuscaVar = i
END FUNCTION

' Procedimiento privado para calcular la f¢rmula,
'  incluye la verificaci¢n de la ley de los signos (Alejandro Ju rez).
FUNCTION CalculaFormula# (strFormula AS STRING)
   DIM iPos AS INTEGER
   DIM i AS INTEGER
   DIM strSignos AS STRING
   DIM strLey AS STRING
   
   'Elimine los espacios en blanco para comprobar la ley de los signos
   DO
      iPos = INSTR(strFormula, SPACE$(1))
      IF iPos > 0 THEN
         strFormula = MID$(strFormula, 1, iPos - 1) + MID$(strFormula, iPos + 1)
      END IF
   LOOP UNTIL iPos = 0
   
   ' Haga cambios de acuerdo a la ley de los signos ( - por + igual a - ) etc
   strSignos = "+++--+--"
   FOR i = 1 TO 4
      strLey = MID$(strSignos, 1, 2)
      DO
         iPos = INSTR(strFormula, strLey)
         IF iPos > 0 THEN
            SELECT CASE strLey
               CASE "++", "--"
                 strFormula = MID$(strFormula, 1, iPos - 1) + "+" + MID$(strFormula, iPos + 2)
               CASE "+-", "-+"
                 strFormula = MID$(strFormula, 1, iPos - 1) + "-" + MID$(strFormula, iPos + 2)
            END SELECT
         END IF
      LOOP UNTIL iPos = 0
      strSignos = MID$(strSignos, 3)
   NEXT
   CalculaFormula = AnalisisFormula(strFormula)
END FUNCTION

FUNCTION CErr%
  ' Var
  SHARED iError AS INTEGER

  CErr = iError
END FUNCTION

SUB Constructor
  ' Var
  SHARED iError AS INTEGER
  SHARED strExpresion AS STRING
  SHARED aregVariables() AS RegistroVar

  ' Inicializa el valor de la cadena
  strExpresion = ""
  iError = 0
  REDIM aregVariables(0 TO 0) AS RegistroVar
END SUB

' Devuelve la cantidad de variables que hay en la memoria
FUNCTION CuentaVar%
  ' Var
  SHARED aregVariables() AS RegistroVar

  CuentaVar = UBOUND(aregVariables)
END FUNCTION

FUNCTION DErr$
  ' Var
  DIM strError AS STRING  ' La cadena con la descripci¢n del error ocurrido
  SHARED iError AS INTEGER
  
  ' Devuelve el texto del error ocurrido
  SELECT CASE iError
    CASE 0: strError = "La operaci¢n se realiz¢ con ‚xito"
    CASE 1: strError = "No se admiten caracteres especiales, acentuados o ¤"
    CASE 2: strError = "La variable indicada no existe"
    CASE 3: strError = "S¢lo se aceptan valores num‚ricos o Empty"
    CASE 4: strError = "Hay variables sin valores iniciales"
    CASE 5: strError = "No se ha asignado una expresi¢n por evaluar"
    CASE 6: strError = "Falta, al menos, un cierre de par‚ntesis"
    CASE 7: strError = "La variable indicada ya existe"
    CASE 8: strError = "No se puede dividir entre cero"
  END SELECT
  
  DErr = strError
END FUNCTION

SUB Destructor
  ' Var
  SHARED iError AS INTEGER

  ' Limpia las variables de la matriz y dem s. Esto no es
  ' necesario, pero es una buena pr ctica de programaci¢n
  ' liberar los recursos por uno mismo.
  setExpresion ""
  iError = 0
  doLimpiaVar
END SUB

' Elimina todas las variables del b£fer
SUB doLimpiaVar
  ' Var
  SHARED aregVariables() AS RegistroVar

  ERASE aregVariables
  REDIM aregVariables(0 TO 0) AS RegistroVar
END SUB

' Elimina la variable indicada en el par metro varVariable
SUB doRemVar (varVariable AS STRING)
  ' Var
  DIM i AS INTEGER
  DIM j AS INTEGER
  DIM x AS INTEGER
  DIM l AS INTEGER
  REDIM aregX(0 TO 0) AS RegistroVar
  SHARED iError AS INTEGER
  SHARED aregVariables() AS RegistroVar

  iError = 0
  i = VAL(varVariable)
  IF i = 0 THEN
    i = BuscaVar(varVariable)
  END IF

  IF i > 0 THEN
    x = UBOUND(aregVariables)
    REDIM aregX(0 TO x - 1) AS RegistroVar
    l = 0
    FOR j = 1 TO x
      IF j <> i THEN
        l = l + 1
        aregX(l) = aregVariables(j)
      END IF
    NEXT j
    x = x - 1
    REDIM aregVariables(0 TO x) AS RegistroVar
    FOR j = 1 TO x
      aregVariables(j) = aregX(j)
    NEXT j
    ERASE aregX
  ELSE
    iError = 2
  END IF
END SUB

FUNCTION Expresion$
  ' Var
  SHARED strExpresion AS STRING

  ' Obtiene la cadena por evaluar
  Expresion = strExpresion
END FUNCTION

' En este procedimiento se obtienen las cadenas que
'  conforman los nombres de variables incluidos en la
'  f¢rmula proporcionada. Este procedimiento localizar  las
'  variables que cumplan con los requisitos de una variable
'  aunque limitar  los nombres de las variables a 24 caracteres:
'  MisDatos, Dato1, Valor_Numerico.
' No aceptar  acentos en las variables. Si existen caracteres acentuados
'  o especiales, el procedimiento devolver  un error.
SUB getObtieneVar
  ' Var
  DIM strVariable AS STRING
  DIM strCaracter AS STRING * 1
  DIM iIniVar AS INTEGER
  DIM iInicio AS INTEGER
  DIM iFinal AS INTEGER
  DIM bFinVar AS INTEGER
  SHARED iError AS INTEGER
  SHARED strExpresion AS STRING
  SHARED aregVariables() AS RegistroVar
  
  iError = 0
  IF SinAcentos(strExpresion) THEN
    ' Verificar  la cadena para hallar nombres de variables
    iInicio = 1
    iIniVar = 0
    iFinal = 1
    DO WHILE iInicio <= LEN(strExpresion)
      strCaracter = UCASE$(MID$(strExpresion, iInicio, 1))
      IF strCaracter >= "A" AND strCaracter <= "Z" AND iIniVar = 0 THEN
        ' Localiz¢ una letra... Ahora localice d¢nde acaba el nombre de variable
        iFinal = iInicio + 1
        bFinVar = False
        DO
          IF iFinal <= LEN(strExpresion) THEN
            strCaracter = UCASE$(MID$(strExpresion, iFinal, 1))
            IF (strCaracter >= "A" AND strCaracter <= "Z") OR (strCaracter >= "0" AND strCaracter <= "9") OR strCaracter = "_" THEN
              iFinal = iFinal + 1
            ELSE
              bFinVar = True
            END IF
          ELSE
            bFinVar = True
          END IF
        LOOP UNTIL bFinVar
        
        ' Obtenga el nombre de la variable
        strVariable = MID$(strExpresion, iInicio, iFinal - iInicio)
        
        ' A¤ada la variable al conjunto de variables
        setNuevaVar strVariable
        iError = 0
        iInicio = iFinal
        iIniVar = 0
      ELSE
        IF (strCaracter >= "0" AND strCaracter <= "9") OR strCaracter = "." THEN
          IF iIniVar = 0 THEN
            iIniVar = iInicio
          END IF
        ELSE
          iIniVar = 0
        END IF
        iInicio = iInicio + 1
      END IF
    LOOP
  END IF
END SUB

' Devuelve el nombre de la variable que est  en la posici¢n indicada
FUNCTION NombreVar$ (iCualVariable AS INTEGER)
  ' Var
  SHARED iError AS INTEGER
  SHARED aregVariables() AS RegistroVar
  
  iError = 0
  IF iCualVariable > 0 AND iCualVariable <= UBOUND(aregVariables) THEN
    NombreVar = RTRIM$(aregVariables(iCualVariable).Nombre)
  ELSE
    iError = 2
    NombreVar = ""
  END IF
  
END FUNCTION

' Obtiene el n£mero a la derecha del signo encontrado
FUNCTION NumDer# (strCadena AS STRING, iPos AS INTEGER, iPosD AS INTEGER)
  ' Var
  DIM strCar AS STRING * 1
  DIM bNumero AS INTEGER
  
  iPosD = iPos + 1
  bNumero = False
  IF iPosD <= LEN(strCadena) THEN
    DO
      strCar = MID$(strCadena, iPosD, 1)
      IF (strCar >= "0" AND strCar <= "9") OR strCar = "." OR strCar = " " OR strCar = "-" THEN
        IF (strCar >= "0" AND strCar <= "9") OR strCar = "." THEN
          bNumero = True
        END IF
        
        IF iPosD < LEN(strCadena) THEN
          IF strCar = "-" AND NOT bNumero THEN
            iPosD = iPosD + 1
            bNumero = True
          ELSEIF strCar <> "-" THEN
            iPosD = iPosD + 1
          ELSEIF strCar = "-" THEN
            iPosD = iPosD - 1
            EXIT DO
          END IF
        ELSE
          EXIT DO
        END IF
      ELSE
        iPosD = iPosD - 1
        EXIT DO
      END IF
    LOOP

    NumDer = VAL(LTRIM$(RTRIM$(MID$(strCadena, iPos + 1, iPosD - iPos))))
  ELSE
    NumDer = 0
  END IF

END FUNCTION

' Obtiene el n£mero a la izquierda del signo encontrado
FUNCTION NumIzq# (strCadena AS STRING, iPos AS INTEGER, iPosI AS INTEGER)
  ' Var
  DIM strCar AS STRING * 1

  iPosI = iPos - 1

  IF iPosI > 0 THEN
    DO
      strCar = MID$(strCadena, iPosI, 1)
      IF (strCar >= "0" AND strCar <= "9") OR strCar = "." OR strCar = " " OR strCar = "-" THEN
        IF iPosI > 1 THEN
          IF (INSTR(strCadena, "^") > 0 OR INSTR(strCadena, "*") > 0 OR INSTR(strCadena, "/") > 0 OR INSTR(strCadena, "+") > 0) AND strCar = "-" THEN
            '***** CODIGO CORREGIDO ******'
            IF strCar = "-" THEN
               EXIT DO
            END IF
            iPosI = iPosI - 1
          ELSEIF strCar <> "-" THEN
            iPosI = iPosI - 1
          ELSE
            EXIT DO
          END IF
        ELSE
          EXIT DO
        END IF
      ELSE
        iPosI = iPosI + 1
        EXIT DO
      END IF
    LOOP

    NumIzq = VAL(LTRIM$(MID$(strCadena, iPosI, iPos - iPosI)))
  ELSE
    NumIzq = 0
  END IF
END FUNCTION

' Establece la cadena por evaluar
SUB setExpresion (strCualExpresionEvaluar AS STRING)
  ' Var
  SHARED strExpresion AS STRING

  strExpresion = strCualExpresionEvaluar
END SUB

' A¤ade una variable al contexto.
' Si la variable ya existe, no la
' agrega y devuelve un error.
SUB setNuevaVar (strNombre AS STRING)
  ' Var
  DIM i AS INTEGER
  DIM j AS INTEGER
  REDIM aregX(0 TO 0) AS RegistroVar
  SHARED iError AS INTEGER
  SHARED aregVariables() AS RegistroVar
          
  ' Localice si esta variable ya se encontraba en la colecci¢n
  iError = 0
  IF SinAcentos(strNombre) THEN
    i = BuscaVar(strNombre)

    IF i = 0 THEN
      i = UBOUND(aregVariables) + 1
      REDIM aregX(0 TO i) AS RegistroVar
      FOR j = 1 TO i - 1
         aregX(j) = aregVariables(j)
      NEXT j
      REDIM aregVariables(0 TO i) AS RegistroVar
      FOR j = 1 TO i - 1
         aregVariables(j) = aregX(j)
      NEXT j
      aregVariables(i).Nombre = strNombre
      aregVariables(i).Valor = ""
      ERASE aregX
    ELSE
      iError = 7
    END IF
  END IF
END SUB

' Establece un nuevo valor (varValor) para la variable indicada en varVariable
SUB setNuevoValor (varVariable AS STRING, varValor AS DOUBLE)
  ' Var
  DIM x AS INTEGER
  DIM i AS INTEGER
  SHARED iError AS INTEGER
  SHARED aregVariables() AS RegistroVar

  iError = 0
  i = VAL(varVariable)
  IF i = 0 THEN
    i = BuscaVar(varVariable)
  END IF

  IF i > 0 AND i <= UBOUND(aregVariables) THEN
    LSET aregVariables(i).Valor = MKD$(varValor)
  END IF
END SUB

' En esta funci¢n se determina si la cadena proporcionada
'  tiene o no acentos o caracteres extra¤os.
FUNCTION SinAcentos% (strCadena AS STRING)
  DIM i AS INTEGER
  DIM strCaracter AS STRING * 1
  DIM bCorrecto AS INTEGER
  SHARED iError AS INTEGER
  
  ' Eval£e si hay caracteres m s all  del 127 en la cadena
  iError = 0
  bCorrecto = True
  i = 127
  DO WHILE bCorrecto AND i < 256
    strCaracter = CHR$(i)
    IF INSTR(strCadena, strCaracter) > 0 THEN
      iError = 1
      bCorrecto = False
    END IF
    i = i + 1
  LOOP
  SinAcentos = bCorrecto
END FUNCTION

' Hace la sustutuci¢n de las variables por sus valores
FUNCTION SustituyeVars$
  ' Var
  DIM strMalos AS STRING
  DIM iEncontrado AS INTEGER
  DIM strVariable AS STRING
  DIM strCaracter AS STRING * 1
  DIM bCorrecto AS INTEGER
  DIM i AS INTEGER
  DIM j AS INTEGER
  DIM x AS INTEGER
  DIM strCadena AS STRING
  SHARED strExpresion AS STRING
  SHARED aregVariables() AS RegistroVar
  
  strCadena = UCASE$(strExpresion)
  strMalos = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
  x = UBOUND(aregVariables)
  FOR j = 1 TO x
    strVariable = UCASE$(RTRIM$(aregVariables(j).Nombre))
    iEncontrado = 1
    DO
      iEncontrado = INSTR(iEncontrado, strCadena, strVariable)
      IF iEncontrado > 0 THEN
        bCorrecto = True
        IF iEncontrado > 1 THEN
          strCaracter = MID$(strCadena, iEncontrado - 1, 1)
          bCorrecto = (INSTR(strMalos, strCaracter) = 0)
        END IF
        
        IF bCorrecto THEN
          strCaracter = MID$(strCadena, iEncontrado + LEN(strVariable), 1)
          bCorrecto = (INSTR(strMalos, strCaracter) = 0)
        END IF
        
        IF bCorrecto THEN
          strCadena = LEFT$(strCadena, iEncontrado - 1) + LTRIM$(STR$(Valor(strVariable))) + MID$(strCadena, iEncontrado + LEN(strVariable))
          iEncontrado = 1
        ELSE
          iEncontrado = iEncontrado + 1
        END IF
      ELSE
        iEncontrado = 1
      END IF
    LOOP UNTIL INSTR(iEncontrado, strCadena, strVariable) = 0
  NEXT j
  
  SustituyeVars = strCadena
END FUNCTION

' Obtiene el valor de la variable indicada en varVariable
FUNCTION Valor# (varVariable AS STRING)
  ' Var
  DIM i AS INTEGER
  SHARED aregVariables() AS RegistroVar
  SHARED iError AS INTEGER

  iError = 0
  i = VAL(varVariable)
  IF i = 0 THEN
    i = BuscaVar(varVariable)
  END IF

  IF i > 0 AND i <= UBOUND(aregVariables) THEN
    IF RTRIM$(aregVariables(i).Valor) <> "" THEN
      Valor = CVD(aregVariables(i).Valor)
    ELSE
      Valor = 0
      iError = 4
    END IF
  ELSE
    Valor = 0
    iError = 2
  END IF
  
END FUNCTION

' Verifica si las variables asignadas tienen valores todas
FUNCTION VerificaVar%
  ' Var
  DIM bCorrecto AS INTEGER
  DIM x AS INTEGER
  DIM i AS INTEGER
  SHARED iError AS INTEGER
  SHARED aregVariables() AS RegistroVar
  
  iError = 0
  bCorrecto = True
  x = UBOUND(aregVariables)
  IF x > 0 THEN
    FOR i = 1 TO x
      IF RTRIM$(aregVariables(i).Valor) = "" THEN
        iError = 4
        bCorrecto = False
        EXIT FOR
      END IF
    NEXT i
  END IF
  VerificaVar = bCorrecto
END FUNCTION

