# hyperlink_status

The Center for News, Technology & Innovation (CNTI) pledges to regularly update its issue primers with new information and research. As part of this process, it is essential to check the hyperlinked material for any "broken" or non-working links. One option is to manually click through each hyperlink to ensure it directs to the intended site. However, this process is time consuming. We developed the function in CNTI_CheckLinks_Final.R to automate this process. 

We outline how the code works below should anyone like to apply it to their workflow, research, or personal interest.


As of November 21, 2023:


## Introduction to the Code:
The code is written in the R programming language and works best when using the R Studio IDE (integrated development environment). We include direct URLs to CNTI's issue primers for our own work, but these may be changed to any URLs a user pleases.

## The "hyperlink_status" Function:
The function takes a url as the input. These are read in as character objects in R. We use the "rvest" package to read the html and find all of the hyperlinks on the webpage. These hyperlinks are then cleaned. There are two websites we have cited that our code encounters trouble with and we remove them from the list of hyperlinks to ensure the code runs fully. We have checked and these are real links. 

We then create a list of the cleaned links that will be read into the for loop. We run the same code for each link in the list. The loop begins by making a request of the link which is saved as "request_obj." We then create an object named "url_response" that takes the "request_obj" are runs a series of commands on it. We allow the code to attempt a connection for 50 seconds (i.e., "req_timeout(50)) which enables websites that load slowly -- likely due to them being hosted outside the U.S. -- to be included and read fully. We pass in a user agent and request that any errors not stop the request. Finally, we gathering the information on the request by performing a response on the link.

We store the status code as a new object ("status_code"). Status codes in the 200 denote a request that is successfully received. One important note is that LinkedIn hyperlinks will return status codes in the 900s -- this is common. These links needed to be checked manually. 

Finally, we row bind the new information for each individual link together to create our main dataset for the issue primer. 

## The "final_dat" Section:
The "hyperlink_status" function is run on each issue primer one at a time. We row bind the "dat" dataset to our combined dataset named "final_dat" after each link has finished.

## Conclusion 
Please let us know if you have any questions about our code. Should you experience any issues while running the code, please contact us. 

Sincerely,
CNTI
