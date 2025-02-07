from github import Github, GithubException, RateLimitExceededException
from time import time, sleep
import csv
import langs as l

def github_connection():
    with open('token.txt', 'r') as file:
        token = file.read().strip()
    return Github(token)

def top_contributors(g, lang, writer):
    try:
        repos = g.search_repositories(query='stars:>=25 language:{}'.format(lang), sort='stars')
        for repo in repos[:100]:
            users = repo.get_contributors()
            for user in users[:25]:
                print(user, user.email, repo.name, flush=True)
                if user.email is None: continue
                writer.writerow({
                    'username': user.login,
                    'email': user.email,
                    'location': user.location,
                    'search_language': lang,
                    'public_repos': user.public_repos,
                    'bio': user.bio,
                    'company': user.company,
                    'contributions': user.contributions,
                    'followers': user.followers,
                    'name': user.name,
                    'url': repo.url})

    except GithubException as e:
        print(f"GitHub API error: {e.data}")

    except RateLimitExceededException:
        # Need to sleep until the rate limit is reset
        rate_limit = g.get_rate_limit().core
        reset_time = rate_limit.reset.timestamp()
        current_time = time.time()
        sleep_time = reset_time - current_time + 10  # Add 10 seconds buffer
        print(f"Rate limit exceeded. Sleeping for {sleep_time} seconds.")
        time.sleep(sleep_time)
        top_contributors(g, lang, writer)

    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    g = github_connection()

    # Go through the top 100 projects for each language, and get the top 25 developer profiles from each one
    # Note: This does not work for the linux kernel because there are too many developers
    with open('topcontribs_repos.csv', 'a', newline='') as csvfile:
        header = ['username', 'email', 
                'location', 'search_language', 
                'public_repos', 'bio', 
                'company', 'contributions', 
                'followers', 'name', 'url']
        writer = csv.DictWriter(csvfile, fieldnames=header)
        writer.writeheader()
        for language in l.langs:
            print(language)
            top_contributors(g, language, writer)