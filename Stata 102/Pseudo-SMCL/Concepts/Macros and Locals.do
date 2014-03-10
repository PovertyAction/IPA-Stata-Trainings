/* {HEAD}

{MACROS!} */

{USE}
/* 
{view `"{MACROS-}##introduction"':1. Introduction}{BR}
{view `"{MACROS-}##declaring"':2. Declaring and Calling Macros}{BR}
{view `"{MACROS-}##examples"':3. Using Macros}{BR}
{view `"{MACROS-}##numerics"':4. Using Macros with Numerics}{BR}

{hline}{marker introduction}

{bf:1. Introduction}

{hline}

Up until now, we have worked solely with {view `"{TYPES-}"':variables} in Stata.
A Stata dataset is simply a collection of variables, sets of values,
which can be manipulated and analyzed in a variety of ways. However,
when writing code, variables have a number of drawbacks. In this chapter,
we’ll introduce an essential Stata concept, the macro.
We’ll explore macros through one particular type, the local.  

What is a macro? A macro simply stores a single value, and if you need
to save a value for later, it's often more convenient to attach it to a
macro than to create an entire variable for it.  Macros also facilitate
more complex code in a way that variables don't -- we'll get to that.

A macro is basically a symbol that you program Stata to read as something else;
for example, if you tell Stata that X means “Apples”, every time Stata sees X
it knows that you really mean “Apples”.

{hline}{marker declaring}

{bf:2. Declaring and Calling Macros}

{hline}

There are two steps to working with macros: 

{bf:1) Declare} or create a macro, i.e. tell Stata that from now on, whenever you say
X you mean "Apples". One way to declare a macro is as follows: 

{TRYITCMD}
local awesome "ipa and jpal"
{DEF}

Where "awesome" is the {it:local} macro, and "ipa & jpal" is the text it will
stand for in the future. Note that the macro in this case only reads ipa & jpal,
and the quotation marks aren’t treated as a part of the local.
In the declaration, Stata simply reads them to mean that you are showing
it text and not a variable or numbers.

{bf:2) Call} the macro you created, meaning you use the new macro to pull 
up the symbolized text. Local macros are called as follows: 

{TRYITCMD}
display "`awesome'"
{DEF}

As you can see, since you declared "awesome" to mean "ipa and jpal", every time
you call awesome, Stata will know you actually mean "ipa and jpal". 

{bf:Note} the characters ` and ' are used when calling a local macro (but not
when declaring it). Without these {bf:single quotes}, Stata will not recognize
the local as a local and will just treat it as text or as a variable. To see this,
let's execute the previous command without these single quotes */

display "awesome" 

/* Single quotes comprise a forward quote (`) which is located to the left of
the "1" key, and a normal quote mark (') found next to the "Enter" key. 

Also note that in this case, we need to enclose the local with {bf:double quotes} (" "),
since the text it calls up is a string and needs to be treated as such. What happens if 
we execute the following?*/

display `awesome' 

/* Why is the result an error? "ipa and jpal" is copied in the place of `awesome', and then
the command is executed. So far so good. However, what Stata ends up executing is*/

display ipa and jpal 

/* This we know will result in an error, as if you want to use the {helpb display} command to display
strings, you need to enclose them in double quotes. 

{TECH}
{COL}{bf:Locals}{CEND}
{MLINE}
{COL}Remember that a local is a subset of the larger category of macros.{CEND}
{COL}There are additional types of macros that can be created, however, for now,{CEND}
{COL}just know that the key characteristic of a local macro is that it only{CEND}
{COL}exists within the do-file that it was created. {CEND}
{COL}If you attempt to call `awesome' from another do-file, you'll find that{CEND}
{COL}it doesn't exist. We'll learn about different types of macros, namely{CEND}
{COL}globals, in {bf:Stata 103}.{CEND}
{BOTTOM}

{hline}{marker examples}

{bf:3. Using Macros}

{hline}

Macros might not seem so handy right now. After all, why can’t you just type "ipa & jpal"
instead of bothering with the macro? However, macros are useful in a variety of ways.
One is dealing with lists of variables, particularly those you need to reuse.
For example, imagine if you needed to summarize a whole bunch of variables repeatedly
across the file. Instead of typing them over and over again, you can create a macro for
the entire list of variables, and then input them into various commands.  

Control variables in regressions is a good exmaple. You can simply declare all
the controls in a macro and then refer to that in multiple regressions,
saving you loads of time. There are many other wonderful uses as well that are more advanced.
You will discover them all in time.

For now let’s try to get a hang of the format.
Let’s declare "i" as a local for number 1, and then generate a variable called "one"
that is equal to 1 throughout by using our local. 

{TRYITCMD}
local i 1
display "`i'"
generate one = `i'
{DEF}

There are many great things you can do with locals that will allow you to write neat code. 
For example you could nest a local within a local. Execute the following commands, and see
if you can figure out what's happening:*/

local a a1 a2 a3

local b b1 b2 b3

local ab `a' `b'

/* Let's now display the contents of the three locals we've just declared:*/

display "`a'"

display "`b'"

display "`ab'"

/* Does this make sense? The local `ab' was declared as a list comprising the contents of
local `a' along with the contents of local `b'. Note the first word following the {cmd:local}
command is the local name and all subsequent terms are the local's contents. Let's look at a
another example:*/

local aone "the first one"

local 1 "one"

display "`aone'"

display "`a`1''"

/* This result might be initially confusing. In the final line, the local `a`1'' is called. 
First, the embedded local (`1') is called and it is exanded into "one" as declared previously. 
Now the local reads simpmle `aone', which has already been declared as "the first one", and thus, 
that text is what is displayed. 

{hline}{marker numerics}

{bf:4. Using Macros with Numerics}

{hline}

It is important to note that locals don't have to be only strings, but they can also be numeric. 
When you set a local to a number, Stata recognizes it to be a value, not just text. This can be very
useful when writing code. As an example execute the following commands

{TRYITCMD}
local one 1
display 2 + `one'
{DEF}








{FOOT}

{NEXT}{LOOPS}
{PREV}{NAMING}
{START} */
