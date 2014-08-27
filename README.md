Stata_Training
==============

Houses IPA's Stata training courses and code.

101 is an intro to Stata - remains as a Word doc.

102 is the first version on SMCL, previous versions had appeared as a Word doc.

103 is similar to the training given at Kenya 2014, Duplicates and Variable Properties were removed, and Loops module changed.

104 is the version prepared for Kenya 2014, main change since was to remove Logical Expressions module.

201 is the New Hampshire 2013 Advanced training - will be cleaned up.

202 is a module on Mata presented at the March 2014 Data Day - will be expanded upon

The `Session Notes` folder contains notes from New Haven Stata trainings.

User-written programs
---------------------

Type the following commands in Stata to install the user-written programs used for Stata training development. These programs are not required for trainees who wish to complete the courses, but rather for those who wish to contribute to the training.

```
ssc install fastcd
```

Next, set up `fastcd` to work on your computer as follows:

```
* Change the working directory to the location of Stata_Training on
* your computer.
cd ...
c cur stata_training

* Change the working directory to the location of Stata_Training/Stata 202 on
* your computer.
cd ...
c cur train202
```

After this, the command `c stata_training` will change the working directory to `Stata_Training`; `c train202` will change it to `Stata_Training/Stata 202`.

`fastcd` is the name of the SSC package, not the command itself; the command is named `c`. To change the working directory, type `c` in Stata, not `fastcd`. To view the help file, type `help fastcd`, not `help c`.

Finally, add the `ado` directory and all its subdirectories to your [ado-path](http://www.stata.com/help.cgi?adopath).

Pseudo-SMCL
-----------

Courses 102 and above are written in a modified form of SMCL that we have uninventively named "pseudo-SMCL." See [this guide](/Documentation/Pseudo-SMCL.md) for details.
