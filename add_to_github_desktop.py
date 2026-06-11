import os, subprocess, urllib.parse

vibes = os.path.expanduser('~/Desktop/vibes')
repos = [os.path.join(vibes, d) for d in sorted(os.listdir(vibes)) if os.path.isdir(os.path.join(vibes, d, '.git'))]

print(f"Adding {len(repos)} repos to GitHub Desktop...")
for r in repos:
    print(f"  {os.path.basename(r)}")
    subprocess.run(['open', f'github-mac://openRepo?path={urllib.parse.quote(r, safe="")}'])

print("Done.")
