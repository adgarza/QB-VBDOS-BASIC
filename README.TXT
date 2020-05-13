       MATHEMATICAL EXPRESSIONS ANALYZER v1.0 and v2.0 FOR QBASIC (DOS)

This file contains a brief description about the properties and methods
of the module ANALIZEM.BAS (useful to analize simple matemathical expressions
and obtain its results).

This file is formatted in plain text, and is organized on themes. To go to
a particular theme, you just call the search option of your text editor, 
type the theme number to reach (enclosed into brackets []), and your
editor will take you to the theme. For instance, to go to the "Using
variables" theme, in the search facility of your editor type [3.0].

Note: all identifiers (Function, SUBs, Variable names and comments) are in
spanish language. This is due the origin of this module: Mexico. Because its
well structured programming, you can understand the program logic even if
you don't speak or understand spanish.

		       Index
Included files........................................................[0.0]
Module usage..........................................................[1.0]
Evaluating expressions................................................[2.0]
Using variables.......................................................[3.0]
Adding and removing variables.........................................[3.1]
Using functions (only version 2)......................................[3.2]
A final note..........................................................[3.3]
Summary of Functions and Procedures of the ANALIZEM Module............[4.0]
AnalizaExpr[#] (Function).............................................[4.1]
setExpresion (Procedure)..............................................[4.2]
Expresion[$] (Function)...............................................[4.3]
CErr[%] (Function)....................................................[4.4]
CuentaVar[%] (Function)...............................................[4.5]
DErr[$] (Function)....................................................[4.6]
doLimpiaVar (Procedure)...............................................[4.7]
NombreVar[$] (Function)...............................................[4.8]
setNuevaVar (Procedure)...............................................[4.9]
setNuevoValor (Procedure).............................................[4.10]
getObtieneVar (Procedure).............................................[4.11]
doRemVar (Procedure)..................................................[4.12]
Valor[#] (Function)...................................................[4.13]
Constructor (Procedure)...............................................[4.14]
Destructor (Procedure)................................................[4.15]


[0.0] Included files:
This ZIP archive includes the next files (all of Version 1.0a, except where noted):

ANALIZEM.BAS    The source code of the Mathematical expressions analyzer (QBASIC).
ANALIZEM.INC    File with the necessary declarations to use the program.
ANALIZEM.QLB    Library for QuickBASIC.
ANALIZEM.LIB    Library for use in a QuickBASIC compilation.
ANALIZEM.EXE    Executable wich shows an example of the use of the module.
ANALIZE2.ZIP    Source code of the version 2.0 of AnalizEM.
LEASEYA.TXT     Instructions in Spanish.
README.TXT      This file.


[1.0] Module usage:

The original module is a class generated in VB4.0 to be used in any version
of VB for Windows (4.0 or Up). This code has been adapted from the original
class, an preserves its class flavor. So, it can give the sensation to be
programming with objects in QBASIC, although this language does not provide
any support to this kind of programming.

Because its module approach, is easy to use its possibilities only by adding
it to your existing code. It's a short module, so your resources will be used
at the right way. This module, in its source code, can be used without
problems in QBASIC, QuickBASIC 4.5, PDS7 and VB-DOS.

This module can be executed by itself, because it includes an example code
to use it. It starts at the "Ciclo del programa principal" section of the
main code window. Its objetive is only show you how it works and its functionality.
If you don't own any of the programming languages indicated at the last paragraph,
you can execute the ANALIZEM.EXE file wich will show you the same output.

To use the module, you must add it to your QB, PDS or VB-DOS project. If you
don't know how to add modules to your project, consult your manuals or online help.

Once you added the module, you must copy, in all your existing modules wich needed,
the function declarations wich are marked by the ANALIZEM.BAS module. Next, you can
see the referred declarations:

' -----Copia estas declaraciones en tus m¢dulos ----
DECLARE SUB Constructor ()
DECLARE SUB Destructor ()
DECLARE SUB doLimpiaVar ()
DECLARE SUB doRemVar (Variable AS STRING)
DECLARE SUB getObtieneVar ()
DECLARE SUB setExpresion (strCualExpresion AS STRING)
DECLARE SUB setNuevaVar (strNombre AS STRING)
DECLARE SUB setNuevoValor (varVariable AS STRING, varValor AS DOUBLE)
DECLARE FUNCTION AnalizaExpr# ()
DECLARE FUNCTION Expresion$ ()
DECLARE FUNCTION CErr% ()
DECLARE FUNCTION CuentaVar% ()
DECLARE FUNCTION DErr$ ()
DECLARE FUNCTION NombreVar$ (iCualVariable AS INTEGER)
DECLARE FUNCTION Valor# (varVariable AS STRING)
' -----La copia es hasta aqu¡.---------------------------------

You can also find this declarations in the ANALIZEM.INC file, and you can
copy and paste them in your code, or include the file with an $INCLUDE 
directive. When you have a reference to this declarations, you can then use
the ANALIZEM module.

You can, too, use the ANALIZEM.QLB library in your program. Just put the
ANALIZEM.QLB and ANALIZEM.LIB files in the same folder where you have
your QB Libraries, and load your programming environment with the 
/l ANALIZEM switch. For instance: you can start QB with the following comand:

QB /l ANALIZEM

Next, you must copy (or include) the declarations on the ANALIZEM.INC file
on your program, and on every module wich can need them: 

' $INCLUDE: 'ANALIZEM.INC'

When you got the needed changes, you're ready to use the Mathematical
expressions analyzer for DOS. The basic form to use it is like this:

  Constructor              ' Must be executed before any other procedure
  setExpresion "5 + 3 * 8" ' Spaces don't matter
  PRINT "The result is: "; AnalizaExpr  ' Shows the results

So, in only three code lines, you will see the results in a text line
of the expression evaluated (Constructor only need to be executed
one time in the program).

[2.0] Evaluating expressions:

This module includes many procedures and functions. Of them, you only need
to use only seven procedures and seven functions to manage expressions
and variables. This module recognizes operators like potentiation (^),
multiplication (*), division (/), addition (+) and substraction (-).
There are an operator hierarchy. This hierarchy can be applied from
left to right. The first operator to be evaluated is the potentiation (^),
next (from left to right) the multiplications and the division, and,
finally, (again, from left to right) addition and substraction. This
version supports the verifications of the signs law.

You can state an expression like this:

  setExpresion "5 + 3 * 8"

The result will be 29 and not 64, because first will be executed the
multiplication (3 * 8 = 24), and the result will be added to 5 
(5 + 24 = 29). If you need that certain sections of the expression
be evaluated first, you can enclose the section into parentheses.
That way, to obtain 64, the right formula must be:

  setExpresion "(5 + 3) * 8"

The next example is valid, too:

  setExpresion = "(5 + (4 - 1)) * 8"

This way, the parentheses can be nested in the expression. The first
part wich will be evaluated will be that where the most internal
parentheses exist, and then the rest of the expression.

[3.0] Using variables:

This module can use variables in the expressions. You need to
provide the value of each variable contained in the expression to
have success in the evaluation. You could need an expression
like the next one:

  setExpresion "(a^2) + (2*(a*b)) + (b^2)"

Note that variable names must begin with a letter and can include
more letters, numbers, underscores or a combination of all. Please,
don't use accented or especial characters (like spanish ¤). Try not
to use variable names that exceed 24 characters in lenght. A lenghty
name can produce typing errors.

Next are valid variable names:
  
  x
  Value1
  CALCULATE12423423534
  Meta_Idustrial
  Statistical_Calculation_

(Variable names aren't case sensitive, so you can use diferent 
instances of a name interchangeably, like Value1, VALUE1, vAlUe1, etc.)

Following you'll see not valid variable names:

  10x
  Ni¤os.on.street
  C lculo
  Month_&_Year

The default value of variables is Null. You must assign a valid
value to a variable, before to evaluate the expression wich contains it.
Following you'll see an example of the way to assign values to 
variables (assuming you want to assign a=6 and b=15):

  setNuevoValor "a", 6
  setNuevoValor "b", 15

If you know the ordinal position of the variable in memory (such as
a is the first one, and b is the second one), you can assign the
values like this:

  setNuevoValor "1", 6
  setNuevoValor "2", 15

Note that the values must be encosed into quotation marks. This way,
you can refer a variable by any of the two means. When you execute
the analisis of the expression, the result must be 441.

The value to assign to the variable must be numeric. You can use the
procedure setNuevoValor as many times as you need to change the
values to the variables.

To see wich value contains certain variable, you can use the Valor method
like in the next example:

  PRINT Valor("a")
  IF CErr = 4 THEN  ' The variable hasn't been initialized
    PRINT DErr
  END IF

Valor method returns a double that can be 0 or any other numeric value
wich has been assigned to the variable. If, after the Valor method
execution you see that CErr (error key) has a value of 4, it means that
the variable hasn't been initialized.

[3.1] Adding and removing variables:

You can add variables in one of two ways:

The first one is letting that the module itself analyzes the string to
find intrinsic variables. This way, the module can tell you how many
variables were found. To do that you can use the doObtieneVar procedure:

  setExpresion "(a^2) + (2*(a*b)) + (b^2)"
  doObtieneVar

After that, the module will know that there are two variables: a and b. To
know how many variables found the module, you can use the CuentaVar function:

  Print "There are"; CuentaVar; " variables on memory."

The second way is with the help of the setNuevaVar method. This procedure
can be used as in the next example:

  setNuevaVar "MyVariable"

You will add a variable with the initial value of Null to the memory. Variables
are persistent. This means that all the names and values will be preserved
during all the program execution. This, obviously, can impact the use of 
resources. Nevertheless, you can remove variables by two means: doRemVar y
doLimpiaVar.

doRemVar allows to remove a given variable. In other words, if you wouldn't
need the "a" variable, you can execute the next code:

  doRemVar "a"

doLimpiaVar is more radical. It will remove all the variables from memory. The
next example:

  doLimpiaVar

will remove all the variables present in memory.

[3.2] Using Functions (Only version 2.0)

This version now supports several intrinsic mathematical and trigonometric
functions. Functions can be used similarly as those used in QuickBASIC,
QBASIC, PDS, VB-DOS and GWBASIC. There is a little difference: the use 
of the AT character (@). This way, the functions can be distiguished from 
variables wich have the same name. For use it, you must include the
needed function in the expression. For instance, you can obtain the 
sqare root of a given number with the next expression:

  setExpresion "@SQR(x)"

x will be the variable name from wich the square root will be calculated.
The analizer will parse this string, then evaluates and returns the
results. Note that you MUST include the parentheses, even if it don't include
any parameter (you will obtain an error if you avoid to do as it).

Functions can contain expressions enclosed in the parentheses. For instance, in
the following expression:

  setExpresion "@SQR(7+2)"

The result of its evaluation will be 3.

The functions, also, can be used as part of an operation. Assume that you 
want to obtain the logarithm base 10 of a number. Knowing that
the @LOG function wil return the natural logarithm (base e), what you
must to do is the next operation:

  setExpresion "(@LOG(x) / @LOG(10))"

The intrinsic functions are this:

Function| Description
--------+--------------------------------------------------------------------
@ABS(x) | Absolute value of x.
@ATN(x) | Arc tangent of x (in radians).
@COS(x) | Cosine of x (in radians).
@EXP(x) | Returns the exponential of x.
@LOG(x) | Calculates log base e of x.
@SGN(x) | Returns the sign of x (-1 if negative, 1 if positive, 0 if zero).
@SIN(x) | Returns the sine of x (in radians).
@SQR(x) | Returns the square root of x.
@TAN(x) | Returns the tangent of x (in radians).
@PI()   | Returns the number 3.141592654 (parentheses must be included).

[3.2.1] Additional notes (Alpha state):

Users of VB-DOS and PDS, you can use personalized functions. Users of QB and
QuickBASIC cannot do it due the lack of capacity to access to EXPANDED memory.
To add a new Function, you just need to use the setNuevaFuncion as following:

  setNuevaFuncion "@Log10", "@LOG(x)/@LOG(10)"

Where @Log10 is the identifier of the personalized function, and "@LOG(x)/@LOG(10)"
is the expression wich defines such function. Once defined, you can use it as
with any other intrinsic function:

  setExpresion "@LOG10(aNumber)"

Personalized functions can be nested, but be aware that the level of nesting can be
limited to your stack space. The functions are permanent, once you define one, you
can use it subsequently without the need of redefine. Such personalized functions 
and its definitions are saved into the ANALIZEM.FUN file (it's a binary file). At 
this time, you cannot remove personalized functions in other way than not include
the ANALIZEM.FUN in your program. Be careful to include the ANALIZEM.FUN file in
the same directory where your program runs, or you can obtain an error.

[3.3] A final note

This module is given to you "AS IS" and I will not take any responsability
of any error or damage caused directly or indirectly by its use. If you will
alter this code to enhance its capabilities, please include the present
document and include my credits. I had worked many hours in this and I think
that I deserve the credit for that.

Any question, recommendation or bug report, please write to my e-mail:

A. David Garza Marin
adgarza@spin.com.mx

Special Thanx to Marco A. Perez Lopez and Guillermo (El Guille) for its support
during the creation of this code in its original VB4 Class version. Also I
want to thank Alejandro Juarez the modifications to solve some minor bugs
and to recognize the law of signs on operations.

---------------------------------------------------------------------------
[4.0] Summary of Functions Resumen de Funciones y Procedures del m¢dulo ANALIZEM:

[4.1] AnalizaExpr[#] (Function)

Performs the analisis of the string formula assigned with the setExpresion Procedure.

Sintax:

[variable# = ]AnalizaExpr

Example:

PRINT AnalizaExpr

Note:

Be sure that you have assigned a formula string with the setExpresion procedure.
This function returns a value of type DOUBLE.

See also:

setExpresion.


[4.2] setExpresion (Procedure)

Assigns the string wich contains a mathematical expression to evaluate. This
string must have common operations such as potentiation, multiplication,
division, addition and substraction. You can include variables and parentheses.

Syntax:

setExpresion <stringValue>

Example:

setExpresion "5 * 7 + (a / c)"

Notes:

You can assign the value of the string to be evaluated with this procedure.
You can use this procedure as many times as you need.

See also:

AnalizaExpr


[4.3] Expresion[$] (Function)

Returns the string assigned with the setExpresion o "" if none has been assigned.

Syntax:

[variable# = ]Expresion

Example:

PRINT Expresion

Note:

Returns a value of STRING type.

See also:

AnalizaExpr



[4.4] CErr[%] (Function)

Returns the error code triggered.

Syntax:

[Variable = ]CErr

Example:

PRINT CErr

Notes:

The error codes returned are as following:

	0 (Operation succesfull)
	1 (Special or accented characters not allowed)
	2 (Variable name does not exist)
	3 (Only numeric or Empty values are accepted)
	4 (There are uninitialized variables)
	5 (Evaluation expression missing)
	6 (Parentheses pairs don't match)
	7 (The variable name already exists)
	8 (Cannot divide by zero)
        9 (Haven't executed the AnalizEM constructor)
        10 (Haven't defined the valid function name or expression) (Just Version 2)
        11 (Stated function does not exist) (Just Version 2)

Returns an INTEGER.

See also:

DErr


[4.5] CuentaVar[%] (Function)

Returns the number of variables locatend in memory.

Syntax:

[Variable = ]CuentaVar

Example:

IVariables = CuentaVar

Notes:

Returns an INTEGER.


[4.6] DErr[$] (Function)

Returns a string describing (in spanish) the error ocurred.

Syntax:

[Variable$ =]DErr

Example:

strError = DErr

Notes:

The error codes returned are as follow:

	0 (La operaci¢n se realiz¢ con ‚xito)
          (Operation succeeded)

	1 (No se aceptan caracteres especiales, acentuados o ¤)
          (Special characters, accents or ¤ not allowed)

	2 (La variable indicada no existe)
          (Variable name does not exist) 

	3 (S¢lo se aceptan valores num‚ricos o Empty)
          (Only numeric or Empty values allowed)

	4 (Hay variables sin inicializar)
          (There are uninitialized variables)

	5 (No se ha asignado una expresi¢n por evaluar)
          (Evaluation expression missing)

	6 (Falta, al menos, un cierre de par‚ntesis)
          (Parentheses pairs don't match)

	7 (La variable indicada ya existe)
          (The variable name already exists)

	8 (No se puede dividir entre cero)
          (Cannot divide by zero)

        9 (No se ha ejecutado el constructor del Analizador de expresiones matem ticas)
          (Haven't executed the AnalizEM constructor)

        10 (No se defini¢ el nombre o expresi¢n v lidos para la funci¢n) (S¢lo versi¢n 2)
           (Haven't defined the valid function name or expression) (Just Version 2)

        11 (No existe la funci¢n indicada) (S¢lo versi¢n 2)
           (Stated function does not exist) (Just Version 2)

Returns a STRING.

See also:

CErr


[4.7] doLimpiaVar (Procedure)

Removes from memory all the variables.

Syntax:

doLimpiaVar

Example:

doLimpiaVar

Notes:

Once removed, variables or its values cannot be recovered in any way.

See also:

doRemVar


[4.8] NombreVar[$] (Function)

Returns the name of the variable located at the stated position.

Syntax:

[variable = ]NombreVar(<position>)

Example:

CualVariable = NombreVar(1)

Notes:

position is a value between 1 and CuentaVar. If CuentaVar returns 0,
any attempt to call this function will return an error. Returns an INTEGER.


[4.9] setNuevaVar (Procedure)

Adds a new variable to the variable bag (stored in memory).

Syntax:

setNuevaVar <variableName>

Where:

	* variableName  is a string wich contains the name wich identifies
                        the variable.

Example:

setNuevaVar "MyVariable"

Notes:

The variable name must begin with a letter and can be followed by more
letters, numbers o underscores. This name can be up to 24 characters long.
Please, don't use accented or special characters (such & or ¤). The
default value of each added variable is Null ("").


See also:

setNuevoValor


[4.10] setNuevoValor (Procedure)

Sets a new value to the indicated variable.

Syntax:

setNuevoValor <variableNameOrNumber>, <numericValue>

Where:

	* variableNameOrNumber  is a string wich contains the name or number of
	  the selected variable.
	* numericValue is an argument with wich can change the actual value of
          the selected variablevalor. numericValue can be an INTEGER or REAL.

Example:

setNuevoValor "MyVariable", 50

Notes:

If the selected variable does not exist, you will obtain an error. If the
assigned value isn't incorrect, you will obtain, again, an error. If you
assign the value through a numeric variable other than the DOUBLE type, you
can obtain an error. To avoid this, you just use the QB intrinsic CDBL() function
to obtain the correct data type.

See also:

setNuevaVar


[4.11] getObtieneVar (Procedure)

Analizes the expression to evaluate and obtains all the contained variables.

Syntax:

getObtieneVar

Example:

getObtieneVar

Notes:

If there are not variables or there are not a string to evaluate, this
procedure will return 0 through the CuentaVar function (or the same 
number of variables that already exist on the variable bag). If in
the expression there are variable names with inadequate characters,
all the process of parsing will be aborted.

See also:

CuentaVar


[4.12] doRemVar (Procedure)

Removes the selected variable.

Syntax:

doRemVar <variableNameOrNumber>

Where
	* variableNameOrNumber is the name or number (enclosed in quotation marks)
	                       to remove.

Example:

doRemVar "MyVariable"

Notes:

If the specified variable does not exist, you'll obtain an error.

See also:
doLimpiaVar


[4.13] Valor[#] (Function)

Returns the value of the specified variable.

Syntax:

[variable# = ]Valor(<variableNameOrNumber>)

Where:
	* variable is some entity to wich the result will be assigned.
	* variableNameOrNumber is the identifier or variable number (enclosed in quotation
                               marks) from wich you want to obtain its value.

Example:

ElValor = Valor("MyVariable") 

Notes:

If the specified variable does not exist, you will obtain an error. This function
returns a value of type DOUBLE.

See also:
CuentaVar

[4.14] Constructor (Procedure)

Initializes al the processes. Is important to execute this procedure
before use any of the procedures or functions of the ANALIZEM module.

Syntax:

Constructor

Example:

Constructor 

Notes:

If you don't execute this procedure, you can obtain random errors
when trying to use any of the functions or procedures of the ANALIZEM module.

See also:

Destructor

[4.15] Destructor (Procedure)

Destroys all the values stored by te ANALIZEM module. Although it is not
necessary to execute this procedure, it is recommended to assure the
correct freeing of the memory and some other resources needed for the
module execution.

Syntax:

Destructor

Example:

Destructor 

Notes:

If you don't execute this procedure, you can misuse resources of the
environment. Moreover, is a good programming practice B-).

See also:

Constructor

