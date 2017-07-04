import facebook
import urllib.request
import subprocess

access_token = '582813855245984|_Rssln5VgoP05inf_FgincK4iy4'
user = '1055195294541029'
outfile = "/var/www/html/ebedmenu/bridges.jpg"

graph = facebook.GraphAPI(access_token)
profile = graph.get_object(user)
posts = graph.get_connections(profile['id'], 'posts')

postid= posts["data"][0]["id"].split("_")[1]

urllib.request.urlretrieve("https://graph.facebook.com/v2.8/"+postid+"/picture?access_token="+ access_token, outfile)

subprocess.check_call(['/home/pi/split-bridges.sh', outfile])
