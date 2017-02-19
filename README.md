# ReportMD --- Writing Complex Scientific Reports in R
Release: [![Build Status](https://travis-ci.org/humburg/reportmd.svg?branch=master)](https://travis-ci.org/humburg/reportmd) 
Development: [![Build Status](https://travis-ci.org/humburg/reportmd.svg?branch=develop)](https://travis-ci.org/humburg/reportmd) 

It is common for complex analyses to be carried out in R. To improve the
reproducability of such analyses and provide the necessary documentation
it is increasingly common to use literate programming techniques. Although
R has had the ability to embed R code in long-form documents describing
the analysis and presenting the results via [*Sweave*](https://www.statistik.lmu.de/~leisch/Sweave/), 
it has been the introduction of [*RMarkdown*](http://rmarkdown.rstudio.com/) 
that has driven the increasing popularity of this approach. The relative
simplicity of authoring [*Markdown*](https://daringfireball.net/projects/markdown/) 
documents and the ability to convert these into a large variety of output formats
via [*pandoc*](http://pandoc.org/) combined with the tight integration with 
[*RStudio*](https://www.rstudio.com/) make this approach easy to use and
powerful at the same time. 

RStudio's support for RMarkdown templates and custom
document formats has enabled the community to provide templates that are
tailored towards specific use cases and integrate well with RStudio. The
document format provided by *reportMD* was inspired by, and is in part based on, [knitrBootstrap](https://github.com/jimhester/knitrBootstrap).

Unlike currently available tools used to
facilitate this literate programming approach to data analysis *reportMD* 
focuses specifically on complex data analyses that may not be well suited to the
monolithic document format typical of RMarkdown. Complex analysis are best split into smaller units
but are likely to depend on the results of earlier stages of the analysis.
This R package aims to provide a number of features to support analyses
that are split across multiple RMarkdown files with cross-file dependencies
and enables multi-page HTML output.

An example of a report generated with *reportMD* is available [online](https://humburg.github.io/reportmd/).

## Installation
To install *reportMD* and some of the dependancies requires [*devtools*](https://github.com/hadley/devtools).
Users of [*RStudio*](https://www.rstudio.com/) will already have this installed,
otherwise `install.packages('devtools')` will take care of that.

The latest version of *reportMD* can be installed:

```r
devtools::install_github('humburg/reportMD')
```

## Getting started
The [Multi-document Rmarkdown template](inst/rmarkdown/templates/multipart_report/skeleton/skeleton.Rmd)
included in this package has detailed instructions and examples. In *RStudio* select 

>    File > New File > R Markdown > From Template > Multi-part Report {reportMD}

This will create a copy of the template in the current project. Open the file
*skeleton.Rmd* and click on RStudio's *Knit* button to compile the template into
a webpage.

Alternatively the template is available as part of the installed R package
and can be located via the R command
`system.file('rmarkdown/templates/multipart_report/skeleton', package="reportMD")`.

## Features
Current and planned features include:
- [x] Ability to declare required RMarkdown documents in yaml header;
    - [x] Dependencies are resolved and rendered to the requested output
      format when the parent document is rendered.
    - [x] Make declared dependencies available as reference links so that
      links to these documents can easily inserted into the text using 
      Markdown syntax.
- [x] Ability to automatically load the results of cached chunks from other
  other documents;
- [x] Avoid recompiling child documents whenever possible;
- [ ] Providing a shorthand to include figures and tables generated by other
  documents;
- [ ] Automatic numbering of figures and tables
    - [x] within each document.
    - [ ] across linked documents.
          