# "Get Me In The Groove: A Mixed Methods Study on Supporting ADHD Programmers"
Repository for "Get Me In The Groove: A Mixed Methods Study on Supporting ADHD Programmers," to be published at [ICSE 2025](https://conf.researchr.org/home/icse-2025).

# Paper Abstract 
Understanding the work styles of diverse programmers can help build inclusive workplaces, enabling all software engineers to excel. An estimated 10.6% of programmers have *Attention Deficit Hyperactivity Disorder* (ADHD), a condition characterized by differences in attention and working memory. Prior work has just begun to explore the impact of ADHD on software development, finding that inadequate support may negatively impact team productivity and employment. This prevents software organizations from benefiting from ADHD-related strengths. To investigate these impacts, we conducted a two-phase mixed methods study. First, we qualitatively analyzed 99 threads (1,658 posts and comments) from r/ADHD_Programmers, the largest public forum dedicated to the ADHD programmer community. We constructed a mapping that reveals how ADHD programmers apply personal strategies and organizational accommodations to address software task-specific challenges. Second, we conducted a large-scale survey of 239 ADHD and 254 non-ADHD professional programmers to validate how our qualitative data generalize to the worldwide developer population. Our results show that ADHD programmers are 1.8 to 4.4 times more likely to struggle more frequently than neurotypical developers with all challenges we consider, but especially with time management and design. Our findings have implications for inclusive and effective tool- and policy-building in software workplaces and motivate further research into the experiences of ADHD programmers.

# Replication Package Contents
  -- Qualitative Analysis and Data
    Contains: A Data folder with all 99 threads we analyzed, our final codebook, and a spreadsheet indicating who did which passes in our three-pass thematic analysis (anonymized).
  -- Quantitative Analysis and Data
    Contains: Our survey instrument, standard_cleaning.R, for consistency checks and to clean data, and Rmd and knitted HTML files showing analysis results. Our main analysis script is in main_analysis.Rmd; we additionally did three other separate analyses to look at differences between other groups, including splitting on medication status for ADHD developers, developers with autism and ADHD, and diagnostic status for ADHD developers.
  -- Scraping Scripts
    Contains: Scripts we used to scrape and format Reddit posts and to look for public GitHub emails for survey recruitment.
    
# Step-by-step Guidance for Replication
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

# Note on Data Availability
We cannot publicly publish our (un-aggregated) data due to the sensitivity of our data and the stipulations of the IRB. If you are interested in working with the raw data from this study, please contact the first author at klnewman@andrew.cmu.edu and we can coordinate with you and our IRB to get you access to our deidentified data.

ᓚᘏᗢ
