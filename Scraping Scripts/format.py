import json
import os
import textwrap
import praw
from psaw import PushshiftAPI
from fpdf import FPDF
import fpdf
import re

#fpdf.set_global("SYSTEM_TTFONTS", os.path.join(os.path.dirname(__file__),'fonts'))


secret = "redacted"
name = "redacted"
clientID = "redacted"
developerName = "A3"
reddit = praw.Reddit(client_id=clientID,         # your client id
                               client_secret=secret,      # your client secret
                               user_agent=name) 

def deidentified(input_string):
    pattern = r'(?:^|\s)u\/[^\s.]+'
    # Example text
    text = "This is a test string with u/username and another u/secondUser. Also, u/third.user should not match."
    modified_text = re.sub(pattern, '', input_string)
    return modified_text

def format_post(post_json, max_line_length:int=108):
    """
    This is the main function for turing a reddit post json into something human readable
    """

    # First deal with post meta info
    s = 'title: {}\nnum_comments: {}\nnum_up_votes: {}\nupvote_ratio: {}\n'.format(
        '**' + textwrap.fill(post_json['title'], width=max_line_length, break_long_words=True) + '**',
        post_json['num_comments'],
        post_json['num_up_votes'],
        post_json['upvote_ratio']
    )

    # Now deal with the post text itself
    s += '\n**#### Post Text ####**\n\n'
    post_json['self_text'] = deidentified(post_json['self_text'])
    s += textwrap.fill(post_json['self_text'], width=max_line_length, break_long_words=True) + '\n\n**#### Comments ####**\n'


    # Initialize the user mapping

    # now deal with the comments
    return s + parse_comments(post_json['comments'], '', set(), {'##Unknown_User##': 'Unknown_User'}, max_line_length)

def parse_comments(comments:list, working_string: str, already_seen:set, users, max_line_length:int, current_depth:int=0):
    """
    The main recursive function for going through post comments
    """  
    for comment in comments:
        id = comment[1]
        if id not in already_seen:
            # Get the user for the comment
            comment_meta = reddit.comment(id)
            try:
                author = comment_meta.author.id
            except:
                try:
                    author = comment_meta.author.name
                except:
                    author = '##Unknown_User##'
                 
            print(author, users)
            if author not in users:
                if comment_meta.is_submitter:
                    users[author] = 'OP'
                else:
                    users[author] = 'Commenter_' + str(len(users) + 1)
            
            working_string += '\n' + format_comment(comment, users[author], max_line_length, current_depth)
            already_seen.add(id)
        
        working_string = parse_comments(comment[3], working_string, already_seen, users, max_line_length, current_depth + 1)

    
    return working_string
        

def format_comment(comment, author, max_line_length, current_depth):
    """
    This does textual formatting of a comment, including line wrapping
    """
    # First, calculate the number of indents
    indent = ""
    for i in range(current_depth):
        indent += "        "

    text = comment[0]
    id = comment[1]
    upvotes = comment[2]


    # Now, format each comment in the paragraph
    to_print = ['###### ' + author, 'ID: ' + 'REDACTED! ~(o.o)~ <3' + ', Upvotes: '+ str(upvotes)] + text.split('\n')
    s = ''
    one_slice = max_line_length - (len(indent)*.7)
    for paragraph in to_print:
        #s+= '\n'.join([indent + paragraph[i:i+one_slice] for i in range(0, len(paragraph), one_slice)]) +'\n'
        one_slice = int(one_slice)
        new_paragraph = deidentified(paragraph)
        wrapped_lines = [indent + x for x in textwrap.wrap(new_paragraph, width=one_slice, break_long_words=True)]
        s += '\n'.join(wrapped_lines) +'\n'
    return s    


def convert_txt_to_pdf(textFileLocation):
    # source: https://www.geeksforgeeks.org/convert-text-and-text-file-to-pdf-using-python/
    # save FPDF() class into
    # a variable pdf
    pdf = FPDF()  

    pdf.add_font("NotoSans", style="", fname="fonts/static/NotoSans-Regular.ttf", uni=True)
    pdf.add_font("NotoSans", style="B", fname="fonts/static/NotoSans-Bold.ttf", uni=True)
    pdf.add_font("NotoSans", style="I", fname="fonts/static/NotoSans-Italic.ttf", uni=True)
    pdf.add_font("NotoSans", style="BI", fname="fonts/static/NotoSans-BoldItalic.ttf", uni=True)
    pdf.add_font("NotoSans", fname="fonts/NotoColorEmoji-Regular.ttf", uni=True)
    pdf.add_font("NotoSans", fname="fonts/NotoEmoji-VariableFont_wght.ttf", uni=True)
    pdf.add_font("NotoSans", fname="fonts/OpenSansEmoji.ttf", uni=True)


        
    # Add a page
    pdf.add_page()
    
    # set style and size of font
    # that you want in the pdf
    pdf.set_font("NotoSans", size = 10)
    
    # open the text file in read mode
    f = open(textFileLocation, "r", encoding='utf-8', errors='replace')
    
    # insert the texts in pdf
    for x in f:
        if len(x) > 0 and x[-1] == '\n':
            x = x[:-1]
        pdf.cell(200, 5, txt = x, ln = 1, align = 'l', markdown=True)
    print(new_file)
    # save the pdf with name .pdf
    pdf.output(new_file[:-3] + 'pdf')  


if __name__ == "__main__":
    import sys
    file = open('r_ADHD_Programmers_Posts_all.json/r_ADHD_Programmers_Posts_all.json', encoding='utf-8', errors='replace')
    # posts = json.loads(file)
    # read into a string
    # split by {}
    # go through list and load as individual json file
    # for i  in posts:
    #     print(i["self_text"])
    s = ''

    for line in file:
        s += line
        if line.startswith("}"):
            obj = json.loads(s)
            #jsonstring = json.dumps(obj)
            #print(obj) 

            # Check if this file has already been made
            new_file = '/Users/A1/Desktop/ADHDProgrammers-1/deidentified_posts/' + obj['id'] + '.txt'
            if os.path.exists(new_file): 
                s = ''
                convert_txt_to_pdf(new_file)
                continue
            
            post_text = format_post(obj) + '\n'
            with open(new_file, 'w', encoding='utf-8', errors='replace') as outfile:
                outfile.write(post_text)
            convert_txt_to_pdf(new_file)

            s = ''