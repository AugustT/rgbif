#' Organizations metadata.
#' 
#' @import httr
#' @importFrom plyr compact
#' @param data The type of data to get. Default is all data.
#' @param uuid UUID of the data node provider. This must be specified if data
#'    is anything other than 'all'.
#' @param query Query nodes. Only used when data='all'
#' @param isocode A 2 letter country code. Only used if data='country'.    
#' @param callopts Further args passed on to GET.
#' @export
#' @examples \dontrun{
#' organizations()
#' organizations(uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
#' organizations(data='contact', uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
#' organizations(data='pending')
#' }
organizations <- function(data = 'all', uuid = NULL, query = NULL, callopts=list())
{
  args <- compact(list(q = query))
  
  data <- match.arg(data, choices=c('all', 'organization', 'contact', 'endpoint', 
                                    'identifier', 'tag', 'machinetag', 'comment', 
                                    'hostedDataset', 'ownedDataset', 'deleted', 
                                    'pending', 'nonPublishing'))
  
  # Define function to get data
  getdata <- function(x){
    if(!data %in% c('all','deleted', 'pending', 'nonPublishing') && is.null(uuid))
      stop('You must specify a uuid if data does not equal "all" and 
       data does not equal of deleted, pending, or nonPublishing')
    
    if(is.null(uuid)){
      if(x=='all'){
        url <- 'http://api.gbif.org/organization'
      } else
      {
        url <- sprintf('http://api.gbif.org/organization/%s', x)
      }
    } else
    {
      if(x=='all'){
        url <- sprintf('http://api.gbif.org/organization/%s', uuid)
      } else
      {
        url <- sprintf('http://api.gbif.org/organization/%s/%s', uuid, x)        
      }
    }
    content(GET(url, query=args, callopts))
  }
  
  # Get data
  if(length(data)==1){ out <- getdata(data) } else
  { out <- lapply(data, getdata) }
  
  out
}