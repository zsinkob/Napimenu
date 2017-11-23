import codecs
from datetime import timedelta, datetime

import facebook
import config

TARGET_FOLDER = "/var/www/html/ebedmenu/"
FB_USER = 'gilicekonyha'
DAYS = ["hétfő", "kedd", "szerda", "csütörtök", "péntek"]

def writeMenu(message, filename):
	print("Writing" + filename)
	with codecs.open(filename, 'w', encoding='utf8') as f:
		lines = message.split("\n")
		for line in lines:
			f.write(line + "\n")

def isMenuPost(post):
	this_week = datetime.strptime(post["created_time"], '%Y-%m-%dT%H:%M:%S%z').date() > datetime.today().date() - timedelta(days=6)
	menu_post = "heti menü" in post["message"].lower()
	return this_week and menu_post

def processMenu(post):
	print("Weekly post found" + post["created_time"])
	menu_part = post["message"].split("HETI MENÜ")
	today = datetime.today()
	if len(menu_part) > 1:
		daily_menus = menu_part[1]
		current_day = 0
		for day_menu in daily_menus.strip().split("\n\n"):
			offset = datetime.today().weekday() - current_day
			print("dayoffset " + str(offset) + " for day " + str(current_day))
			calculated_date = datetime.today().date() - timedelta(days=offset)
			filename = TARGET_FOLDER + "gilice_" + calculated_date.isoformat() + ".txt"
			writeMenu(day_menu.replace(DAYS[current_day],'').strip(), filename)
			current_day += 1

def getMenu():
	graph = facebook.GraphAPI(config.FB_ACCESS_TOKEN)
	profile = graph.get_object(FB_USER)
	posts = graph.get_connections(profile['id'], 'posts')
	i = 0

	for post in posts["data"]:
		if i > 5:
			break
		if isMenuPost(post):
			processMenu(post)
		i += 1

if __name__ == "__main__":
	getMenu()




