Stata_Training
==============

Houses IPA's Stata training courses and code. It contains the 102, 103, 104 and 202 trainings.

102 is the first version on SMCL, previous versions had appeared as a word document - will incorporate material from 103.

103 is similar to the training given at Kenya 2014, changes to made soon (removing Duplicates and Variable Properties modules, changing Loops module).

104 is the version prepared for Kenya 2014, main change since was to remove Logical Expressions module. 

202 is a module on Mata presented at the March 2014 Data Day.

The `Session Notes` folder contains notes from New Haven Stata trainings.

User-written programs
---------------------

Type the following commands in Stata to install the user-written programs used for the Stata training courses:

```
ssc install fastcd
```

Next, set up `fastcd` to work on your computer as follows:

```
* Change the working directory to the location of Stata_Training/Stata 202 on
* your computer.
cd ...
c cur train202
```

After this, the command `c train202` will change the working directory to `Stata_Training/Stata 202`.

`fastcd` is the name of the SSC package, not the command itself; the command is named `c`. To change the working directory, type `c` in Stata, not `fastcd`. To view the help file, type `help fastcd`, not `help c`.

Pseudo-SMCL
-----------

All three trainings make use of a modified form of SMCL named "pseudo-SMCL." The following is a guide to the pseudo-SMCL directives.

### Conventions and abbreviations

Directive | Description
:-------- | :----------
`/` | The opposite of another directive
`!` | A title/caption
`.` | Followed by `.`
`-` | A part/piece/substring
`--` | Followed by `{hline}`
`...` | Not followed by a page break (when a page break is the default)
`{DATA_*}` | Location of a dataset
`MOD` | Module
`PS` | Problem set
`ANS` | Answer key
`PREV` | Previous

### Essentials

Directive | Description
:-------- | :----------
`{BLOCK}` | Designate a command as part of a block. It will be rendered as text, and "Click here to execute" will appear below the block.
`"{O} "` | Stands for "observation." `{O}` by itself is meaningless: it must be followed by a space. Splits a pseudo-SMCL line into two lines in the SMCL file at the position of `{O}`. Used for lines too long for `Do to SMCL.do` (such as the header box) or (rarely) to start a new new paragraph.

### Problem sets

Directive | Description
:-------- | :----------
`{CT}` | Starts the comment delimiter `/*`.
`{CT/}` | Ends the comment delimiter `*/`.
`{SEMI}` | Semicolon: `;`
`{DQ}` | Double quote: `"`
`{LSQ}` | Left single quote: `` ` ``

### Question headers

Directive | Description
:-------- | :----------
`{Q#}` | Header for question `#`
`{Q#.}` | Header for question `#` followed by `.`
`{Q#--}` | Header for question `#` followed by `{hline}`
`{Q#ANS}` | Header for the answer to question `#`
`QTITLE` | Stands for "question title." `{Q#QTITLE}` becomes `{Q#--}` if ``!`isans'`` and `{Q#ANS}` otherwise.
`{AQ}` | Stands for "answer quote". If ``!`isans'``, does nothing. Otherwise, formats the quotation of a problem set question by italicizing it.

### Variables

Directive | Description
:-------- | :----------
`{VAR*}` | Used to save frequently referenced text unrelated to formatting.

### Headers, footers, and boxes

Directive | Description
:-------- | :----------
`{HEAD}` | The header box that links back to the start page. See above: search for "header directive."
`{HEAD1}` | Used in `{HEAD}`
`{PS!}` | The problem set caption
`{PSANS!}` | The caption for a problem set answer key
`{FOOT}` | The page footer
`{TECH}` | The top of a technical tips box
`{TRYIT}` | A "try it yourself" box
`{TRYITCMD}` | A "try it yourself" box followed by `{cmd}`

### Footer links

Directive | Description
:-------- | :----------
`{GOTOPS}` | Prefaces a link to a problem set.
`{TOMOD}` | Prefaces a link to a module.
`{NEXT}` | "Next" prefacing a link to the next page, aligned with a proceeding "Previous"
`{NEXT1}` | "Next" followed by one space, not aligned with a proceeding "Previous"
`{NEXTC}` | "Next concept" prefacing a link to the next concept, aligned with a proceeding "Previous concept"
`{NEXT1C}` | "Next concept" followed by one space, not aligned with a proceeding "Previous task"
`{NEXTT}` | "Next task" prefacing a link to the next task, aligned with a proceeding "Previous task"
`{NEXT1T}` | "Next task" followed by one space, not aligned with a proceeding "Previous task"
`{NEXT2T}` | Unused/obsolete
`{NEXT3T}` | "Next task" aligned with a preceding "Next concept"
`{PREV}` | Prefaces a link to the previous page.
`{PREVC}` | Prefaces a link to the previous concept.
`{PREVT}` | Prefaces a link to the previous task.
`{PREV2T}` | Unused/obsolete
`{ALTMAP}` | Stands for "alternative map." Links to the Alternative Table of Contents.

### Page links

Directive | Description
:-------- | :----------
`{[Mod. code]}` | Links to a module.
`{[Mod. code]!}` | Title of a module
`{[Mod. code]...}` | Links to a module, but isn't followed by a page break (a page break is the default).
`{[Mod. code]-}` | The location of a module's SMCL file
`{[Mod. code]_PS}` | Links to a module's problem set.
`{[Mod. code]_PS2}` | Links to a module's problem set, but with the simple link text "Problem set" rather than the module title.
`{[Mod. code]_ANS}` | Links to a module's answer key.
`{[Mod. code]_PS2}` | Links to a module's answer key, but with the simple link text "Answer key" rather than the module title.

### Box formatting

Directive | Description
:-------- | :----------
`{TOP}` | Top of a box
`{BOTTOM}` | Bottom of a box
`{COLSET}` | `{p2colset}` with arguments
`{RESET}` | `{p2colreset}{...}`
`{TLINE}` | Top line of a box
`{MLINE}` | Line in the middle of a box
`{BLINE}` | Bottom line of a box
`{COL}` | Start of a line in a box
`{CEND}` | Stands for "column end." End of a line in a box.
`{BLANK}` | A blank line in a box

### Formatting

Directive | Description
:-------- | :----------
`{P}` | Default paragraph indent: `{pstd}`
`{BR}` | Synonym for `{break}`
`{O#}` | `{O}` repeated `#` times
`{NEW}` | The end-of-line delimiter. Cannot be used to make `Do to SMCL.do` start a new paragraph: use `{O}` instead.
`{NEW#}` | Skip `#` lines. See above: search for "new line directives."
`{DEF}` | Stands for "default". Default text style: turns off bold, italics, underline, `{cmd}`, etc.
`{BF}` | `{bf}{...}`
`{IT}` | `{it}{...}`
`{UL}` | `{ul on}{...}`
`{CMD}` | `{cmd}{...}`

### Automatic problem set directive creation

In the problem set do-files, the following directives are used to automatically
create new directives. The following directives are not used in this do-file.
See above: search "automatic problem set directive creation."

Directive | Description
:-------- | :----------
`{PSQ:[directive]}` | Create a new directive `{[directive]}` for the text that follows. The directive ends when another `{PSQ:}` directive or `{FOOT}` is encountered.
`#define` | Define a new directive.

### Data: 103

Directive | Description
:-------- | :----------
`{DATA}` | The location of the training dataset
`{DATA_BASE}` | The base name of the training dataset
`{DATA_BACK}` | The location of the training dataset with backslashes instead of forward slashes
`{USE}` | The `use` command to load `{DATA}`
`{DATA_CASTECSV}` | The location of the caste names .csv file
`{DATA_CASTEDTA}` | The location of the caste names .dta file
