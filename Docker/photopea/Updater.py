#!/bin/python3

import sys
sys.path.insert(0,"_vendor")

import requests
import os
import re
import json
from tqdm import tqdm
from dataclasses import dataclass
import glob
import pprint

root = "www.photopea.com/"
website = "https://photopea.com/"
urls = [
    "index.html",
    "promo/thumb256.png",
    "rsrc/basic/basic.zip",
    "code/ext/hb.wasm",
    "code/ext/fribidi.wasm",
    "papi/tpls.json",
    "rsrc/fonts/fonts.png",
    "code/storages/deviceStorage.html",
    "code/storages/googledriveStorage.html",
    "code/storages/dropboxStorage.html",
    "img/nft.png",
    ["templates/?type=0&rsrc=","templates/index.html"],
    "templates/templates.js",
    "templates/templates.css",
    "plugins/gallery.json",
    "plugins/gallery.html",
    "img/wows_logo.png",
    "promo/icon512.png"
]



#Update files

def download_file(remote,local):
    if os.path.exists(local):
            #return --- Maybe make some flag for this
            pass
    with tqdm(desc=local, unit="B", unit_scale=True) as progress_bar:
        r = requests.get(remote, stream=True)
        progress_bar.total = int(r.headers.get("Content-Length", 0))

        if r.status_code != 200:
            progress_bar.desc += "ERROR: HTTP Status %d" % r.status_code
            return

        os.makedirs(os.path.dirname(local), exist_ok=True)
        with open(local, "wb") as outf:
            for chunk in r.iter_content(chunk_size=1024):
                progress_bar.update(len(chunk))
                outf.write(chunk)
def dl_file(path):
    if isinstance(path,list):
        outfn=path[1]
        path=path[0]
    else:
        outfn=path
        path=path

    download_file(website + path,root+outfn)

dl_file(urls[0]) #Always download the index.html page first

index = open(root+"index.html", encoding="utf-8").read()

regex_paths = {"_": r"style/all(\d+).css", "__": r"code/ext/ext(\d+).js", "DBS": r"code/dbs/DBS(\d+).js", "PP": r"code/pp/pp(\d+).js"}

for name, pattern in regex_paths.items():
    match = re.search(pattern, index)
    match = match.group(0)
    urls.append(match)
    if not name.startswith("_"):
        globals()[name]=match

for url in urls:
    dl_file(url)

db_data = open(root + DBS,encoding="utf-8").read()
db_vars = re.findall(r"var (\w+)\s*=\s*(\{[\w\W]+?\n\s*\})\s*(?=;|/\*|var)", db_data)
db = {}

for varname, vardata in db_vars:
    try:
        db[varname] = json.loads(vardata)
    except Exception as e:
        if varname=='FNTS':
            print("Unable to load DBS variable %s: %s" % (varname, e))

#Update fonts
@dataclass
class Font:
    ff: str
    fsf: str
    psn: str
    flg: int
    cat: int
    url: str


def decompress_font_list(flist):
    prev_ff, prev_fsf, prev_flg, prev_cat = "", "", "0", "0"
    for font in flist:
        ff, fsf, psn, flg, cat, url = font.split(",")
        if not ff:
            ff = prev_ff
        if not fsf:
            fsf = prev_fsf
        if not flg:
            flg = prev_flg
        if not cat:
            cat = prev_cat

        if not psn:
            psn = (ff + "-" + fsf).replace(" ", "")
        elif psn == "a":
            psn = ff.replace(" ", "")

        if not url:
            url = "fs/" + psn + ".otf"
        elif url == "a":
            url = "gf/" + psn + ".otf"

        yield Font(ff, fsf, psn, int(flg), int(cat), url)

        prev_ff, prev_fsf, prev_flg, prev_cat = ff, fsf, flg, cat

if '--fonts' in sys.argv:
    for font in decompress_font_list(db["FNTS"]["list"]):
        path = "rsrc/fonts/" + font.url
        if not os.path.isfile(root + path):
            print("Downloading " + font.url)
            dl_file(path)
            print("\n")

    #Delete any unused fonts
    fonts_db=[root+'rsrc/fonts/'+font.url for font in decompress_font_list(db["FNTS"]["list"])]

    fonts_local=[_ for _ in glob.glob(root + 'rsrc/fonts/**/*', recursive=True) if re.match(root+r'rsrc/fonts/(.*)/*.(otf|ttc|ttf)',_)]

    for font_file in list(set(fonts_local)-set(fonts_db)):
        print('Removing ' + font_file)
        os.remove(font_file)

if '--templates' in sys.argv:
    templates_db=['file/' + ('psdshared' if _[4].startswith("https://i.imgur.com/") or _[4].startswith("https://imgur.com/") else 'pp-resources') +'/' + _[3] for _ in json.load(open(root+"papi/tpls.json"))['list']]
    for template in templates_db:
        path="https://f000.backblazeb2.com/" + template
        outfn=root+"templates/"+template
        download_file(path,outfn)
    templates_local=[_ for _ in glob.glob(root + 'templates/file/**/*', recursive=True) if _.endswith(".psd")]
    templates_db=[root+"templates/"+_ for _ in templates_db]
    for tpl in list(set(templates_local)-set(templates_db)):
        print('Removing ' + tpl)
        os.remove(tpl)

def find_and_replace(file,find,replace):
    with open(os.path.join(root,file),'r') as pp:
        file1=pp.read()
    file1=file1.replace(find,replace)
    with open(os.path.join(root,file),'w') as pp:
        pp.write(file1)

#Allow any port to be used
find_and_replace(PP,'"\'$!|"))','"\'$!|"))||true')

#Don't load Google Analytics
find_and_replace('index.html','//www.google-analytics.com/analytics.js','')
find_and_replace('index.html', '//www.googletagmanager.com', '#')

#Allow the import of pictures of URLs (bypassing mirror.php)
find_and_replace(PP,'"mirror.php?url="+encodeURIComponent','')

#Allow Dropbox to load from dropboxStorage.html
find_and_replace('code/storages/dropboxStorage.html', 'var redirectUri = window.location.href;', 'var redirectUri = "https://www.photopea.com/code/storages/dropboxStorage.html";')

#Remove Facebook Pixel Domains
find_and_replace('index.html','https://connect.facebook.net','')

find_and_replace('index.html','https://www.facebook.com','')

#Redirect dynamic pages to static equivalent
find_and_replace(PP,'"&rsrc="','""')
find_and_replace(PP,'"templates/?type="','"templates/index.html?type="')
find_and_replace(PP,'"https://f000.backblazeb2.com/file/"', '"templates/file/"')

#Force enable Remove BG, and any other options that are disabled on self-hosted instances (much more brittle to changes than the other replacements)
find_and_replace(PP,'("~yy")','("~yy")||true')
# Having ? in static sites doesn't really work
#find_and_replace("templates/index.html",'sch.split("?");','sch.split("#");')
