#' Create objects of class \code{Dependency}
#'
#' Objects of the class are used to store information
#' about child docxuments.
#'
#' @param label The label associated with the document.
#' @param document Path to the output document. This should be
#' relative to the location of the main document.
#' @param source Path to source (i.e. RMarkdown) file used to generate \code{document}.
#' @param chunks List of chunk labels indicating the code chunks required.
#' @param title The title of the document.
#' @param cache Path to cache directory. If this is missing an attempt will be made to guess
#' the location if \code{source} is present.
#' @param index Named list of \code{data.frame}s indexing tables and figures. Alternatively entries
#' may provide the names of files with the relevant information.
#' @param ... Additional arguments are ignored.
#'
#' @details The \code{source} and \code{title} arguments may be omitted. If
#' no \code{title} is provided an attempt is made to extract it from the header
#' of the source file or, if that is unavailable (or no title was found),
#' the output document (but currently only for html output).
#' @return An object of class \code{Dependency}. Such objects have fields
#'  \item{label}{The label used to refer to this document.}
#'  \item{document}{The path to the output document.}
#'  \item{source}{The source document used to generate the output (may be \code{NULL}).}
#'  \item{title}{The document title. If no title is available this will be 'Untitled'}
#'  \item{cache}{Location of the cache directory.}
#'  \item{index}{List of data.frames with information on all Figures and Tables generated by the dependency.}
#'  \item{files}{Path to directory containing additional files associated with the dependency.}
#' @export
#' @importFrom stringr str_extract
#' @importFrom knitr opts_knit
Dependency <- function(label, document, source, chunks, title, cache, index, ...){
  dep <- list(label=label)
  if(!missing(source)){
    dep$source <- source
  }
  if(!missing(document)){
    dep$document <- document
  } else if(!is.null(dep$source)){
    dep$document <- dependency_output(dep$source)
  } else{
    warning("Unable to determine path to output document for dependency ", label)
  }
  doc_format <- tolower(stringr::str_extract(dep$document, '[^.]+$'))

  if(!missing(title)){
    dep$title <- title
  } else {
    extracted_title <- ''
    if(!is.null(dep$source)){
      extracted_title <- rmd_title(dep$source)
    } else if(doc_format == 'html'){
      extracted_title <- html_title(dep$document)
    }
    if(is.null(extracted_title) || extracted_title == ''){
      extracted_title <- 'Untitled'
    }
    dep$title <- extracted_title
  }

  if(!is.null(dep$source)){
    short_title <- rmd_short_title(dep$source)
  } else {
    short_title <- label
  }
  dep$short_title <- short_title

  if(missing(cache)){
    if(!is.null(dep$source)){
      cache <- file.path(dependency_subdir(dep$source, 'cache'), 'html')
    } else{
      cache <- NULL
    }
  }
  dep$cache <- cache

  if(missing(index) && !is.null(dep$source)){
    prefix <- stringr::str_replace(dep$source, '\\.[^.]+$', '')
    index <- list(figure=paste(prefix, 'figure.idx', sep='_'),
                  table=paste(prefix, 'table.idx', sep='_'))
  }
  dep$index <- index

  dep$files <- dependency_subdir(dep$source, 'files')
  dep$chunks <- list()
  if(!missing(chunks)){
    dep$chunks <- chunks
  }

  class(dep) <- 'Dependency'
  dep
}

#' Create objects of class \code{Download}
#'
#' Objects of this class hold the information necessary to create output files
#' containing data and results from the analysis as well as the links necessary
#' to access them from the HTML output.
#'
#' @param writer A function to write the downloadable content to a file. Its first
#' argument should be the R object to be written and the second argument the file name.
#' @param file_name Name of output file, not including any path information.
#' @param label A short, descriptive label to identify the download.
#' @param description A longer description of the downloadable content.
#' @param ... Additional arguments are passed to \code{writer}.
#'
#' @return An object of class \code{Download}
#' @note This class stores all the information necessary to create downloadable
#' files, but creating an instance of this class will not create the file.
#' Use \code{add_download} to add Instances of this class to the global list
#' of downloads. All downloads registered in this way will be created automatically
#' after the rest of the document has been processed and a section with download
#' links is added to the appendix. Download links can be created manually through
#' calls to \code{create_download}.
#'
#' @author Peter Humburg
#' @export
#'
#' @importFrom knitr opts_chunk
#' @importFrom stringr str_replace
Download <- function(writer, file_name, label, description, ...){
  download_dir <- knitr::opts_chunk$get('fig.path')
  download_dir <- stringr::str_replace(download_dir, 'figure-', 'download-')

  args <- list(...)
  dwnld <- list(target=paste0(download_dir, file_name),
                label=label,
                description=description,
                writer=writer,
                args=args,
                written=FALSE)
  class(dwnld) <- 'Download'
  dwnld
}
