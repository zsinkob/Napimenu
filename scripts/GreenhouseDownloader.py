import codecs
import os.path

import facebook

access_token = '582813855245984|_Rssln5VgoP05inf_FgincK4iy4'

target_folder = "/var/www/html/ebedmenu/"

user = 'greenhousegrillferencvaros'

def isMenuLine(line):
    if (line.find("menü") > 0) or (line.find("étvágy") > 0) :
        return False
    else:
        return True

def writeMenu(message, filename):
    print("Writing" + filename)
    with codecs.open(filename, 'w', encoding='utf8') as f:
        lines = message.split("\n")
        for line in lines:
            if isMenuLine(line):
                f.write(line + "\n")


graph = facebook.GraphAPI(access_token)
profile = graph.get_object(user)
posts = graph.get_connections(profile['id'], 'posts')
i = 0
for post in posts["data"]:
    if i > 10:
        break
    if post["message"].find("menü") < 0:
        print("Post is " + post["created_time"] + " not menu")
        continue
    timestamp = post["created_time"]
    filename = target_folder + "greenhouse_" + timestamp[:timestamp.find('T')] + ".txt"
    if not os.path.isfile(filename):
        writeMenu(post["message"], filename)
    else:
        print(filename + " already exists")
    i += 1






