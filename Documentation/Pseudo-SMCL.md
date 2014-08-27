Guide to Pseudo-SMCL
====================

Courses 102 and above are written in a modified form of SMCL that we have uninventively named "pseudo-SMCL." Pseudo-SMCL files are converted to SMCL files before being shared: their role is solely to facilitate the efficient creation of SMCL files, and they are not distributed to trainees on their own. Pseudo-SMCL files look like do-files, with runnable commands on their own lines and text in comments. [`Do to SMCL.do`](/Do to SMCL.do) converts such do-files to SMCL files, with comments converted to text in paragraph mode and commands enclosed in SMCL `{stata}` directives.

For instance, a pseudo-SMCL file may appear as follows:

```
* Load the auto dataset.

sysuse auto

* Summarize a variable.

summarize foreign
```

This example is so similar to a do-file that it is even runnable. `Do to SMCL.do` will then convert it to a nice SMCL file that can be used for training:

```
{pstd}Load the auto dataset.

{phang}{bf:{stata `"sysuse auto"'}}{p_end}

{pstd}Summarize a variable.

{phang}{bf:{stata `"summarize foreign"'}}{p_end}
```

SMCL directives in pseudo-SMCL comments pass through as-is to the SMCL file. The following pseudo-SMCL:

```
* Load the {it:auto} dataset.

sysuse auto
```

is converted to:

```
{pstd}Load the {it:auto} dataset.

{phang}{bf:{stata `"sysuse auto"'}}{p_end}
```

Code blocks such as loops are saved in a do-file outside the SMCL file. For each block, the SMCL file contains a `{stata}` directive that runs the corresponding block within the do-file.

Pseudo-SMCL also contains its own directives, listed in the sections below. By convention, their names are all uppercase. For instance, `{DEF}` is a pseudo-SMCL directive that restores the text style to its default: it is equivalent to the SMCL `{txt}{sf}{ul off}{...}`. Pseudo-SMCL directives are implemented through simple text substitutions: for example, `Do to SMCL.do` simply replaces all instances of `{DEF}` in pseudo-SMCL files with `{txt}{sf}{ul off}{...}`.

Pseudo-SMCL directives are implemented through simple substitutions, which means that while SMCL directives are not allowed on command lines, pseudo-SMCL directives are. For instance, the directive `{DATA}` may be associated with the dataset name `auto`. Then the following pseudo-SMCL:

```
* Load the auto dataset.

sysuse {DATA}
```

is converted to:

```
{pstd}Load the auto dataset.

{phang}{bf:{stata `"sysuse auto"'}}{p_end}
```

Note that the addition of pseudo-SMCL directives to command lines makes those files no longer runnable as do-files. There are other differences between pseudo-SMCL and do-files. For instance, do-files are more permissive as to where comment indicators may be placed.

Pseudo-SMCL is not consistent across the training courses: the exact substitutions may differ between 102 and 103, for instance. Each course is associated with its own pseudo-SMCL conversion do-file, usually named `Make SMCL *.do`, which calls `Do to SMCL.do` with the list of the course's pseudo-SMCL directives.

There are a few more advanced pseudo-SMCL directives. For instance, `#define` allows the definition of pseudo-SMCL directives on the fly from within pseudo-SMCL files. These newly defined directives may even be used in other pseudo-SMCL files.

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
