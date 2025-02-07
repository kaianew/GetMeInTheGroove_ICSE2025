Hello, interested reviewers! Welcome to the replication package for our paper, "'Get Me In The Groove': A Mixed Methods Study on Supporting ADHD Professional Programmers."

What you will find in this package:
  -- Qualitative Analysis and Data
    Contains: A Data folder with all 99 threads we analyzed, our final codebook, and a spreadsheet indicating who did which passes in our three-pass thematic analysis (anonymized).
  -- Quantitative Analysis and Data
    Contains: Data (in final_cleaned.csv), our survey instrument, standard_cleaning.R, for consistency checks and to clean data, and Rmd and knitted HTML files showing analysis results. Our main analysis script is in main_analysis.Rmd; we additionally did three other separate analyses to look at differences between other groups, including splitting on medication status for ADHD developers, developers with autism and ADHD, and diagnostic status for ADHD developers.
  -- Scraping Scripts
    Contains: Scripts we used to scrape and format Reddit posts and to look for public GitHub emails for survey recruitment.
    
Here is how you can replicate our study:
1. In the Scraping Scripts folder: Run reddit_scraper.ipynb with your own client ID and secret keys. 
2. Put all text for each post into the empty spreadsheet seen in the Qualitative Analysis and Data folder called empty_post_categorization_spreadsheet.xslx. 
4. Go through all posts in the spreadsheet and manually annotate with multiple annotators whether posts fit into any of the identified columns (including and to the right of "Post is
job related"). 
5. Select 15 posts which fall under multiple key categories (of "Involves Accommodations...", "Involves Disclosure...", "Involves programming or SE-work-specific ADHD interaction...", and "Involves ADHD coping mechanism...") by filtering your spreadsheet of scraped posts.
6. In the Scraping Scripts folder: Run format.py to format the JSON files from step 1 into PDF formats.
7. Code these with multiple annotators using our codebook in the Qualitative Analysis and Data folder. We used a software called ATLAS.ti to do so.
8. Randomly select 21 more posts from each key category by filtering your spreadsheet of scraped posts.
9. Code these additional posts (totaling 99) with multiple annotators using our codebook.
10. Build the survey in the Quantitative Analysis and Data folder using the platform of your choice (we used Qualtrics).
11. Recruit via word of mouth, with posters in metro areas, from any mailing lists that may be interested, and via publicly-listed GitHub emails (which may be scraped if desired using main_scrape.py in the Scraping Scripts folder and your own GitHub access token) using the poster (Poster.pdf) and recruitment message (Recruitment message.pdf) in the Quantitative Analysis and Data folder.
12. When you've reached your desired sample size, cease data collection. Run main_analysis.Rmd in the Quantitative Analysis and Data folder on a .csv file of your data. Results will be printed within the notebook, and relevant results are organized by headers in knitted .html files (e.g., "Challenge Modeling By Software Task"). 

While we cannot publicly publish our data for privacy reasons -- including both the posts and comment threads from r/ADHD_Programmers and survey responses from our participants -- we plan to publish all other information in a public GitHub repository, should the paper be accepted. We will allow access to our data upon request and to reviewers during the review process, in accordance with our IRB. 

ᓚᘏᗢ