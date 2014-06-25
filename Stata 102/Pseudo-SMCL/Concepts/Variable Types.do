/* {HEAD}

{TYPES!} */

{USE}
/*
{view `"{TYPES-}##strings"':1. Strings and Numerics}{BR}
{view `"{TYPES-}##destring"':2. Destring and Tostring}{BR}
{view `"{TYPES-}##encode"':3. Encode and Decode}{BR}

{hline}{marker strings}

{bf:1. Strings and Numerics}

{hline}

There are two types of variables within Stata: {bf:string} and {bf:numeric}.

{bf: What are strings?} A string is any data that is stored in Stata as text. 
Numbers, letters, and punctuation can all be part of a string. Examples of strings include
"What do you get what you multiply six by seven?", "42", "m&m", and "%".

Stata thinks of numbers differently whether they are strings or numerics. If a number is stored
as a string, Stata recognizes it not as a value, but as text, and would be treated in the same way 
letters would be. So if you added the string "4" to the string "2", you would get "42" and not "6". 

{bf: What are numerics?} Numerics can only contain numbers, no letters, symbols or punctuation 
(except periods). Numbers in numerical variables are recognized as values, and can be manipulated as such. 
So, if you added numeric "4" and "2", you would get 6. 

For example, a variable that has values (1, 2, 5, 6.5, 7, 99) is numeric.
A variable that contains respondent or village names, or the "other, specify" type of variables
(meaning variables where people have to write in their own answer) are string variables. 

{bf: Note:} If a variable contains even one non-numeric character it is considered to be a string. 
This may well be the result of a data entry error, say, specifying 'S' when the value was
supposed to be '5'. For example, a variable that has values (1, 0, O, 2, 5) would be a string, 
and not numeric, as was mostly likely intended. We'll see in the next {view `"{TYPES-}##destring"':section}
how to deal with such cases. 

There are a few methods to check whether the variable is string or numeric.
You can {cmd:describe} the variable or use the {cmd:codebook} command and verify the variable's
storage type. You can also simply look at the "Type" column in your variables window.
Any string will have str__ as its type (like str4, str11, str23), where the number after "str" (4, 11, 23)
is the number of characters of the longest value of the variable. 
All other types are the different subsets of numeric variables (e.g. byte, float, etc.)
You can learn more about each subset through the data types {helpb datatypes:help file}.

{marker quotesmissing}{...}
{TECH}
{COL}{bf:Quotation Marks and Missing Values}{CEND}
{MLINE}
{COL}One important thing to remember about strings is that they need to be{CEND}
{COL}enclosed in quotation marks, since they can contain spaces, commas,{CEND}
{COL}and other characters that would otherwise confuse Stata.{CEND}
{COL}When using the {cmd:display} comamnd with numerics you would execute:{CEND}
{BLANK}
{COL}{bf:{stata display 4 + 2}}{CEND}
{BLANK}
{COL}However, when displaying a string, or numeric looking text, you{CEND}
{COL}must use quotation marks. See:{CEND}
{BLANK}
{COL}{bf:{stata display "this phrase"}}{CEND}
{COL}{bf:{stata display "4 + 2"}}{CEND}
{BLANK}
{COL}Missing values are also identified differently. For strings, missing{CEND}
{COL}values are designated as two quotation marks without a space in between: ""{CEND}
{COL}For numerics, the equivalent designation is the period/dot: .{CEND}
{COL}Don't worry if you don't remember these distinctions right now,{CEND}
{COL}we'll return to these concepts throughout the trainings{CEND}
{BOTTOM}

{hline}{marker destring}

{bf:2. Destring and Tostring}

{hline}

The {cmd:destring} command converts string variables into numeric variables
while {cmd:tostring} makes numerics into strings.

These commands are very useful, since when you import data, Stata might create variables with an incorrect type.
As we saw earlier, this can happen with a numeric variable being recorded as a string
when there's some extraenous character in the numeric by mistake. Imagine an income
variable erroneously containing the value '9o' rather than 90. This would make the variable
a string, which would subsequently impede any numerical analysis of the variable. To see this in practice, 
try executing the {cmd:summarize} command on a string variable. However, imagine in
the cleaning process you catch this mistake and fix it, and now want to make the variable numeric to work with it. 

This is where {helpb destring:destring} comes in. The syntax is pretty straightforward, but note that the option
{bf:generate} (to generate a new variable name) or {bf:replace} (to replace the existing variable with the new one) must
be specified. When you first start off using these commands, it's recommended to use the {bf:generate}
option, so you can keep both variables and compare them to ensure the command worked as intended.  

{helpb tostring:tostring} uses the same syntax. Let's use both commands to get a sense of how they work. Observe that
the {bf:hhid} variable is a string, but imagine we want to convert it into a numeric. (Note: there is good reason why the
unique ID should be kept in string format, but let's change it just for the purposes of this exercise.) 

{TRYITCMD}
destring hhid, generate(hhid_num)
{DEF} 

We have now created a string version of {bf:hhid} called {bf:hhid_num}. Let's {cmd:browse}, {cmd:describe} and {cmd:summarize}
both variables. */

browse hhid hhid_num

describe hhid_num
summarize hhid_num

describe hhid
summarize hhid

drop hhid_num

/* Notice the differences in color when you {cmd:browse} and the differing output between both {cmd:summarize} commands. 

Let's now use {cmd:tostring} to convert a numeric to a string variable: 

{TRYITCMD}
tostring literateyn, generate(literateyn_str)
{DEF} 

We've created the new variable {bf:literateyn_str}. Let's take a look: */

browse literateyn literateyn_str
tabulate literateyn
tabulate literateyn_str

drop literateyn_str

/* What's going on here? Unlike {cmd:summarize}, the {cmd:tabulate} command works perfectly well
for both string and numeric variables. However, when we created the string variable, the
{view `"{NAMING-}##vallabels"':value labels} were dropped, so tabulate just displays the
underlying values. In addition, notice how the number of observations between the two variables is different.
Why did this occur?

{...}
{TECH}
{COL}Sometimes {cmd:tostring} will fail to convert a variable to string, delivering the{CEND}
{COL}warning "cannot be converted reversibly." For example:{CEND}
{BLANK}
{COL}{bf:{stata sysuse auto, clear}}{CEND}
{COL}{bf:{stata tostring gear_ratio, replace}}{CEND}
{BLANK}
{COL}The solution to this is not option {cmd:force}, which results in loss of{CEND}
{COL}information. Instead, use option {cmd:format(%24.0g)}:{CEND}
{BLANK}
{COL}{bf:{stata tostring gear_ratio, replace format(%24.0g)}}{CEND}
{BLANK}
{COL}Option {cmd:format(%24.0g)} works not just in this case to resolve the issue, but{CEND}
{COL}in all cases.{CEND}
{BLANK}
{COL}{bf:{stata {USE}}}{CEND}
{BOTTOM}

{hline}{marker encode}

{bf:3. Encode and Decode}

{hline}

As we have seen, {cmd:destring} and {cmd:tostring} offer a relatively simple way of converting
from a string variable to a numeric one and vice versa. One major disadvantage, is that
{cmd:tostring} does not preserve any value labels associated with the variable.
Without the {cmd:force} or {cmd:ignore()} options, {cmd:destring} cannot
be used with a variable unless it is composed solely of numbers. The solution to these issues is to use
{cmd:encode} and {cmd:decode}. You can convert a string variable to a value labeled numeric variable
using {helpb encode:encode}:

{TRYITCMD}
encode thanavisitreason, generate(visitreason)
{DEF} */

browse thanavisitreason visitreason

/* Each unique value of the variable was assigned a number, with each value label corresponding to the strings
of the original variable. However, it might make sense to define and apply one's own value label: */

label define visitreasonlab ///
	1  "To register a Crime" ///
	2  "To answer charges filed against you" ///
	3  "To say hello/to chat" ///
	97 "Refuse to answer" ///
	98 "Other" ///
	99 "Don't Know"

/* {...}
{TRYITCMD}
encode thanavisitreason, generate(visitreason2) label(visitreasonlab)
{DEF} */

browse thanavisitreason visitreason visitreason2 if visitreason != visitreason2

/* You can also convert a value labeled variable
to a string variable that contains the value label text
using {helpb decode}:

{TRYITCMD}
decode visitreason, generate(visitreasonstr)
{DEF} */

browse thanavisitreason visitreason visitreasonstr

/* Just like {cmd:destring} and {cmd:tostring}, {cmd:encode} and {cmd:decode}
are inverse operations.

If a string variable has all numeric values, convert it to numeric using {cmd:destring}.
If the variable does not have all numeric values,
use {cmd:encode} or use {cmd:destring} with option {cmd:ignore()} or {cmd:force}.

If a numeric variable is not value labeled, convert it to string using {cmd:tostring}.
If the variable is value labeled,
you can use {cmd:encode} to retain the value label text or
{cmd:tostring} for just the numeric values.

For more on the history of these sets of commands, see this interesting Stata
{browse "http://www.stata.com/support/faqs/data-management/destring-command/":FAQ post}.

{FOOT}

{NEXT}{DUPLICATES}
{PREV}{NAMING}
{START} */
