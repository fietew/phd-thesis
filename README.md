# Local Sound Field Synthesis, PhD thesis

This repository contains supplementary material for the PhD thesis "Local Sound Field Synthesis" of Fiete Winter

## Software Requirements

### LaTeX

The repository was tested with pdfTeX 3.14159265-2.6-1.40.19 (TeX Live 2018). For the output of ``\listfiles`` showing the used packages and files, see [here](listfiles.log). In addition to the packages available on [CTAN](https://ctan.org), you need
* soundfield.sty [(repo)](https://github.com/fietew/soundfield)
* audioicons.sty

which are provided within the repository. The packages have to be installed manually.

#### Installation under Linux (Tex Live)

For current user:
``` 
cp soundfield.sty `kpsewhich -var-value TEXMFHOME`/tex/latex/ 
cp audioicons.sty `kpsewhich -var-value TEXMFHOME`/tex/latex/ 
```
System-wide (as root/using sudo):
```
cp soundfield.sty `kpsewhich -var-value TEXMFLOCAL`/tex/latex/
cp audioicons.sty `kpsewhich -var-value TEXMFLOCAL`/tex/latex/
texhash
```

### Gnuplot

The repository was tested under Gnuplot v5.0 patchlevel 3. You need the following Gnuplot extensions

* ColorBrewer color schemes for gnuplot [(doi)](https://doi.org/10.5281/zenodo.10282), [(repo)](https://github.com/aschn/gnuplot-colorbrewer)

In order to use the extensions their directories have to be included into Gnuplot's search path. This is done via the ``GNUPLOT_LIB``environment variable. Under Linux (and possibly Mac) execute

```Bash
# gnuplot search path
export GNUPLOT_LIB=~/projects/gnuplot-colorbrewer:$GNUPLOT_LIB
```

in a shell of your choice. You may also add this to your ``~/.bashrc`` or something (depends on the shell your are using) to execute this automatically. For Windows, see [here](https://www.computerhope.com/issues/ch000549.html). You can check, if the path is correcty included via ``show loadpath`` in the Gnuplot command prompt. Among other lines, this should display something like

```Bash
loadpath from GNUPLOT_LIB is "/home/bewater/projects/gnuplot-colorbrewer"
```
CAUTION: You cannot run most Gnuplot files without having the `soundfield.sty` from the LaTeX requirements installed

### MATLAB

The code of this repository has been tested under MATLABR2015a. Please add
the ``./matlab`` directory to your MATLAB path. You need the following toolboxes

* Sound Field Synthesis Toolbox v2.5.0 [(doi)](https://doi.org/10.5281/zenodo.2597212), [(repo)](https://github.com/sfstoolbox/sfs-matlab)
* Two!Ears Auditory Model v1.5 [(doi)](https://doi.org/10.5281/zenodo.1458420), [(repo)](https://github.com/TWOEARS/TwoEars)
* SOFA Matlab/Octave API v1.0 [(repo)](https://github.com/sofacoustics/API_MO)

The path of the toolboxes should be added to your MATLAB path. For specific installation instructions please take a look at the
listed websites.

## Contributors

* Hagen Wierstorf (Gnuplot)
* Till Rettberg and Sascha Spors (audioicons.sty for LaTeX)

## License Information

The software is released under GNU General Public License, version 3 

Any kind of artistic work (drawings, sketches, etc.) is released under Creative Commons Attribution 4.0 International (CC BY 4.0). 

This Material is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
