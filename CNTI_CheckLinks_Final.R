### Center for News, Technology & Innovation ###
## R script to check links in CNTI's issue primers ##
# Samuel Jens, CNTI


## Packages
#install.packages("tidyverse")
#install.packages("rvest")
#install.packages("RCurl")
#install.packages("httr")
#install.packages("httr2")

library(tidyverse)
library(rvest)
library(RCurl)
library(httr)
library(httr2)


## Issue primer links found on innovating.news
# "#"-ed out primers are still being developed
algorithms_quality_news <- "https://innovating.news/article/algorithms-quality-news/"
enhancing_algorithmic_transparency <- "https://innovating.news/article/enhancing-algorithmic-transparency/"
#evolving_technology_media <- "https://innovating.news/article/evolving-technology-media/"
building_news_sustainability <- "https://innovating.news/article/building-news-sustainability/"
modernizing_copyright_law <- "https://innovating.news/article/modernizing-copyright/" # issue with: https://www.bl.uk/business-and-ip-centre/articles/what-is-copyright
ai_in_journalism <- "https://innovating.news/article/ai-in-journalism/"
#deepfakes_manipulated_images <- "https://innovating.news/article/deepfakes-manipulated-images/"
#journalists_cybersecurity_threats <- "https://innovating.news/article/journalists-cybersecurity-threats/"
building_news_relevance <- "https://innovating.news/article/building-news-relevance/"
#enhancing_news_diversity <- "https://innovating.news/article/enhancing-news-diversity/"
addressing_disinformation <- "https://innovating.news/article/addressing-disinformation/"
#awful_but_lawful_information <- "https://innovating.news/article/awful-but-lawful-content/"
#journalists_online_abuse <- "https://innovating.news/article/journalists-online-abuse/"
protecting_open_internet <- "https://innovating.news/article/protecting-open-internet/"
#open_distribution_news <- "https://innovating.news/article/open-distribution-news/"


# Row bind all the URLs together
issue_primers <- rbind(algorithms_quality_news, enhancing_algorithmic_transparency,
                       building_news_sustainability, modernizing_copyright_law,
                       ai_in_journalism, building_news_relevance, 
                       addressing_disinformation, protecting_open_internet)


# Create an empty data frame to store results
dat <- data.frame(issue_primer = character(0), hyperlink = character(0), status_code = numeric(0))


# Function and for loop to iterate over issue primer links
hyperlink_status <- function(url){
  cat("Loading issue primer:", url, "\n")
  issue_primer <- read_html(url)
  links <- issue_primer %>% html_nodes("a") %>% html_attr("href")
  
  cat("Cleaning links \n")
  cleaned_links <- links %>% str_subset("https://")
  
  # Unique links only --- CAUTION removes duplicate hyperlinks
  #cleaned_links <- unique(cleaned_links)
  
  # Remove two links that cause issues :\
  cleaned_links <- cleaned_links[ !cleaned_links == "https://www.acma.gov.au/news-media-bargaining-code"]
  cleaned_links <- cleaned_links[ !cleaned_links == "https://www.esafety.gov.au/whats-on/online-safety-act"]
  #cleaned_links <- cleaned_links[1:16] # run a smaller subset of links for testing

  total_requests <- lapply(cleaned_links, request)
  
  for(i in seq_along(cleaned_links)){
    
    request_obj <- request(total_requests[[i]][["url"]])
    
    cat("=========================== \n")
    cat("Testing hyperlink", i,"of", length(total_requests), "\n")
   
    url_response <- request_obj %>% req_timeout(50) %>% req_user_agent("My user agent") %>% 
      req_error(is_error = \(url_response) FALSE) %>% req_perform()

    status_code <- as.numeric(url_response %>% resp_status())
  
    dat <- rbind(dat, data.frame(issue_primer = url, hyperlink = url_response$url, status_code = status_code))
  }
  return(dat)
}


## More stable to run individually (also more efficiently check for "broken" links)
#dat1 <- hyperlink_status(issue_primers[1]) # Yes
#dat2 <- hyperlink_status(issue_primers[2]) # Yes
#dat3 <- hyperlink_status(issue_primers[3]) # Yes
#dat4 <- hyperlink_status(issue_primers[4]) # Remove .au site -> Yes
#dat5 <- hyperlink_status(issue_primers[5]) # Yes
#dat6 <- hyperlink_status(issue_primers[6]) # Yes
#dat7 <- hyperlink_status(issue_primers[7]) # Yes
#dat8 <- hyperlink_status(issue_primers[8]) # Yes


## Work in progress -- not as stable as running individually
# Create empty data frame to store combined results
full_dat <- data.frame()


# Loop to test all the issue primers
for(issue_primer in issue_primers){
  dat <- hyperlink_status(issue_primer)
  
  full_dat <- rbind(full_dat, dat)
}


View(full_dat)

# n = 7,147 links (as of Friday, November 17, 2023)






