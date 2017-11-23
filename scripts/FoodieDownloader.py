import codecs
import os.path

import facebook
import config

target_folder = "/var/www/html/ebedmenu/"

user = '494549960697458'

def writeMenu(message, filename):
    print("Writing" + filename)
    with codecs.open(filename, 'w', encoding='utf8') as f:
        lines = message.split("\n")
        in_menu = False
        for line in lines:
            if not in_menu and line.find("Leves") < 0:
                continue
            in_menu = True
            f.write(line + "\n")


graph = facebook.GraphAPI(config.FB_ACCESS_TOKEN)
profile = graph.get_object(user)
posts = graph.get_connections(profile['id'], 'posts')
i = 0
for post in posts["data"]:
    if i > 5:
        break
    if post["message"].find("Leves") < 0:
        print("Post is " + post["created_time"] + " not menu")
        continue
    timestamp = post["created_time"]
    filename = target_folder + "foodie_" + timestamp[:timestamp.find('T')] + ".txt"
    if not os.path.isfile(filename):
        writeMenu(post["message"], filename)
    else:
        print(filename + " already exists")
    i += 1






